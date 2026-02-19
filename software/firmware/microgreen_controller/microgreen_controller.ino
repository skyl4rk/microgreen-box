// =============================================================================
// microgreen_controller.ino — Microgreen Box Firmware v1.0
// =============================================================================
// Hardware  : ESP32-WROOM-32 (38-pin dev board)
// Framework : Arduino (ESP32 Arduino Core)
//
// What this firmware does:
//   - Controls grow-light LEDs per tray on a 14 h/10 h photoperiod
//   - Enforces germination blackout (lights off days 0–2) per tray
//   - Runs peristaltic pump on a timed schedule (morning + evening)
//   - Reads capacitive moisture sensors; skips watering if coir is wet,
//     adds a top-up pass if coir stays dry after pumping
//   - Monitors reservoir float switch; sounds alarm when water is low
//   - Maintains a grow-day counter per tray across power cycles (EEPROM)
//   - Activates harvest LED + buzzer when a tray reaches harvest day
//   - Displays live status on 128×64 SSD1306 OLED (optional — works without)
//   - Blinks green LED as heartbeat; fast blink when any alarm is active
//   - Light-sleeps between 60-second check cycles to conserve power
//   - Single button (GPIO0/BOOT) seeds the next available tray
//
// Library dependencies (install via Arduino IDE → Manage Libraries):
//   RTClib           by Adafruit
//   Adafruit GFX     by Adafruit
//   Adafruit SSD1306 by Adafruit
//
// Serial commands (115200 baud, newline-terminated):
//   T<epoch>   Set RTC to Unix timestamp, e.g. "T1739836800"
//   S          Print full status dump
// =============================================================================

#include "config.h"
#include <Wire.h>
#include <EEPROM.h>
#include <RTClib.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "esp_sleep.h"
#include "driver/gpio.h"

// =============================================================================
// Hardware objects
// =============================================================================

RTC_DS3231       rtc;
Adafruit_SSD1306 oled(128, 64, &Wire, -1);

bool rtc_ok  = false;
bool oled_ok = false;

// =============================================================================
// Tray state
// =============================================================================

struct Tray {
    uint32_t seed_epoch;   // Unix timestamp when tray was seeded; 0 = empty
    int8_t   day;          // Current grow day (0 = seeded today; -1 = empty)
    uint8_t  moisture;     // Last moisture reading 0–100 %
    bool     light_on;     // Whether this tray's relay is currently energised
};

Tray trays[3];   // [0] = Tray A (bottom ring), [1] = B (middle), [2] = C (top)

// Parallel arrays matching tray index → GPIO pin
static const uint8_t RELAY_PINS[3]    = { PIN_RELAY_LED_A, PIN_RELAY_LED_B, PIN_RELAY_LED_C };
static const uint8_t MOISTURE_PINS[3] = { PIN_MOISTURE_A,  PIN_MOISTURE_B,  PIN_MOISTURE_C  };

// =============================================================================
// Pump log — tracks which daily watering events have already fired
// =============================================================================

struct PumpLog {
    uint16_t day_number;    // Days-since-epoch value on which events were recorded
    bool     event1_done;   // Morning event has fired today
    bool     event2_done;   // Evening event has fired today
};

PumpLog pump_log;

// =============================================================================
// Runtime state
// =============================================================================

bool pump_running     = false;
bool water_low_alarm  = false;
bool prev_water_low   = false;            // Previous state for transition detection
bool harvest_beeped[3] = {false, false, false};  // One-shot harvest alert per tray

// Button interrupt flag
volatile bool          button_event = false;
volatile unsigned long btn_press_ms = 0;

// Heartbeat (non-blocking, millis-based)
unsigned long heartbeat_ms = 0;
bool          heartbeat_hi = false;

// =============================================================================
// EEPROM layout (32 bytes total)
//   Addr  0      : magic byte (0xA5 = data valid)
//   Addr  1–4    : Tray A seed_epoch (uint32, little-endian)
//   Addr  5–8    : Tray B seed_epoch
//   Addr  9–12   : Tray C seed_epoch
//   Addr 13–14   : pump_log.day_number (uint16, little-endian)
//   Addr 15      : pump_log flags  bit0=event1_done  bit1=event2_done
//   Addr 16–31   : reserved
// =============================================================================

