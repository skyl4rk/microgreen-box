# Firmware Configuration Guide

**Phase:** 04 Software
**Status:** Complete
**Last Updated:** 2026-02-18
**Config file:** `software/firmware/microgreen_controller/config.h`

---

## Overview

All user-adjustable parameters are in `config.h`. No other files need editing for routine configuration. After changing any parameter, re-flash the firmware via Arduino IDE.

Parameters that require physical measurement (pump flow rate, sensor calibration) are marked **[Calibrate]**. All others have safe defaults that work for a standard broccoli microgreen grow.

---

## Functional Requirements Implemented

| ID | Requirement | Status | Notes |
|----|-------------|--------|-------|
| SW-001 | Control lighting on configurable schedule | ✅ | `PHOTO_ON_HOUR`, `PHOTO_OFF_HOUR` |
| SW-002 | Trigger watering pump on configurable schedule | ✅ | `WATER_HOUR_1`, `WATER_HOUR_2` |
| SW-003 | Schedules persist across power cycles | ✅ | DS3231 RTC + EEPROM |
| SW-004 | Per-tray germination blackout (lights off) | ✅ | `BLACKOUT_DAYS` |
| SW-005 | Moisture feedback: skip watering if wet | ✅ | `MOISTURE_SKIP_THRESHOLD` |
| SW-006 | Moisture feedback: top-up if still dry after event | ✅ | `MOISTURE_TOPUP_THRESHOLD` |
| SW-008 | Exclude germinating trays from watering decisions | ✅ | `GERMINATION_WATER_DAYS` — prevents damping-off |
| SW-007 | Grow-day counter per tray, persists power-off | ✅ | Seed epoch stored in EEPROM |
| SW-010 | Monitor reservoir level; alert when low | ✅ | Float switch on GPIO33 |
| SW-020 | Indicate low water via LED and buzzer | ✅ | Yellow LED + buzzer on rising edge |
| SW-021 | Indicate harvest ready per tray | ✅ | Red LEDs + one-shot buzzer beep |
| SW-022 | Power-conservative operation | ✅ | Light sleep between 60 s check cycles |
| SW-030 | Configurable light schedule | ✅ | Edit `config.h`, re-flash |
| SW-031 | Configurable water schedule | ✅ | Edit `config.h`, re-flash |

---

## Parameter Reference

### Light Schedule

#### `PHOTO_ON_HOUR` — default `6`
Hour (0–23) when grow lights turn on each day.

```c
#define PHOTO_ON_HOUR    6    // lights on at 06:00
```

Choosing a value: align with your morning routine so the lights are active when you harvest. The device harvests in the morning, so having lights on from 06:00 means fresh illuminated growth is ready at harvest time.

#### `PHOTO_OFF_HOUR` — default `20`
Hour (0–23) when grow lights turn off each day.

```c
#define PHOTO_OFF_HOUR   20   // lights off at 20:00
```

**Photoperiod = PHOTO_OFF_HOUR − PHOTO_ON_HOUR.** Default: 20 − 6 = 14 hours. Research supports 14 h/10 h for broccoli microgreens as a balance between yield and energy use. A 16 h photoperiod (e.g. OFF_HOUR = 22) increases yield marginally but uses ~15% more energy.

#### `BLACKOUT_DAYS` — default `2`
Number of days after seeding during which lights stay off regardless of photoperiod.

```c
#define BLACKOUT_DAYS    2    // days 0, 1, 2 = dark; light starts day 3
```

Broccoli seeds germinate best in darkness during days 0–2. Light exposure during germination does not harm them but offers no benefit. Day numbering: day 0 = seeded today, day 1 = next day, etc.

---

### Watering Schedule

#### `WATER_HOUR_1` — default `7`
Hour (0–23) for the first daily watering event.

```c
#define WATER_HOUR_1     7    // 07:00 morning watering
```

The pump runs once at this hour each day, subject to the moisture check (see below).

