// =============================================================================
// config.h — User-adjustable parameters for Microgreen Box v1.0
// =============================================================================
// Edit these values to match your hardware and growing preferences.
// All times use 24-hour format (0–23).
// After editing, re-flash the ESP32 via Arduino IDE.
// =============================================================================

#pragma once

// ─────────────────────────────────────────────────────────────────────────────
// LIGHT SCHEDULE
// ─────────────────────────────────────────────────────────────────────────────

// Hour (0–23) when grow lights turn ON each day.
#define PHOTO_ON_HOUR    6    // 06:00

// Hour (0–23) when grow lights turn OFF each day.
// Photoperiod = PHOTO_OFF_HOUR − PHOTO_ON_HOUR  (default: 20 − 6 = 14 hours)
#define PHOTO_OFF_HOUR   20   // 20:00

// Days after seeding during which lights remain OFF (germination blackout).
// Day 0 = seeded today. Lights first activate on day (BLACKOUT_DAYS + 1).
// Broccoli: 2 days dark to encourage hypocotyl elongation before light exposure.
#define BLACKOUT_DAYS    2

// ─────────────────────────────────────────────────────────────────────────────
// WATERING SCHEDULE
// ─────────────────────────────────────────────────────────────────────────────

// Hour (0–23) for morning watering event.
#define WATER_HOUR_1     7    // 07:00

// Hour (0–23) for evening watering event.
#define WATER_HOUR_2     19   // 19:00

// Number of days after seeding during which a tray is EXCLUDED from moisture-
// driven watering decisions. Seeds are soaked 4–8 h before sowing and the coir
// is already saturated on day 0. Over-watering days 0–N is the primary cause
// of damping-off (Pythium root rot). Germinating trays still receive water as a
// side-effect when established trays trigger a pump run; they are just not
// allowed to trigger extra pump runs themselves.
// Set equal to BLACKOUT_DAYS (both are 2 for broccoli) — they serve different
// purposes (lighting vs. watering) but share the same value by coincidence.
#define GERMINATION_WATER_DAYS  2

// ─────────────────────────────────────────────────────────────────────────────
// GROW CYCLE
// ─────────────────────────────────────────────────────────────────────────────

// Total grow cycle length in days (broccoli microgreens: typically 10 days).
// Tray is considered "ready to reseed" when day >= GROW_DAYS.
#define GROW_DAYS        10

// Grow day on which the harvest-ready LED and buzzer activate.
// Set 2–3 days before GROW_DAYS as an advance warning.
#define HARVEST_DAY      8

// ─────────────────────────────────────────────────────────────────────────────
// PUMP PARAMETERS
// ─────────────────────────────────────────────────────────────────────────────

// Seconds to run the pump for a full scheduled watering event.
// Target delivery: 75 mL total (25 mL × 3 trays).
//   INTLLAB pump at ~50 mL/min: 90 s
//   INTLLAB pump at ~100 mL/min: 45 s
// Measure your pump's actual flow rate and set accordingly.
#define PUMP_RUN_SECONDS     90

// Seconds to run the pump for a top-up pass (shorter than full event).
// Triggered if any tray reads below MOISTURE_TOPUP_THRESHOLD after settling.
#define PUMP_TOPUP_SECONDS   30

// Seconds to wait after the pump stops before re-reading moisture sensors.
// Coir absorbs water slowly; this delay allows moisture to equalise.
#define MOISTURE_SETTLE_SECONDS  30

// ─────────────────────────────────────────────────────────────────────────────
// MOISTURE THRESHOLDS (0–100 %)
// ─────────────────────────────────────────────────────────────────────────────

// Skip a scheduled watering event if ALL active trays read AT OR ABOVE this.
// Prevents over-watering. Raise if coir stays wet too long (mould risk).
#define MOISTURE_SKIP_THRESHOLD   70

// Run a top-up after the scheduled event if ANY active tray reads AT OR BELOW this
// value (after MOISTURE_SETTLE_SECONDS). Lower if trays dry out too quickly.
#define MOISTURE_TOPUP_THRESHOLD  25