#define EEPROM_SIZE        32
#define EEPROM_MAGIC_ADDR   0
#define EEPROM_TRAY_BASE    1    // 3 × 4 bytes = addresses 1–12
#define EEPROM_PUMP_BASE   13    // 3 bytes
#define EEPROM_MAGIC_VAL  0xA5

static void eeprom_write32(int addr, uint32_t v) {
    EEPROM.write(addr,     (uint8_t)(v       & 0xFF));
    EEPROM.write(addr + 1, (uint8_t)(v >>  8 & 0xFF));
    EEPROM.write(addr + 2, (uint8_t)(v >> 16 & 0xFF));
    EEPROM.write(addr + 3, (uint8_t)(v >> 24 & 0xFF));
}

static uint32_t eeprom_read32(int addr) {
    return (uint32_t)EEPROM.read(addr)
         | ((uint32_t)EEPROM.read(addr + 1) <<  8)
         | ((uint32_t)EEPROM.read(addr + 2) << 16)
         | ((uint32_t)EEPROM.read(addr + 3) << 24);
}

static void save_state() {
    for (int i = 0; i < 3; i++)
        eeprom_write32(EEPROM_TRAY_BASE + i * 4, trays[i].seed_epoch);

    EEPROM.write(EEPROM_PUMP_BASE,
                 (uint8_t)(pump_log.day_number & 0xFF));
    EEPROM.write(EEPROM_PUMP_BASE + 1,
                 (uint8_t)((pump_log.day_number >> 8) & 0xFF));
    EEPROM.write(EEPROM_PUMP_BASE + 2,
                 (uint8_t)((pump_log.event1_done ? 1 : 0) |
                            (pump_log.event2_done ? 2 : 0)));
    EEPROM.commit();
}

static void load_state() {
    EEPROM.begin(EEPROM_SIZE);

    if (EEPROM.read(EEPROM_MAGIC_ADDR) != EEPROM_MAGIC_VAL) {
        // First boot: initialise to default (all trays empty)
        for (int i = 0; i < 3; i++) trays[i].seed_epoch = 0;
        pump_log = { 0, false, false };
        EEPROM.write(EEPROM_MAGIC_ADDR, EEPROM_MAGIC_VAL);
        save_state();
        Serial.println("EEPROM: first boot — defaults written");
    } else {
        for (int i = 0; i < 3; i++)
            trays[i].seed_epoch = eeprom_read32(EEPROM_TRAY_BASE + i * 4);

        uint16_t dn = (uint16_t)EEPROM.read(EEPROM_PUMP_BASE)
                    | ((uint16_t)EEPROM.read(EEPROM_PUMP_BASE + 1) << 8);
        uint8_t  fl = EEPROM.read(EEPROM_PUMP_BASE + 2);
        pump_log = { dn, bool(fl & 1), bool(fl & 2) };
        Serial.println("EEPROM: tray state restored");
    }
}

// =============================================================================
// Relay helpers
// LOW-level trigger module: LOW = relay energised = load ON
// =============================================================================

static inline void relay_on (uint8_t pin) { digitalWrite(pin, LOW);  }
static inline void relay_off(uint8_t pin) { digitalWrite(pin, HIGH); }

// =============================================================================
// Grow day calculation
// Returns -1 for empty tray, or 0..127 for active tray.
// =============================================================================

static int8_t compute_day(uint32_t seed_epoch, uint32_t now_epoch) {
    if (seed_epoch == 0 || now_epoch < seed_epoch) return -1;
    int32_t days = (int32_t)((now_epoch - seed_epoch) / 86400UL);
    return (int8_t)min(days, (int32_t)127);
}

// =============================================================================
// Moisture sensor reading
// ADC1, 12-bit (0–4095), 3.3 V reference.
// Capacitive V1.2: dry air = high counts, saturated = low counts.
// Averages 8 samples to reduce ADC noise. Returns 0–100 %.
// =============================================================================

static uint8_t read_moisture(uint8_t pin) {
    int32_t sum = 0;
    for (int i = 0; i < 8; i++) {
        sum += analogRead(pin);
        delayMicroseconds(500);
    }
    int raw = (int)(sum / 8);
    int pct = map(raw, MOISTURE_DRY_RAW, MOISTURE_WET_RAW, 0, 100);
    return (uint8_t)constrain(pct, 0, 100);
}