#### `WATER_HOUR_2` — default `19`
Hour (0–23) for the second daily watering event.

```c
#define WATER_HOUR_2     19   // 19:00 evening watering
```

Two events per day delivers ~150 mL/day total (75 mL per event). At 150 mL/day the 2.43 L reservoir lasts ~16 days.

#### `GERMINATION_WATER_DAYS` — default `2`
Number of days after seeding during which a tray is **excluded from moisture-driven watering decisions**.

```c
#define GERMINATION_WATER_DAYS  2
```

**Purpose:** Prevents damping-off (fungal root rot caused by *Pythium* spp.). Seeds are soaked for 4–8 hours before sowing, and the coir is already saturated on Day 0. Running the pump on a germinating tray's behalf over-saturates the medium and creates anaerobic conditions at the root zone — the primary cause of seedling damping-off.

**Behaviour:** Germinating trays (day ≤ `GERMINATION_WATER_DAYS`) are excluded from the skip and top-up moisture checks. The pump still runs when established trays need it — germinating trays receive water as a side-effect through their drip emitter. What changes is that a germinating tray cannot *trigger* a pump run on its own.

**Edge case:** If all active trays are in the germination period, the pump is skipped entirely for that event.

**Relationship to `BLACKOUT_DAYS`:** Both default to 2 and apply to the same window, but serve distinct purposes. `BLACKOUT_DAYS` controls lighting; `GERMINATION_WATER_DAYS` controls watering decisions. They can be set independently.

---

### Grow Cycle

#### `GROW_DAYS` — default `10`
Total grow cycle length in days. Once a tray reaches this day count, the button will seed it again on the next press.

```c
#define GROW_DAYS        10
```

Broccoli microgreens are typically ready at days 8–12 depending on light intensity and temperature.

#### `HARVEST_DAY` — default `8`
Grow day on which the harvest-ready red LED activates and the buzzer sounds once.

```c
#define HARVEST_DAY      8
```

Set this 2–3 days before GROW_DAYS as an advance notice. Harvest anytime between `HARVEST_DAY` and `GROW_DAYS`.

---

### Pump Parameters

#### `PUMP_RUN_SECONDS` — default `90` **[Calibrate]**
Seconds to run the pump for each scheduled watering event.

```c
#define PUMP_RUN_SECONDS     90
```

**This must be calibrated to your actual pump.** Target: 75 mL per event (25 mL × 3 trays). At 50 mL/min: 90 s. At 100 mL/min: 45 s. See Step 11 in [installation-guide.md](installation-guide.md) for measurement procedure.

Setting it too high will over-water (mould risk). Too low will under-water (wilting). The moisture feedback provides a safety net but cannot compensate for grossly wrong calibration.

#### `PUMP_TOPUP_SECONDS` — default `30`
Seconds to run the pump for a top-up pass after the main event.

```c
#define PUMP_TOPUP_SECONDS   30
```

A top-up runs after the main event if, after `MOISTURE_SETTLE_SECONDS` of settling time, any active tray still reads below `MOISTURE_TOPUP_THRESHOLD`. This handles cases where one tray has unusually high evaporation (e.g. older seedlings consuming more water). The top-up is a single additional run, not repeated.

#### `MOISTURE_SETTLE_SECONDS` — default `30`
Seconds to wait between stopping the pump and re-reading moisture sensors.

```c
#define MOISTURE_SETTLE_SECONDS  30
```

Coir absorbs water gradually. Reading too soon after pumping will show falsely low moisture levels. 30 seconds is a practical minimum; increase to 60 s for very dense coir or long tube runs.

---

### Moisture Thresholds

#### `MOISTURE_SKIP_THRESHOLD` — default `70`
If ALL active trays read at or above this moisture percentage, the scheduled watering event is skipped entirely.

```c
#define MOISTURE_SKIP_THRESHOLD   70    // % (0–100)
```