// ─────────────────────────────────────────────────────────────────────────────
// MOISTURE SENSOR CALIBRATION (raw ADC counts, 12-bit = 0–4095)
// ─────────────────────────────────────────────────────────────────────────────
// Run the calibration procedure in installation-guide.md to get your values.
// Defaults are approximate for 3.3 V Capacitive V1.2 sensors.
//
// Capacitive sensor behaviour:
//   Dry air      → high output voltage → high ADC count
//   Submerged    → low  output voltage → low  ADC count

// ADC count with sensor held in dry air (0 % moisture reference)
#define MOISTURE_DRY_RAW   3200

// ADC count with sensor fully submerged in clean water (100 % reference)
#define MOISTURE_WET_RAW   1200

// ─────────────────────────────────────────────────────────────────────────────
// SLEEP INTERVAL
// ─────────────────────────────────────────────────────────────────────────────

// Seconds between main-loop wakeups (light sleep between iterations).
// During light sleep the ESP32 draws ~0.8 mA instead of ~80 mA.
// GPIO output states (relay positions) are preserved during light sleep.
// Schedule transitions may be up to SLEEP_SECONDS late — acceptable for this use.
#define SLEEP_SECONDS    60

// ─────────────────────────────────────────────────────────────────────────────
// GPIO PIN ASSIGNMENTS
// These match wiring-schematic.md Section 3.3 exactly.
// Change only if you have physically rewired your build.
// ─────────────────────────────────────────────────────────────────────────────

// Relay outputs — LOW-level trigger module: LOW = relay energised = load ON
#define PIN_RELAY_LED_A   26   // Relay CH1 — LED strip Tray A (bottom ring)
#define PIN_RELAY_LED_B   27   // Relay CH2 — LED strip Tray B (middle ring)
#define PIN_RELAY_LED_C   25   // Relay CH3 — LED strip Tray C (top ring)
#define PIN_RELAY_PUMP    13   // Relay CH4 — peristaltic pump

// Analog inputs — ADC1 only (ADC2 is disabled while WiFi is active on ESP32)
#define PIN_MOISTURE_A    34   // ADC1_CH6 — moisture sensor Tray A (input-only pin)
#define PIN_MOISTURE_B    35   // ADC1_CH7 — moisture sensor Tray B (input-only pin)
#define PIN_MOISTURE_C    32   // ADC1_CH4 — moisture sensor Tray C

// Digital input
#define PIN_FLOAT_SWITCH  33   // Reservoir float switch (INPUT_PULLUP; LOW = water low alarm)

// Status indicator outputs — HIGH = LED on
#define PIN_LED_GREEN     18   // Green LED via 330 Ω — heartbeat (power/system OK)
#define PIN_LED_YELLOW    19   // Yellow LED via 330 Ω — low water alarm
#define PIN_LED_RED_A      5   // Red LED via 330 Ω — Tray A harvest ready
#define PIN_LED_RED_BC    17   // Red LED via 330 Ω — Tray B or C harvest ready
#define PIN_BUZZER        16   // Active buzzer via 100 Ω — HIGH = on

// User button — active-low, also acts as GPIO wake source from light sleep
#define PIN_BUTTON         0   // GPIO0 / BOOT button — seed next available tray

// I2C bus — shared by DS3231 RTC and SSD1306 OLED
#define PIN_SDA           21
#define PIN_SCL           22

// ─────────────────────────────────────────────────────────────────────────────
// I2C DEVICE ADDRESSES
// ─────────────────────────────────────────────────────────────────────────────
#define RTC_I2C_ADDR    0x68   // DS3231 (fixed)
#define OLED_I2C_ADDR   0x3C   // SSD1306 (try 0x3D if display not found)

// ─────────────────────────────────────────────────────────────────────────────
// BUTTON DEBOUNCE
// ─────────────────────────────────────────────────────────────────────────────
#define BUTTON_DEBOUNCE_MS  300