// =============================================================================
// Float switch
// NC contact. Float down (water LOW) → contacts closed → GPIO pulled LOW → alarm.
// Float up  (water OK)  → contacts open  → GPIO pulled HIGH by INPUT_PULLUP.
// =============================================================================

static bool water_is_low() {
    return digitalRead(PIN_FLOAT_SWITCH) == LOW;
}

// =============================================================================
// Button ISR — debounced falling edge on GPIO0 (active-low)
// =============================================================================

void IRAM_ATTR on_button_isr() {
    unsigned long t = millis();
    if (t - btn_press_ms > BUTTON_DEBOUNCE_MS) {
        button_event = true;
        btn_press_ms = t;
    }
}

// =============================================================================
// Seed the next available tray
// Available = seed_epoch == 0 (never used) OR day >= GROW_DAYS (cycle complete).
// Searches trays in order A → B → C. If all are active, flashes red.
// =============================================================================

static void seed_next_tray(uint32_t now_epoch) {
    for (int i = 0; i < 3; i++) {
        if (trays[i].seed_epoch == 0 || trays[i].day >= GROW_DAYS) {
            trays[i].seed_epoch = now_epoch;
            trays[i].day        = 0;
            harvest_beeped[i]   = false;
            save_state();
            Serial.printf("Tray %c seeded at epoch %lu (day 0)\n",
                          'A' + i, (unsigned long)now_epoch);
            // Three quick green flashes to confirm
            for (int f = 0; f < 3; f++) {
                digitalWrite(PIN_LED_GREEN, HIGH); delay(80);
                digitalWrite(PIN_LED_GREEN, LOW);  delay(80);
            }
            return;
        }
    }
    // No tray available — five quick red flashes
    Serial.println("Button: no tray available to seed (all active)");
    for (int f = 0; f < 5; f++) {
        digitalWrite(PIN_LED_RED_A, HIGH); delay(60);
        digitalWrite(PIN_LED_RED_A, LOW);  delay(60);
    }
}

// =============================================================================
// Run the pump
//
// Pre-run:  if skip_check is false, evaluate moisture only for ESTABLISHED
//           trays (day > GERMINATION_WATER_DAYS). Germinating trays are
//           excluded from the skip/topup decisions — seeds were just soaked
//           and over-watering days 0–GERMINATION_WATER_DAYS is the primary
//           cause of damping-off (Pythium). Germinating trays still receive
//           water when established trays trigger a run; they just cannot
//           trigger runs themselves.
//           Skip if: no established trays exist, OR all established trays
//           read >= MOISTURE_SKIP_THRESHOLD.
// Main run: pump runs for PUMP_RUN_SECONDS.
// Post-run: wait MOISTURE_SETTLE_SECONDS, re-read moisture for all active
//           trays; trigger top-up only if any ESTABLISHED tray still reads
//           below MOISTURE_TOPUP_THRESHOLD.
// =============================================================================

static void run_pump(bool skip_check) {
    if (!skip_check) {
        // Only established trays (past germination window) drive watering decisions.
        bool any_established = false;
        bool any_dry         = false;
        for (int i = 0; i < 3; i++) {
            if (trays[i].day > GERMINATION_WATER_DAYS) {
                any_established = true;
                if (trays[i].moisture < MOISTURE_SKIP_THRESHOLD)
                    any_dry = true;
            }
        }
        if (!any_established) {
            Serial.println("Pump: skipped — all active trays in germination period");
            return;
        }
        if (!any_dry) {
            Serial.println("Pump: skipped — all established trays are adequately moist");
            return;
        }
    }

    // Main pump run
    Serial.printf("Pump: ON (%d s)\n", PUMP_RUN_SECONDS);
    pump_running = true;
    relay_on(PIN_RELAY_PUMP);
    delay((unsigned long)PUMP_RUN_SECONDS * 1000UL);
    relay_off(PIN_RELAY_PUMP);
    pump_running = false;
    Serial.println("Pump: OFF");

    // Allow coir to absorb water before re-reading
    Serial.printf("Pump: settling %d s...\n", MOISTURE_SETTLE_SECONDS);
    delay((unsigned long)MOISTURE_SETTLE_SECONDS * 1000UL);

    // Re-read all active trays for display; top-up only for established trays.
    bool needs_topup = false;
    for (int i = 0; i < 3; i++) {
        if (trays[i].day >= 0) {
            trays[i].moisture = read_moisture(MOISTURE_PINS[i]);
            if (trays[i].day > GERMINATION_WATER_DAYS &&
                trays[i].moisture < MOISTURE_TOPUP_THRESHOLD)
                needs_topup = true;
        }
    }

    if (needs_topup) {
        Serial.printf("Pump: top-up (%d s)\n", PUMP_TOPUP_SECONDS);
        pump_running = true;
        relay_on(PIN_RELAY_PUMP);
        delay((unsigned long)PUMP_TOPUP_SECONDS * 1000UL);
        relay_off(PIN_RELAY_PUMP);
        pump_running = false;
        Serial.println("Pump: top-up OFF");
    }
}

