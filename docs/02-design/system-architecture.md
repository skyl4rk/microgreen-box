# System Architecture

**Phase:** 02 Design
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Overview

The microgreen box is a self-contained, automated vertical growing device with 3 tray levels. It is powered by 12V DC (solar/battery or wall adapter), controlled by an ESP32 microcontroller, and produces ~30 g/day of fresh broccoli microgreens via a staggered 3-tray rotation. All water is contained in sealed reservoirs. There is no on-device food processing — the device outputs fresh cut greens.

---

## Subsystem Map

| Subsystem | Responsibility | Document |
|-----------|---------------|----------|
| Growing System | Trays, coir medium, seed rotation schedule | [growing-system.md](growing-system.md) |
| Lighting System | Per-tray LED panels, 14h photoperiod, germination blackout | [lighting-system.md](lighting-system.md) |
| Watering System | Sealed 2L reservoir, peristaltic pump, top-drip delivery | [watering-system.md](watering-system.md) |
| Power System | 12V DC input, MPPT solar controller, LiFePO4 battery | [power-system.md](power-system.md) |
| Preservation System | N/A (device scope: fresh output only); user workflow documented | [preservation-system.md](preservation-system.md) |
| Enclosure | PETG 3D-printed column, sealed, vehicle-stable | [enclosure-design.md](enclosure-design.md) |
| Control System | ESP32, firmware, sensors, scheduling | docs/04-software/ |

---

## System Block Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     POWER SYSTEM (12V)                      │
│  [Solar Panel] → [MPPT Controller] → [LiFePO4 Battery]     │
│                           ↓                                  │
│                    [12V Power Rail]                          │
│                    [5V Regulator]                            │
└─────────────────────┬───────────────────────────────────────┘
                      │ 12V / 5V
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                   CONTROL SYSTEM (ESP32)                    │
│                                                             │
│  ┌──────────────┐   ┌──────────────┐   ┌────────────────┐  │
│  │ RTC (DS3231) │   │ Water Level  │   │ Day Counters   │  │
│  │ Timekeeping  │   │ Sensor (ADC) │   │ (per tray)     │  │
│  └──────┬───────┘   └──────┬───────┘   └────────┬───────┘  │
│         └──────────────────┴────────────────────┘          │
│                           │ Decisions                        │
│                           ▼                                  │
│  ┌─────────────┐   ┌─────────────┐   ┌──────────────────┐  │
│  │ LED Relay   │   │ Pump Relay  │   │ Status LEDs /    │  │
│  │ (3 channels)│   │ (1 channel) │   │ OLED Display     │  │
│  └──────┬──────┘   └──────┬──────┘   └──────────────────┘  │
└─────────┼────────────────┼────────────────────────────────  ┘
          │ 12V switched   │ 12V switched
          ▼                ▼
┌─────────────────┐  ┌──────────────────────────────────────┐
│  LIGHTING       │  │         WATERING SYSTEM              │
│  SYSTEM         │  │                                      │
│                 │  │  [Sealed 2L Reservoir]               │
│  [LED Panel A]  │  │         ↓                            │
│  [LED Panel B]  │  │  [Peristaltic Pump (12V)]            │
│  [LED Panel C]  │  │         ↓                            │
│                 │  │  [Manifold → Tray A / B / C drip]   │
└────────┬────────┘  └────────────────────┬─────────────────┘
         │                               │
         ▼                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    GROWING SYSTEM                           │
