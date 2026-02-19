# Electrical Parts List

**Phase:** 03 Build
**Status:** Complete
**Last Updated:** 2026-02-17

All costs are approximate retail prices. AliExpress pricing typically 30–50% lower with 2–4 week delivery. Amazon pricing is 20–50% higher with faster delivery. Quantities for a single 3-tray unit.

---

## Control

| # | Component | Specification | Qty | Supplier | Search Term / Part | Unit Cost | Total | Notes |
|---|-----------|--------------|-----|----------|-------------------|-----------|-------|-------|
| E01 | Microcontroller | ESP32-WROOM-32 dev board, 38-pin, USB-UART | 1 | AliExpress / Amazon | "ESP32 38pin development board" | $5–8 | $6 | Arduino IDE compatible; see system-architecture.md |
| E02 | RTC module | DS3231, I2C, 3.3V/5V compatible, coin cell holder | 1 | AliExpress / Amazon | "DS3231 AT24C32 I2C RTC module" | $1–4 | $2 | Maintains time through power loss; CR2032 battery included |
| E03 | OLED display (optional) | 0.96" 128×64, I2C, SSD1306, 3.3V/5V | 1 | AliExpress / Amazon | "0.96 inch I2C OLED SSD1306" | $2–5 | $3 | Status display; omit if reducing cost |

**Control subtotal: ~$11**

---

## Power

| # | Component | Specification | Qty | Supplier | Search Term / Part | Unit Cost | Total | Notes |
|---|-----------|--------------|-----|----------|-------------------|-----------|-------|-------|
| E04 | Buck converter | MP1584EN, 4–28V input, 3A, adjustable output; set to 5V | 1 | AliExpress / Amazon | "MP1584 DC-DC step down buck module" | $1–2 | $1.50 | 12V → 5V for ESP32 |
| E05 | Fuse holder + fuse | Inline blade fuse holder + 5A automotive blade fuse | 1 | AliExpress / Amazon | "inline blade fuse holder 5A" | $1–2 | $1.50 | Protects 12V wiring |
| E06 | Reverse polarity protection | AO3401 P-channel MOSFET SOT-23; or 1N5400 diode (simpler, ~0.6V drop) | 1 | AliExpress / Digi-Key | "AO3401 P-ch MOSFET" | $0.50 | $0.50 | Prevents damage if 12V polarity reversed |
| E07 | Power input jack | 5.5/2.1mm DC barrel jack, panel-mount, positive-centre | 1 | AliExpress / Amazon | "5.5mm 2.1mm DC power jack panel mount" | $0.50–1 | $0.75 | Input connector for 12V supply |

**Power subtotal: ~$4.25**

---

## Lighting

| # | Component | Specification | Qty | Supplier | Search Term / Part | Unit Cost | Total | Notes |
|---|-----------|--------------|-----|----------|-------------------|-----------|-------|-------|
| E08 | LED grow panel | 12V, 3–5W, 100×100mm, full-spectrum 5000–6500K, aluminium PCB | 3 | AliExpress | "12V 5W LED grow light panel 100×100" | $5–12 | $21 | One per tray level; 3W target; 5W acceptable |
| — | **OR (DIY strip option)** | 12V 2835 LED strip, 60 LED/m, 4.8W/m, 6000K, IP30 (no waterproofing) | 2m | AliExpress | "12V 2835 LED strip 60LED 6000K" | $3–5/m | $8 | Cut 4×50cm strips per tray, mount on 3D-printed sled |

**Lighting subtotal: ~$21 (panel option) or ~$8 (DIY strip)**

---

## Actuators

| # | Component | Specification | Qty | Supplier | Search Term / Part | Unit Cost | Total | Notes |
|---|-----------|--------------|-----|----------|-------------------|-----------|-------|-------|
| E09 | Relay module | 4-channel, 5V coil, optocoupler isolated, 10A contacts, active-LOW input | 1 | AliExpress / Amazon | "4 channel 5V relay module optocoupler" | $3–6 | $4 | Controls 3× LED panels + 1× pump |
| E10 | Peristaltic pump | 12V DC, 40–100 mL/min, 4–6mm silicone tubing, food-grade | 1 | AliExpress / Amazon | "12V DC peristaltic pump dosing pump" | $8–18 | $12 | See watering-system.md |

**Actuator subtotal: ~$16**

---

## Sensors

| # | Component | Specification | Qty | Supplier | Search Term / Part | Unit Cost | Total | Notes |
|---|-----------|--------------|-----|----------|-------------------|-----------|-------|-------|
| E11 | Water level sensor | Capacitive non-contact, 5V or 3.3V output, XKC-Y25-V or equivalent | 1 | AliExpress / Amazon | "XKC-Y25-V capacitive water level sensor non-contact" | $3–8 | $5 | Mounts on exterior of PETG reservoir; no water contact |
| E12 | Temperature sensor (optional) | DS18B20 waterproof probe, 1-Wire, 3–5V, −55 to +125°C | 1 | AliExpress / Amazon | "DS18B20 waterproof temperature sensor" | $1–3 | $2 | Growing chamber temp monitoring; omit if reducing cost |

**Sensor subtotal: ~$7**

---

## Indicators