// =============================================================================
// Light schedule
// Each tray's relay is set independently based on its grow day and the hour.
// Relay state is only changed when it needs to change (avoids relay chatter).
// =============================================================================

static void apply_lights(int hour) {
    bool photoperiod_active = (hour >= PHOTO_ON_HOUR && hour < PHOTO_OFF_HOUR);

    for (int i = 0; i < 3; i++) {
        // Light is ON only when: tray is past blackout days AND in photoperiod
        bool want_on = (trays[i].day > BLACKOUT_DAYS) && photoperiod_active;

        if (want_on != trays[i].light_on) {
            if (want_on) relay_on(RELAY_PINS[i]);
            else         relay_off(RELAY_PINS[i]);
            trays[i].light_on = want_on;
            Serial.printf("Light %c: %s\n", 'A' + i, want_on ? "ON" : "OFF");
        }
    }
}

// =============================================================================
// Watering schedule
// Resets the daily pump log when the day-number changes (midnight rollover).
// Fires each event once per day at the configured hour.
// =============================================================================

static void apply_watering(int hour, uint16_t today) {
    // New day: reset event flags
    if (pump_log.day_number != today) {
        pump_log = { today, false, false };
        save_state();
    }

    if (hour == WATER_HOUR_1 && !pump_log.event1_done) {
        pump_log.event1_done = true;
        save_state();
        Serial.println("Watering: event 1 (morning)");
        run_pump(false);

    } else if (hour == WATER_HOUR_2 && !pump_log.event2_done) {
        pump_log.event2_done = true;
        save_state();
        Serial.println("Watering: event 2 (evening)");
        run_pump(false);
    }
}

// =============================================================================
// Status indicators
// Yellow LED tracks water alarm state every loop.
// Red LEDs track harvest-ready state every loop.
// Buzzer: two beeps on water-low rising edge; one beep on first harvest event.
// =============================================================================

static void update_indicators() {
    // Yellow: water low
    digitalWrite(PIN_LED_YELLOW, water_low_alarm ? HIGH : LOW);

    // Red A: Tray A harvest ready
    bool ha = (trays[0].day >= HARVEST_DAY && trays[0].day >= 0);
    digitalWrite(PIN_LED_RED_A, ha ? HIGH : LOW);

    // Red BC: Tray B or C harvest ready
    bool hbc = (trays[1].day >= HARVEST_DAY && trays[1].day >= 0)
             || (trays[2].day >= HARVEST_DAY && trays[2].day >= 0);
    digitalWrite(PIN_LED_RED_BC, hbc ? HIGH : LOW);

    // Buzzer: water alarm rising edge (not every loop)
    if (water_low_alarm && !prev_water_low) {
        for (int b = 0; b < 2; b++) {
            digitalWrite(PIN_BUZZER, HIGH); delay(200);
            digitalWrite(PIN_BUZZER, LOW);  delay(150);
        }
        Serial.println("ALARM: reservoir water low — please refill");
    }

    // Buzzer: one-shot harvest alert per tray
    for (int i = 0; i < 3; i++) {
        if (trays[i].day >= HARVEST_DAY && trays[i].day >= 0 && !harvest_beeped[i]) {
            harvest_beeped[i] = true;
            digitalWrite(PIN_BUZZER, HIGH); delay(400);
            digitalWrite(PIN_BUZZER, LOW);
            Serial.printf("Tray %c: harvest ready (day %d)\n", 'A' + i, trays[i].day);
        }
    }

    prev_water_low = water_low_alarm;
}