Purpose: prevents over-watering on days where the coir is still holding enough moisture from the previous event. Common causes of consistently high moisture: cool ambient temperatures, low evaporation on young trays (days 0–3), or pump calibration over-delivering.

Raise this value if the pump runs too rarely. Lower it if mould appears (over-watering).

#### `MOISTURE_TOPUP_THRESHOLD` — default `25`
After the main pump run + settling time, if any active tray reads at or below this value, a top-up pass runs.

```c
#define MOISTURE_TOPUP_THRESHOLD  25    // % (0–100)
```

Purpose: catches the case where one tray is significantly drier than the others after a standard pump run. Typical cause: tray at peak growth (day 6–9) has high water demand and the standard 75 mL split across three trays is insufficient for that tray alone.

Raise this value if trays dry out between events. Lower it (or set to 0 to disable top-up) if top-up runs are triggering unnecessarily.

---

### Moisture Sensor Calibration

#### `MOISTURE_DRY_RAW` — default `3200` **[Calibrate]**
Raw 12-bit ADC count (0–4095) when the sensor is held in dry air.

```c
#define MOISTURE_DRY_RAW   3200
```

This is the 0 % moisture reference. Typical range: 2900–3400. Values below 2800 or above 3600 suggest a wiring problem (check 3.3 V supply and GND to sensor).

#### `MOISTURE_WET_RAW` — default `1200` **[Calibrate]**
Raw 12-bit ADC count when the sensor is fully submerged in clean water.

```c
#define MOISTURE_WET_RAW   1200
```

This is the 100 % moisture reference. Typical range: 900–1500. The firmware maps all readings linearly between these two bounds.

**Calibration procedure:** See Step 10 in [installation-guide.md](installation-guide.md).

**Note on sensor-to-sensor variation:** All three sensors can have slightly different raw values. If one sensor consistently reads differently from the others in identical conditions, calibrate its thresholds by adjusting the raw constants. If the variation is large (>300 counts), replace the sensor.

---

### Sleep Interval

#### `SLEEP_SECONDS` — default `60`
Seconds between main-loop wakeups. The ESP32 is in light sleep between iterations.

```c
#define SLEEP_SECONDS    60
```

During light sleep the ESP32 draws ~0.8 mA instead of ~80 mA active. GPIO output states (relay on/off) are preserved. The schedule check runs once per wakeup, so there is up to `SLEEP_SECONDS` of latency on schedule transitions (e.g. lights may turn on up to 60 s after `PHOTO_ON_HOUR`).

Reducing to 30 s halves the transition latency at the cost of slightly higher average power draw. Increasing to 120 s would approximately halve the ESP32's average current with minimal practical effect.

Pressing the BOOT button wakes the CPU immediately from light sleep regardless of this setting.

---

### GPIO Pin Assignments

These define which ESP32 GPIO each function uses. **Do not change unless you have physically rewired your build.** Changes must match `wiring-schematic.md` exactly.

```c
// Relay outputs (LOW-level trigger: LOW = relay ON = load ON)
#define PIN_RELAY_LED_A   26    // LED strip Tray A
#define PIN_RELAY_LED_B   27    // LED strip Tray B
#define PIN_RELAY_LED_C   25    // LED strip Tray C
#define PIN_RELAY_PUMP    13    // Peristaltic pump

// Analog inputs (ADC1 only)
#define PIN_MOISTURE_A    34    // Moisture sensor Tray A
#define PIN_MOISTURE_B    35    // Moisture sensor Tray B
#define PIN_MOISTURE_C    32    // Moisture sensor Tray C

// Digital input
#define PIN_FLOAT_SWITCH  33    // Reservoir float switch

// Status outputs
#define PIN_LED_GREEN     18    // Heartbeat green LED
#define PIN_LED_YELLOW    19    // Water-low yellow LED
#define PIN_LED_RED_A      5    // Tray A harvest red LED
#define PIN_LED_RED_BC    17    // Tray B+C harvest red LED
#define PIN_BUZZER        16    // Active buzzer

// User button
#define PIN_BUTTON         0    // BOOT button

// I2C
#define PIN_SDA           21
#define PIN_SCL           22
```