| # | Component | Specification | Qty | Supplier | Search Term / Part | Unit Cost | Total | Notes |
|---|-----------|--------------|-----|----------|-------------------|-----------|-------|-------|
| E13 | LED — power (green) | 3mm green LED, 2.1V forward voltage | 1 | AliExpress / electronics shop | "3mm green LED" | $0.10 | $0.10 | Power-on indicator |
| E14 | LED — water low (yellow) | 3mm yellow LED, 2.0V forward voltage | 1 | AliExpress / electronics shop | "3mm yellow LED" | $0.10 | $0.10 | Reservoir low alert |
| E15 | LED — harvest ready A (red) | 3mm red LED, 1.8V forward voltage | 1 | AliExpress / electronics shop | "3mm red LED" | $0.10 | $0.10 | Tray A harvest-ready |
| E16 | LED — harvest ready B+C (red) | 3mm red LED | 2 | AliExpress / electronics shop | "3mm red LED" | $0.10 | $0.20 | Tray B and C harvest-ready |
| E17 | Current-limiting resistors | 330Ω, 1/4W, ±5% | 10 | Any | "330 ohm resistor 1/4W" | $0.01 | $0.10 | For all status LEDs from 3.3V GPIO |
| E18 | Buzzer (optional) | 5V active buzzer, 85 dB, 12mm | 1 | AliExpress / Amazon | "5V active buzzer 12mm" | $0.50 | $0.50 | Low-water audible alert; omit if OLED display used |

**Indicator subtotal: ~$1.10**

---

## Wiring and Connectors

| # | Component | Specification | Qty | Supplier | Search Term / Part | Unit Cost | Total | Notes |
|---|-----------|--------------|-----|----------|-------------------|-----------|-------|-------|
| E19 | Hookup wire — heavy | 20 AWG, silicone-insulated (flexible), red and black, 3m each | 6m | AliExpress / Amazon | "20AWG silicone wire red black" | $0.80/m | $4.80 | 12V power runs (LED panels, pump, bus) |
| E20 | Hookup wire — light | 24 AWG, silicone or PVC, multi-colour, 2m | 6m | AliExpress / Amazon | "24AWG hookup wire" | $0.40/m | $2.40 | Signal wires (GPIO to relays, sensors, LEDs) |
| E21 | JST-XH 2-pin connectors | Male + female pairs, 2.54mm pitch (or 2mm pitch) | 10 pairs | AliExpress | "JST XH 2 pin connector pair" | $0.15/pair | $1.50 | Quick-disconnect for LED panels, pump |
| E22 | JST-XH 4-pin connectors | Male + female pairs | 5 pairs | AliExpress | "JST XH 4 pin connector pair" | $0.20/pair | $1.00 | Sensor connections |
| E23 | Prototype/stripboard | 5×7cm double-sided stripboard | 1 | AliExpress / Amazon | "5x7cm stripboard PCB prototype" | $0.50–1 | $0.75 | For soldering buck converter, fuse, protection circuit |
| E24 | Pin headers (male) | 2.54mm, 40-pin strips | 2 | AliExpress | "2.54mm male pin header strip 40pin" | $0.30 | $0.60 | For connecting ESP32 to breadboard or stripboard |
| E25 | Heat shrink tubing | Assorted 2mm/4mm/6mm, 1m each | 3m | AliExpress / Amazon | "heat shrink tubing assorted" | $1.50 | $1.50 | Insulating solder joints |
| E26 | Ferrule terminals | 0.75mm² (20AWG), 100 pack | 1 | AliExpress | "ferrule terminals 20AWG 0.75mm" | $2–3 | $2.50 | For secure screw terminal connections |

**Wiring subtotal: ~$15.05**

---

## Cost Summary

| Category | Subtotal |
|----------|----------|
| Control (ESP32, RTC, OLED) | $11.00 |
| Power (buck converter, fuse, protection, jack) | $4.25 |
| Lighting (3× LED panels) | $21.00 |
| Actuators (relay module + pump) | $16.00 |
| Sensors (water level + temp) | $7.00 |
| Indicators (LEDs, buzzer) | $1.10 |
| Wiring and connectors | $15.05 |
| **Electronics total** | **~$75.40** |

> Note: LED DIY strip option reduces lighting cost to ~$8, bringing electronics total to ~$62. All prices assume AliExpress sourcing. Amazon sourcing adds ~30–50%.

---

## Solar / Off-Grid Option (separate from core BOM)

| # | Component | Specification | Qty | Search Term | Est. Cost |
|---|-----------|--------------|-----|-------------|-----------|
| S01 | Solar panel | 40W monocrystalline 12V, Voc ~21V | 1 | "40W 12V monocrystalline solar panel" | $30–45 |
| S02 | MPPT charge controller | 10A, 12V/24V auto, with USB port | 1 | "10A MPPT solar charge controller 12V" | $15–25 |
| S03 | LiFePO4 battery | 12V 20Ah, with built-in BMS | 1 | "12V 20Ah LiFePO4 battery" | $45–70 |
| S04 | Solar cable + MC4 connectors | 10AWG, 3m pair | 1 | "MC4 solar cable 10AWG" | $6–10 |
| S05 | Battery cable + Anderson PP45 | 10AWG, 1m pair | 1 | "Anderson Powerpole PP45 connector" | $4–8 |
| — | **Solar subtotal** | | | | **$100–158** |

**Grand total (device + solar): ~$175–233**

---

## Wiring Diagram Reference

See [system-architecture.md](../02-design/system-architecture.md) for the complete wiring block diagram and interface table.