// =============================================================================
// Heartbeat LED — call once per loop (non-blocking)
// Slow blink (1000 ms period): system OK
// Fast blink ( 200 ms period): alarm active
// =============================================================================

static void heartbeat_tick() {
    unsigned long interval = water_low_alarm ? 200UL : 1000UL;
    if (millis() - heartbeat_ms >= interval) {
        heartbeat_hi = !heartbeat_hi;
        digitalWrite(PIN_LED_GREEN, heartbeat_hi ? HIGH : LOW);
        heartbeat_ms = millis();
    }
}

// =============================================================================
// OLED display (128×64, text size 1 = 6×8 px per character)
// Layout — 6 rows × 10 px spacing:
//   Row  0:  HH:MM  Day DD/MM        (time and date)
//   Row 10:  Water: OK / LOW REFILL  (reservoir status)
//   Row 20:  A: D03 M 45%            (tray A)
//   Row 30:  B: D07 M 60%            (tray B)
//   Row 40:  C: D10 M 72% HARVEST    (tray C)
//   Row 52:  Pump: idle  next 07:00  (pump status)
// =============================================================================

static void update_display(const DateTime &now) {
    if (!oled_ok) return;

    oled.clearDisplay();
    oled.setTextSize(1);
    oled.setTextColor(SSD1306_WHITE);

    static const char *DOW[] = { "Sun","Mon","Tue","Wed","Thu","Fri","Sat" };
    char buf[22];

    // Row 0: time and date
    snprintf(buf, sizeof(buf), "%02d:%02d %s %02d/%02d",
             now.hour(), now.minute(), DOW[now.dayOfTheWeek()],
             now.day(), now.month());
    oled.setCursor(0, 0);
    oled.print(buf);

    // Row 10: water status
    oled.setCursor(0, 10);
    oled.print(water_low_alarm ? "Water:LOW  REFILL!" : "Water: OK");

    // Rows 20–40: per-tray status
    for (int i = 0; i < 3; i++) {
        oled.setCursor(0, 20 + i * 10);
        if (trays[i].day < 0) {
            snprintf(buf, sizeof(buf), "%c: empty", 'A' + i);
        } else if (trays[i].day <= BLACKOUT_DAYS) {
            snprintf(buf, sizeof(buf), "%c: D%02d germinating", 'A' + i, trays[i].day);
        } else if (trays[i].day >= HARVEST_DAY) {
            snprintf(buf, sizeof(buf), "%c: D%02d M%3d%% HARVEST",
                     'A' + i, trays[i].day, trays[i].moisture);
        } else {
            snprintf(buf, sizeof(buf), "%c: D%02d M%3d%%",
                     'A' + i, trays[i].day, trays[i].moisture);
        }
        oled.print(buf);
    }

    // Row 52: pump status
    oled.setCursor(0, 52);
    if (pump_running) {
        oled.print("Pump: RUNNING");
    } else {
        int next_h = (now.hour() < WATER_HOUR_1) ? WATER_HOUR_1
                   : (now.hour() < WATER_HOUR_2) ? WATER_HOUR_2
                   : WATER_HOUR_1;
        snprintf(buf, sizeof(buf), "Pump: idle  next %02d:00", next_h);
        oled.print(buf);
    }

    oled.display();
}

// =============================================================================
// Serial diagnostics — prints on every loop iteration
// =============================================================================

static void print_status(const DateTime &now) {
    Serial.printf("--- %04d-%02d-%02d %02d:%02d  Water:%s ---\n",
                  now.year(), now.month(), now.day(),
                  now.hour(), now.minute(),
                  water_low_alarm ? "LOW" : "OK");
    for (int i = 0; i < 3; i++) {
        if (trays[i].day < 0) {
            Serial.printf("  Tray %c: empty\n", 'A' + i);
        } else {
            Serial.printf("  Tray %c: day %-2d  moisture %3d%%  light %-3s%s\n",
                          'A' + i, trays[i].day, trays[i].moisture,
                          trays[i].light_on ? "ON" : "OFF",
                          trays[i].day >= HARVEST_DAY ? "  HARVEST READY" : "");
        }
    }
}

