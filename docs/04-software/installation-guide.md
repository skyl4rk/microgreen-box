# Firmware Installation Guide

**Phase:** 04 Software
**Status:** Complete
**Last Updated:** 2026-02-18
**Firmware:** `software/firmware/microgreen_controller/`

---

## Overview

The microgreen box runs firmware on an ESP32-WROOM-32 microcontroller written for the Arduino framework. This guide covers installing the required tools, flashing the firmware, setting the clock, and calibrating the moisture sensors.

---

## Prerequisites

- Hardware fully assembled per [assembly-instructions.md](../03-build/assembly-instructions.md)
- Wiring verified per [wiring-schematic.md](../../hardware/schematics/wiring-schematic.md)
- A computer with a USB port and internet access
- A micro-USB data cable (not charge-only — must carry data)

---

## Step 1: Install Arduino IDE

Download and install **Arduino IDE 2.x** from [https://www.arduino.cc/en/software](https://www.arduino.cc/en/software).

Arduino IDE 2.x is recommended. IDE 1.8.x also works.

---

## Step 2: Add ESP32 Board Support

1. Open Arduino IDE → **File → Preferences**
2. In "Additional boards manager URLs" add:
   ```
   https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```
3. Click OK
4. Go to **Tools → Board → Boards Manager**
5. Search for `esp32` and install **"esp32" by Espressif Systems** (version 2.x or later)

---

## Step 3: Install Required Libraries

Go to **Tools → Manage Libraries** and install these three libraries:

| Library | Author | Purpose |
|---------|--------|---------|
| `RTClib` | Adafruit | DS3231 real-time clock |
| `Adafruit GFX Library` | Adafruit | OLED graphics primitives |
| `Adafruit SSD1306` | Adafruit | OLED display driver |

Search for each by name and click **Install**. Accept any dependency prompts.

---

## Step 4: Open the Firmware Sketch

1. In Arduino IDE: **File → Open**
2. Navigate to:
   ```
   microgreen-box/software/firmware/microgreen_controller/
   ```
3. Open `microgreen_controller.ino`

The sketch and `config.h` will open as two tabs in the editor.

---

## Step 5: Configure Parameters

Open the `config.h` tab. Review the user-adjustable parameters and change any that differ from your setup.

The defaults that most commonly need adjustment:

| Parameter | Default | When to change |
|-----------|---------|----------------|
| `PHOTO_ON_HOUR` | 6 | Shift light schedule to match your morning routine |
| `PHOTO_OFF_HOUR` | 20 | Adjust for different photoperiod length |
| `PUMP_RUN_SECONDS` | 90 | **Must be calibrated** — see Step 9 |
| `MOISTURE_DRY_RAW` | 3200 | **Must be calibrated** — see Step 8 |
| `MOISTURE_WET_RAW` | 1200 | **Must be calibrated** — see Step 8 |

See [requirements.md](requirements.md) for a full explanation of every parameter.

---

## Step 6: Select Board and Port

1. Connect the ESP32 to your computer via micro-USB
2. In Arduino IDE:
   - **Tools → Board → esp32 → ESP32 Dev Module**
   - **Tools → Port** → select the port that appeared when you connected the ESP32
     - Linux: `/dev/ttyUSB0` or `/dev/ttyACM0`
     - macOS: `/dev/cu.usbserial-*`
     - Windows: `COM3`, `COM4`, etc.

If no port appears:
- Windows/macOS: install the CP2102 USB-UART driver from Silicon Labs
- Linux: add your user to the `dialout` group (`sudo usermod -aG dialout $USER` then log out/in)

---

## Step 7: Flash the Firmware

1. Click the **Upload** button (right-arrow icon) in Arduino IDE
2. If the upload fails with "Connecting..." stuck: hold the **BOOT** button on the ESP32, click Upload, release BOOT once "Uploading..." appears
3. Wait for "Done uploading."

The ESP32 restarts automatically after flashing.

---

## Step 8: Verify Startup

Open **Tools → Serial Monitor**. Set baud rate to **115200** and line ending to **Newline**.

You should see:
```
=== Microgreen Box v1.0 ===
EEPROM: first boot — defaults written
RTC OK: 2026-02-18 00:00:00
OLED OK
Setup complete. Entering main loop.
```

**If you see errors:**

| Message | Action |
|---------|--------|
| `ERROR: DS3231 not detected` | Check I2C wiring on GPIO21 (SDA) and GPIO22 (SCL); check 3.3 V and GND to RTC module |
| `OLED: not detected` | Optional — device works without it; check wiring if display is installed |
| No output at all | Check micro-USB cable is data-capable; check CP2102 driver |
| Wrong time shown | Proceed to Step 9 to set the clock |

---

## Step 9: Set the Real-Time Clock

If the time shown is wrong (RTC lost power, or first use), set it via serial:

1. Find the current Unix epoch timestamp at [https://www.unixtimestamp.com](https://www.unixtimestamp.com)
2. In the Serial Monitor, type `T` followed immediately by the epoch number (no spaces), e.g.:
   ```
   T1739836800
   ```
3. Press Enter (Send). The RTC responds:
   ```
   RTC set to 1739836800
   ```
4. Verify by typing `S` and reading the time in the status dump.

The DS3231 has a CR2032 coin cell backup — once set, the time is maintained indefinitely through power cycles.

---

## Step 10: Calibrate Moisture Sensors

The capacitive moisture sensor raw ADC values vary between individual sensor units. Calibration is required once after assembly.

**You will need:** a cup of clean water and a dry surface.

### Calibration Procedure

Run this for each sensor one at a time (or all three if values are similar):

1. With the device powered and serial monitor open, type `S` + Enter to see current readings.
2. Hold **Sensor A** (connected to GPIO34) in open air for 10 seconds. Note the moisture % shown.
   - A high raw ADC count maps to 0 % moisture in the default config.
   - If the displayed moisture reads significantly above 0 % in dry air, the `MOISTURE_DRY_RAW` value needs to be increased.
3. Submerge just the sensing tip (bottom 3 cm) of Sensor A in the cup of water. Wait 5 seconds. Note the reading.
   - Should read close to 100 %. If lower, `MOISTURE_WET_RAW` needs to be decreased.

### Getting Raw ADC Counts

To see raw ADC values, temporarily add this to the top of `loop()` in the sketch:
```cpp
Serial.printf("A_raw=%d  B_raw=%d  C_raw=%d\n",
              analogRead(PIN_MOISTURE_A),
              analogRead(PIN_MOISTURE_B),
              analogRead(PIN_MOISTURE_C));
```

Flash, open serial monitor, and read the raw counts:
- Record the value in **dry air** → set as `MOISTURE_DRY_RAW` in `config.h`
- Record the value **submerged** → set as `MOISTURE_WET_RAW` in `config.h`
- Remove the debug line, re-flash

**Typical values for 3.3 V-powered Capacitive V1.2:**

| Condition | Typical raw count |
|-----------|-------------------|
| Dry air | 2900–3400 |
| Wet coir (field capacity) | 1800–2200 |
| Fully submerged | 900–1400 |

---

## Step 11: Calibrate Pump Run Time

The pump delivers approximately 50–100 mL/min depending on tubing length and head pressure.

1. Fill the reservoir with water
2. Hold a measuring cup under the drip manifold output
3. In serial monitor, type `S` to confirm system state
4. Temporarily add `run_pump(true);` at the top of `loop()`, flash, and observe how much water is delivered in `PUMP_RUN_SECONDS`
5. Adjust `PUMP_RUN_SECONDS` in `config.h` until each pump run delivers ~75 mL (25 mL × 3 trays)
6. Remove the test line and re-flash

---

## Step 12: Start the First Growing Cycle

With firmware running and RTC set:

1. Fill the reservoir with clean water
2. Prepare Tray A: expand a coir puck with water, fill the growing tray, and sow 12–15 g of pre-soaked broccoli seed
3. Press the **BOOT button** (GPIO0) once
   - Three green LED flashes confirm Tray A is seeded
   - OLED shows "A: D00 germinating"
4. Days 0–2: lights remain off automatically (germination blackout)
5. Day 3: lights activate on the photoperiod schedule
6. Day 7 and 10: repeat button press for Trays B and C (staggered rotation)
7. Day 8+: red LED activates and buzzer sounds once for Tray A — harvest ready

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| Relay clicks but load doesn't activate | JD-VCC jumper still in place | Remove the VCC–JD-VCC shorting jumper on relay board |
| ESP32 resets when relay fires | JD-VCC not isolated; coil inrush on ESP32 rail | Remove jumper; power JD-VCC from 5 V bus separately |
| Moisture always reads 0 % | Sensor not powered or wrong pin | Check 3.3 V and GND to sensor; confirm ADC pin in config.h |
| Moisture reads 100 % in dry air | MOISTURE_DRY_RAW too low | Recalibrate (Step 10) |
| Lights don't turn on | Relay LOW-level trigger not set | Set relay module to LOW-level trigger mode |
| Lights on during germination | BLACKOUT_DAYS set to 0 | Set `BLACKOUT_DAYS 2` in config.h |
| No OLED output | OLED I2C address mismatch | Try `#define OLED_I2C_ADDR 0x3D` in config.h |
| RTC shows 2000 after power loss | Dead coin cell | Replace CR2032 on DS3231 module |
| "No tray available to seed" flashes red | All trays are active | Wait for a tray to reach day ≥ 10 before pressing button |
| Serial monitor shows garbage | Wrong baud rate | Set serial monitor to 115200 baud |

---

## I2C Address Scanner

If you are unsure of I2C addresses on your modules, flash this standalone sketch to scan the bus:

```cpp
#include <Wire.h>
void setup() {
    Serial.begin(115200);
    Wire.begin(21, 22);
    for (byte a = 1; a < 127; a++) {
        Wire.beginTransmission(a);
        if (Wire.endTransmission() == 0)
            Serial.printf("Found device at 0x%02X\n", a);
    }
    Serial.println("Scan complete");
}
void loop() {}
```

Expected output:
```
Found device at 0x3C   ← SSD1306 OLED
Found device at 0x57   ← AT24C32 EEPROM on DS3231 module
Found device at 0x68   ← DS3231 RTC
```