**Why these pins:** See `wiring-schematic.md` Section 3.3 for full rationale. Key constraints: GPIO34/35 are ADC1 input-only pins (ideal for sensors); GPIO12 avoided (flash voltage strapping pin); ADC2 pins avoided (disabled during WiFi use).

---

### I2C Addresses

```c
#define RTC_I2C_ADDR    0x68   // DS3231 (hardware-fixed, cannot change)
#define OLED_I2C_ADDR   0x3C   // SSD1306 (try 0x3D if display not found)
```

Some SSD1306 modules have address `0x3D` instead of `0x3C` depending on a solder bridge on the module board. If the OLED is installed but not detected, change to `0x3D` and re-flash.

---

## Serial Commands

The firmware accepts commands via the Arduino Serial Monitor at **115200 baud**:

| Command | Example | Effect |
|---------|---------|--------|
| `T<epoch>` | `T1739836800` | Set the RTC to the given Unix timestamp |
| `S` | `S` | Print full status dump (tray state, pump log, alarm flags) |

To get the current Unix timestamp: [https://www.unixtimestamp.com](https://www.unixtimestamp.com)

---

## Firmware Behaviour Summary

### On button press (BOOT / GPIO0)
The first available tray (in order A → B → C) with `seed_epoch == 0` or `day >= GROW_DAYS` is recorded as seeded at the current timestamp. Three green LED flashes confirm. If all three trays are active, five red flashes indicate "no tray available."

### Lights
Each tray's LED relay is controlled independently. Light turns ON when:
- Tray day > `BLACKOUT_DAYS` **AND**
- Current hour is in `[PHOTO_ON_HOUR, PHOTO_OFF_HOUR)`

Otherwise light is OFF. Empty trays (day = -1) always have lights off.

### Watering
Two events per day at `WATER_HOUR_1` and `WATER_HOUR_2`. For each event:
1. Read moisture for all active trays
2. If all active trays ≥ `MOISTURE_SKIP_THRESHOLD`: skip (no pump run)
3. Otherwise: run pump for `PUMP_RUN_SECONDS`
4. Wait `MOISTURE_SETTLE_SECONDS`
5. Re-read moisture; if any tray < `MOISTURE_TOPUP_THRESHOLD`: top-up run

Pump log (which events have fired today) is stored in EEPROM and resets at midnight.

### Alarms
- **Water low:** Float switch → GPIO33 LOW → yellow LED on, two buzzer beeps (once per transition, not every loop)
- **Harvest ready:** Tray day ≥ `HARVEST_DAY` → red LED on, one buzzer beep (once per tray, on first detection)
- **Heartbeat:** Green LED blinks slowly (1 s period) when system OK; fast (200 ms) when any alarm is active

### Power
The ESP32 enters light sleep for `SLEEP_SECONDS` between loop iterations. During light sleep:
- GPIO output states are preserved (relays stay in their current position)
- CPU and WiFi clocks stop (~0.8 mA from 3.3 V rail)
- A button press on GPIO0 wakes the CPU immediately

Average ESP32 power at 60 s sleep: ~2–3 mA vs ~80 mA continuously active.

---

## Optional / Future Enhancements

- **WiFi MQTT telemetry:** The ESP32 has built-in WiFi. Firmware could publish grow-day, moisture, and alarm state to an MQTT broker for remote monitoring. Disabled by default to conserve power.
- **Temperature/humidity sensor:** A DHT22 or SHT31 could log growing chamber conditions. Pin E12 (DS18B20) is on the BOM as an optional addition.
- **Data logging:** EEPROM or an SD card could store watering event history and moisture trends.
- **Web configuration:** A captive-portal WiFi interface could allow schedule changes without reflashing.