// =============================================================================
// Serial command handler (call every loop)
//   T<epoch>  — set RTC clock
//   S         — print full status dump
// =============================================================================

static void handle_serial(uint32_t now_epoch) {
    if (!Serial.available()) return;
    String cmd = Serial.readStringUntil('\n');
    cmd.trim();
    if (cmd.length() == 0) return;

    if (cmd[0] == 'T' || cmd[0] == 't') {
        uint32_t epoch = (uint32_t)cmd.substring(1).toInt();
        if (epoch > 1000000000UL) {
            if (rtc_ok) {
                rtc.adjust(DateTime(epoch));
                Serial.printf("RTC set to %lu\n", (unsigned long)epoch);
            } else {
                Serial.println("RTC not detected — cannot set time");
            }
        } else {
            Serial.println("Invalid epoch (must be > 1000000000)");
        }
    } else if (cmd[0] == 'S' || cmd[0] == 's') {
        Serial.println("=== Status dump ===");
        for (int i = 0; i < 3; i++) {
            Serial.printf("  Tray %c: seed_epoch=%lu  day=%d  moisture=%d%%  light=%s\n",
                          'A' + i,
                          (unsigned long)trays[i].seed_epoch,
                          trays[i].day, trays[i].moisture,
                          trays[i].light_on ? "ON" : "OFF");
        }
        Serial.printf("  pump_log: day=%u  event1=%d  event2=%d\n",
                      pump_log.day_number, pump_log.event1_done, pump_log.event2_done);
        Serial.printf("  water_low=%d  rtc_ok=%d  oled_ok=%d\n",
                      water_low_alarm, rtc_ok, oled_ok);
    } else {
        Serial.println("Commands: T<unix_epoch>  S");
    }
}

// =============================================================================
// setup()
// =============================================================================

void setup() {
    Serial.begin(115200);
    delay(200);
    Serial.println("\n=== Microgreen Box v1.0 ===");

    // --- Relay outputs: HIGH = off (LOW-level trigger) ---
    for (int i = 0; i < 3; i++) {
        pinMode(RELAY_PINS[i], OUTPUT);
        relay_off(RELAY_PINS[i]);
    }
    pinMode(PIN_RELAY_PUMP, OUTPUT);
    relay_off(PIN_RELAY_PUMP);

    // --- Status indicator outputs: all off initially ---
    const uint8_t indicator_pins[] = {
        PIN_LED_GREEN, PIN_LED_YELLOW,
        PIN_LED_RED_A, PIN_LED_RED_BC, PIN_BUZZER
    };
    for (int i = 0; i < 5; i++) {
        pinMode(indicator_pins[i], OUTPUT);
        digitalWrite(indicator_pins[i], LOW);
    }

    // --- Inputs ---
    pinMode(PIN_FLOAT_SWITCH, INPUT_PULLUP);
    pinMode(PIN_BUTTON,       INPUT_PULLUP);

    // --- ADC: 12-bit resolution, 0–3.3 V range (11 dB attenuation) ---
    analogSetAttenuation(ADC_11db);
    analogReadResolution(12);

    // --- I2C ---
    Wire.begin(PIN_SDA, PIN_SCL);

    // --- RTC (DS3231) ---
    rtc_ok = rtc.begin();
    if (!rtc_ok) {
        Serial.println("ERROR: DS3231 not detected on I2C (GPIO21/22).");
        Serial.println("       Check wiring. Send T<epoch> via serial once connected.");
    } else {
        if (rtc.lostPower()) {
            Serial.println("RTC lost power — using compile-time date as fallback.");
            Serial.println("Set accurate time with: T<unix_epoch>");
            rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
        }
        DateTime now = rtc.now();
        Serial.printf("RTC OK: %04d-%02d-%02d %02d:%02d:%02d\n",
                      now.year(), now.month(), now.day(),
                      now.hour(), now.minute(), now.second());
    }

    // --- OLED (SSD1306, optional) ---
    oled_ok = oled.begin(SSD1306_SWITCHCAPVCC, OLED_I2C_ADDR);
    if (!oled_ok) {
        Serial.println("OLED: not detected (optional — continuing without display)");
    } else {
        oled.clearDisplay();
        oled.setTextSize(1);
        oled.setTextColor(SSD1306_WHITE);
        oled.setCursor(16, 20); oled.println("Microgreen Box");
        oled.setCursor(28, 32); oled.println("v1.0 starting");
        oled.display();
        Serial.println("OLED OK");
    }

    // --- EEPROM: restore tray state and pump log ---
    load_state();

    // --- Compute initial grow-day values from RTC ---
    if (rtc_ok) {
        uint32_t epoch = rtc.now().unixtime();
        for (int i = 0; i < 3; i++)
            trays[i].day = compute_day(trays[i].seed_epoch, epoch);
    }

    // --- Button interrupt + GPIO wakeup from light sleep ---
    attachInterrupt(digitalPinToInterrupt(PIN_BUTTON), on_button_isr, FALLING);
    gpio_wakeup_enable(GPIO_NUM_0, GPIO_INTR_LOW_LEVEL);
    esp_sleep_enable_gpio_wakeup();

    // --- Startup confirmed: two green blinks ---
    for (int i = 0; i < 2; i++) {
        digitalWrite(PIN_LED_GREEN, HIGH); delay(200);
        digitalWrite(PIN_LED_GREEN, LOW);  delay(200);
    }

    delay(1500);  // hold splash screen briefly
    Serial.println("Setup complete. Entering main loop.");
}