│                                                             │
│  ┌────────────────────────────────────────────────────┐    │
│  │  TRAY LEVEL A (top)                                │    │
│  │  [LED Panel A above] [Coir tray 25×25cm]          │    │
│  │  [Sub-tray sealed water reservoir below]           │    │
│  └────────────────────────────────────────────────────┘    │
│  ┌────────────────────────────────────────────────────┐    │
│  │  TRAY LEVEL B (middle)                             │    │
│  │  [LED Panel B above] [Coir tray 25×25cm]          │    │
│  │  [Sub-tray sealed water reservoir below]           │    │
│  └────────────────────────────────────────────────────┘    │
│  ┌────────────────────────────────────────────────────┐    │
│  │  TRAY LEVEL C (bottom)                             │    │
│  │  [LED Panel C above] [Coir tray 25×25cm]          │    │
│  │  [Sub-tray sealed water reservoir below]           │    │
│  └────────────────────────────────────────────────────┘    │
│                                                             │
│  [Main 2L Reservoir] [Waste Collection Chamber] [Base]     │
└─────────────────────────────────────────────────────────────┘
```

---

## Subsystem Interfaces

| Interface | From | To | Signal / Medium | Specification |
|-----------|------|----|----------------|---------------|
| 12V power | Power system | LED relays, pump relay | 12V DC wire, JST connectors | ≥2A continuous |
| 5V power | 5V regulator | ESP32, sensors, OLED | 5V DC regulated | ≥1A |
| LED control | ESP32 GPIO | LED relay module (3-ch) | 3.3V digital signal | GPIO 12, 13, 14 (suggested) |
| Pump control | ESP32 GPIO | Pump relay | 3.3V digital signal | GPIO 15 (suggested) |
| Water level | Water level sensor | ESP32 ADC | Analog 0–3.3V or I2C digital | ADC pin or I2C |
| Time reference | DS3231 RTC | ESP32 | I2C (SDA/SCL) | 400kHz |
| Status output | ESP32 GPIO | Status LEDs (×4) | 3.3V via 330Ω resistor | GPIO 16–19 |
| Optional display | ESP32 I2C | 0.96" OLED | I2C (shared bus with RTC) | 400kHz |
| Drip tubing | Pump outlet | Per-tray drip emitters | 6mm OD silicone food-grade tubing | 3 branches via manifold |
| Drain / overflow | Growing sub-tray | Waste chamber | 6mm silicone tubing via gravity | Sealed fitting |

---

## Controller Selection: ESP32

**Selected:** ESP32 (e.g., ESP32-WROOM-32 dev board)

| Feature | Value | Relevance |
|---------|-------|-----------|
| Cost | ~$4–8 USD | Low-cost target |
| Supply voltage | 3.3V logic; 5V USB/VIN input | Compatible with 5V regulator |
| GPIO | 34 usable pins | Ample for LED relay ×3, pump relay, sensors, OLED, RTC |
| I2C / SPI | Yes (hardware) | RTC (DS3231), OLED display |
| ADC | 12-bit, 18 channels | Water level analog sensor |
| WiFi | 802.11 b/g/n built-in | Optional remote monitoring / OTA update |
| Deep sleep | 10 µA sleep current | Battery preservation when no active scheduling |
| IDE | Arduino IDE + ESP32 board package | Widely supported, low barrier |
| Flash | 4MB | Ample for firmware + config storage |
| Programming | USB-UART via boot button | Standard |

**Alternatives considered:**
- Arduino Nano: lower cost but no WiFi, less RAM, harder to add future features
- Raspberry Pi Zero W: more capable but 500mA at 5V (power hungry), Linux boot time adds complexity
- ATtiny85: too limited for 3-channel lighting + pump + RTC + sensors + display

---

## Firmware Responsibilities

| Function | Description |
|----------|-------------|
| Day counter (per tray) | Track seeding date per tray; trigger blackout (days 0–2) and harvest alert (days 7–10) |
| Light scheduler | Enable/disable each LED channel on daily on/off schedule, respecting per-tray blackout |
| Watering scheduler | Trigger pump for configurable duration, 2× daily |
| Water level monitor | Poll sensor; activate low-water LED/buzzer if below threshold |
| Status display | Drive OLED or LEDs with current tray status, day counts, reservoir level |
| Configuration | Read schedule parameters from flash or config file; adjustable without recompiling |
| WiFi (optional) | Serve status page on local network; allow OTA firmware updates |

---

## Physical Layout (Vertical Column)

```
  ┌──────────────────────────┐  ← Top cap / seed storage compartment
  │   [LED Panel A]          │  ← Level A light (facing down)
  │   [Tray A — coir + seed] │  ← Growing tray (removable)
  │   [Sub-tray A — sealed]  │  ← Water retention / drainage
  ├──────────────────────────┤
  │   [LED Panel B]          │  ← Level B light
  │   [Tray B — coir + seed] │
  │   [Sub-tray B — sealed]  │
  ├──────────────────────────┤
  │   [LED Panel C]          │  ← Level C light
  │   [Tray C — coir + seed] │
  │   [Sub-tray C — sealed]  │
  ├──────────────────────────┤
  │   [Main Water Reservoir] │  ← 2L sealed; fill from top port
  │   [Waste Chamber]        │  ← Collects drain overflow
  │   [Electronics bay]      │  ← ESP32, relays, power regulator, RTC
  └──────────────────────────┘  ← Base with anti-slip feet / vehicle mount points
```

Total height (3-tray, base, top): ~85 cm
Footprint: 30 × 30 cm

---

## Scalability

Each "tray module" (LED + tray + sub-tray) is mechanically identical and stackable. To scale from 3 to 4 trays for 60 g/day output:

1. Print and add one additional tray module section (enclosure ring + LED bracket + tray + sub-tray)
2. Add one additional LED relay channel to the MCU (or use I2C GPIO expander)
3. Extend drip tubing from manifold to new tray
4. Update firmware configuration (tray count = 4)
5. No changes to reservoir, power system, or electronics bay needed (within power budget)

---

## Data Flow

```
RTC → ESP32 (time of day)
    ↓
Lighting Scheduler:
  If (hour >= on_time AND hour < off_time AND tray_day >= 3):
    Enable LED channel for tray
  Else:
    Disable LED channel

Watering Scheduler:
  If (hour == water_time_1 OR hour == water_time_2):
    Run pump for pump_duration_seconds

Water Level Monitor (every 30 min):
  Read ADC/sensor
  If level < threshold:
    Set low_water_flag = true
    Activate warning LED

Tray Day Counter (daily at midnight):
  Increment tray_A_day, tray_B_day, tray_C_day
  If tray_N_day >= harvest_day_threshold:
    Activate harvest_ready LED for tray N
  If tray_N_day > max_day:
    Alert (overdue harvest)
```