// =============================================================================
// loop()
// Runs once per SLEEP_SECONDS. Each iteration:
//   1.  Get current time from RTC
//   2.  Handle serial commands
//   3.  Handle button press (seed next tray)
//   4.  Update per-tray grow-day counters
//   5.  Read moisture sensors and float switch
//   6.  Apply light schedule (relay on/off per tray)
//   7.  Apply watering schedule (pump if needed)
//   8.  Update status LEDs and buzzer
//   9.  Update OLED display
//  10.  Print serial status
//  11.  Heartbeat LED tick
//  12.  Enter light sleep for SLEEP_SECONDS
//       (GPIO outputs preserved; button press on GPIO0 wakes early)
// =============================================================================

void loop() {
    // 1. Current time
    DateTime now;
    if (rtc_ok) {
        now = rtc.now();
    } else {
        // Degrade gracefully: approximate from compile-time epoch + uptime
        uint32_t approx = DateTime(F(__DATE__), F(__TIME__)).unixtime()
                        + millis() / 1000UL;
        now = DateTime(approx);
    }
    uint32_t now_epoch = now.unixtime();
    uint16_t today     = (uint16_t)(now_epoch / 86400UL);

    // 2. Serial commands
    handle_serial(now_epoch);

    // 3. Button
    if (button_event) {
        button_event = false;
        seed_next_tray(now_epoch);
    }

    // 4. Tray day counters
    for (int i = 0; i < 3; i++)
        trays[i].day = compute_day(trays[i].seed_epoch, now_epoch);

    // 5. Sensors
    water_low_alarm = water_is_low();
    for (int i = 0; i < 3; i++) {
        trays[i].moisture = (trays[i].day >= 0)
                          ? read_moisture(MOISTURE_PINS[i])
                          : 0;
    }

    // 6. Light schedule
    apply_lights(now.hour());

    // 7. Watering schedule
    apply_watering(now.hour(), today);

    // 8. Indicators
    update_indicators();

    // 9. Display
    update_display(now);

    // 10. Serial diagnostics
    print_status(now);

    // 11. Heartbeat tick before sleep
    heartbeat_tick();

    // 12. Light sleep
    //     Relay GPIO outputs are preserved during light sleep (ESP32 datasheet §4.3).
    //     The pump is always switched off before we reach this point.
    //     Pressing the button (GPIO0 LOW) wakes the CPU immediately.
    Serial.printf("Sleeping %d s...\n\n", SLEEP_SECONDS);
    Serial.flush();
    esp_sleep_enable_timer_wakeup((uint64_t)SLEEP_SECONDS * 1000000ULL);
    esp_light_sleep_start();
    // Execution resumes here on wakeup
}
