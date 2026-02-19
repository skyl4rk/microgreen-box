# Electrical Wiring Schematic — Microgreen Box

**Phase:** 03 Build (Electrical System)
**Status:** Complete
**Last Updated:** 2026-02-18
**Related decisions:** DECISION-008 through DECISION-019

---

## 1. Design Principles

| Principle | Implementation |
|-----------|---------------|
| Single primary voltage rail | 12V DC throughout |
| Voltage conversions | **Two stages only:** 12V→5V (MP1584 buck) then 5V→3.3V (ESP32 AMS1117 onboard) |
| All high-current 12V loads | Switched via relay, never through ESP32 |
| ESP32 3.3V GPIO protection | Relay module uses optocoupler isolation + JD-VCC separation |
| Reverse polarity | AO3401 P-channel MOSFET at input |
| Overcurrent | 5A inline blade fuse on 12V bus |
| Water safety | All signal wiring physically separated from water paths |

> **Why two conversion stages are unavoidable:** The ESP32 requires 3.3V logic. No commercially available 12V-native ESP32 dev board exists — all boards require 5V on VIN. Skipping the 12V→5V stage would require powering the ESP32's AMS1117 regulator directly from 12V, which exceeds its maximum input rating (8V abs. max for AMS1117-3.3). One buck stage is the minimum.

---

## 2. Power Flow Diagram

```
                         ┌─────────────────────────────────────────────┐
12V SOURCE               │              12V BUS                        │
(barrel jack             │                                             │
 5.5/2.1mm) ─────────► [AO3401]─►[5A Fuse]─────────────────────────►─┤
                         │                                             │
                         │  ┌──────────────────────────────────────┐  │
                         │  │      RELAY MODULE (4-ch)             │  │
                         │  │  CH1 COM──12V bus                    │  │
                         │  │  CH1 NO ─────────────────► LED A 12V │  │
                         │  │  CH2 NO ─────────────────► LED B 12V │  │
                         │  │  CH3 NO ─────────────────► LED C 12V │  │
                         │  │  CH4 NO ─────────────────► Pump 12V  │  │
                         │  │                                       │  │
                         │  │  JD-VCC ◄── 5V bus (coil power)      │  │
                         │  │  IN1–IN4 ◄── ESP32 GPIO (3.3V)       │  │
                         │  └──────────────────────────────────────┘  │
                         │                                             │
                         │  ┌──────────────────────────────────────┐  │
                         │  │  MP1584EN BUCK CONVERTER             │  │
                         │  │  IN: 12V   OUT: 5.00V (set/verified) │  │
                         │  └──────────────┬───────────────────────┘  │
                         │                 │ 5V BUS                    │
                         │        ┌────────┴──────────────┐            │
                         │        ▼                       ▼            │
                         │  [ESP32 VIN]           [Relay JD-VCC]       │
                         │  (AMS1117 onboard)     (coil supply)        │
                         │        │                                     │
                         │        ▼ 3.3V RAIL                          │
                         │  ┌──────────────────────────────────────┐  │
                         │  │  DS3231 RTC    SSD1306 OLED           │  │
                         │  │  Moisture ×3   Float switch pull-up   │  │
                         │  │  Status LEDs   Buzzer (via resistor)  │  │
                         │  └──────────────────────────────────────┘  │
                         └─────────────────────────────────────────────┘
```

---

## 3. Component List and Specifications

### 3.1 Power Input and Protection

| Ref | Component | Spec | Vendor / Part | URL | Price |
|-----|-----------|------|--------------|-----|-------|
| J1 | DC barrel jack | 5.5/2.1mm panel-mount, positive tip | AliExpress | https://www.aliexpress.com/item/32828603866.html | ~$0.75 |
| F1 | Inline blade fuse + holder | 5A automotive blade, inline holder | Any hardware | — | ~$1.50 |
| Q1 | Reverse polarity protection | AO3401 P-ch MOSFET SOT-23; Gate to GND via 10kΩ, Source to 12V_in, Drain to fuse | AliExpress | — | ~$0.50 |
| U1 | Buck converter | MP1584EN module, 3A, adj. output — pre-set to 5.00V | AliExpress item 32828603866 | https://www.aliexpress.com/item/32828603866.html | ~$0.65 |

**Buck converter wiring:**
```
12V_BUS ──► MP1584 VIN+
GND     ──► MP1584 VIN−
MP1584 VOUT+ ──► 5V_BUS
MP1584 VOUT− ──► GND
```
> Pre-adjust output to exactly 5.00V with a multimeter before connecting any load. Turn trim pot clockwise to increase, counter-clockwise to decrease.

---

### 3.2 Microcontroller — ESP32-WROOM-32 (38-pin dev board)

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| U2 | ESP32-WROOM-32 38-pin | AliExpress item 32864722159 | https://www.aliexpress.com/item/32864722159.html | ~$1.83 |
| — | Amazon alt. (5-pack) | AITRIP B09DPH1KXF | https://www.amazon.com/dp/B09DPH1KXF | ~$2.60/board |

**Power connections:**
```
5V_BUS ──► ESP32 VIN   (onboard AMS1117 regulates to 3.3V)
GND    ──► ESP32 GND
```

**Do not connect 12V directly to VIN.** AMS1117-3.3 abs. max input: 15V but practical limit is 6V due to heat dissipation. Use the MP1584 5V rail.

---

### 3.3 GPIO Pin Assignments

| GPIO | Direction | Function | Connected to | Wire gauge |
|------|-----------|----------|--------------|-----------|
| 13 | Output | Relay CH4 — Pump | Relay IN4 | 24 AWG |
| 16 | Output | Buzzer (optional) | Buzzer via 100Ω | 24 AWG |
| 17 | Output | Status LED — Tray B+C harvest (red) | LED via 330Ω | 24 AWG |
| 18 | Output | Status LED — Power on (green) | LED via 330Ω | 24 AWG |
| 19 | Output | Status LED — Water low (yellow) | LED via 330Ω | 24 AWG |
| 21 | I2C SDA | I2C data — RTC + OLED | DS3231 SDA, SSD1306 SDA | 24 AWG |
| 22 | I2C SCL | I2C clock — RTC + OLED | DS3231 SCL, SSD1306 SCL | 24 AWG |
| 25 | Output | Relay CH3 — LED Tray C (top ring) | Relay IN3 | 24 AWG |
| 26 | Output | Relay CH1 — LED Tray A (bottom ring) | Relay IN1 | 24 AWG |
| 27 | Output | Relay CH2 — LED Tray B (middle ring) | Relay IN2 | 24 AWG |
| 32 | ADC input | Moisture sensor C (ADC1_CH4) | Sensor C AOUT | 24 AWG |
| 33 | Digital input | Float switch — reservoir level | Float switch + 10kΩ pull-up | 24 AWG |
| 34 | ADC input | Moisture sensor A (ADC1_CH6, input-only) | Sensor A AOUT | 24 AWG |
| 35 | ADC input | Moisture sensor B (ADC1_CH7, input-only) | Sensor B AOUT | 24 AWG |
| 5  | Output | Status LED — Tray A harvest (red) | LED via 330Ω | 24 AWG |

**GPIO selection rationale:**
- GPIO34, 35: input-only pins (no internal pull-up/pull-down) — ideal for ADC; no conflict with output mode
- GPIO32, 33: full bidirectional with internal pull-up support; GPIO33 uses `INPUT_PULLUP` for float switch
- GPIO13, 25, 26, 27: safe output GPIOs (not strapping pins, not UART, not SPI flash)
- GPIO5: output-capable; note it is a strapping pin on some boards — verify it does not affect boot on your specific board
- GPIO16, 17, 18, 19: standard output GPIOs
- GPIO12 **avoided**: strapping pin affecting flash voltage on some modules
- GPIO0, 2, 15 **avoided**: boot-mode strapping pins
- GPIO6–11 **avoided**: connected to SPI flash
- GPIO1, 3 **avoided**: UART0 TX/RX (used for serial monitor / programming)
- ADC2 pins **avoided** for sensor input: ADC2 is disabled when WiFi is active (ESP-IDF limitation)

---

### 3.4 Real-Time Clock — DS3231

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| U3 | DS3231 + AT24C32 RTC module | AliExpress item 4000173986273 | https://www.aliexpress.com/item/4000173986273.html | ~$2.13 |

**Wiring:**
```
ESP32 3V3 ──► DS3231 VCC
ESP32 GND ──► DS3231 GND
ESP32 GPIO21 (SDA) ──► DS3231 SDA
ESP32 GPIO22 (SCL) ──► DS3231 SCL
```
CR2032 coin cell installed in module holder for backup timekeeping during power loss.
I2C address: 0x68 (DS3231), 0x57 (AT24C32 EEPROM — unused but shares bus).

---

### 3.5 OLED Display — SSD1306 (optional)

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| U4 | 0.96" 128×64 I2C OLED SSD1306 | AliExpress item 32643950109 | https://www.aliexpress.com/item/32643950109.html | ~$1.60 |

**Wiring (shared I2C bus with DS3231):**
```
ESP32 3V3 ──► OLED VCC
ESP32 GND ──► OLED GND
ESP32 GPIO21 (SDA) ──► OLED SDA
ESP32 GPIO22 (SCL) ──► OLED SCL
```
I2C address: 0x3C (verify with I2C scanner sketch if display doesn't appear).
I2C pull-up resistors (4.7kΩ to 3.3V) are typically included on the module boards.

---

### 3.6 Relay Module — 4-Channel

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| K1 | 4-ch 5V optocoupler relay module, hi/lo trigger | AliExpress item 32897567002 | https://www.aliexpress.com/item/32897567002.html | ~$3.10 |
| — | Amazon alt. | DIYables B0BXKKYH5C | https://www.amazon.com/dp/B0BXKKYH5C | ~$10 |

**Critical wiring note — JD-VCC isolation:**
```
5V_BUS ──► Relay JD-VCC   ← relay coil supply (DO NOT connect to ESP32 3.3V)
5V_BUS ──► Relay VCC      ← optocoupler logic supply  (OR leave floating if jumper removed)
GND    ──► Relay GND
```
**Remove the VCC–JD-VCC jumper** on the relay board. This electrically separates the relay coil power (5V, high inrush) from the optocoupler logic supply. Without this separation, relay coil switching causes voltage spikes on the 5V/3.3V lines that can reset the ESP32.

**Trigger mode:** Set to **LOW-level trigger** (jumper or solder bridge selection on board). ESP32 GPIO goes LOW to activate relay; HIGH (or floating with pull-up) to deactivate.

**Load wiring (all channels):**
```
12V_BUS ──► Relay CH[n] COM
Relay CH[n] NO ──► Load positive (LED V+ or Pump V+)
Load negative ──► GND
```

| Channel | Load | Peak current | Wire gauge |
|---------|------|-------------|-----------|
| CH1 | LED strip — Tray A | 250–400 mA | 20 AWG |
| CH2 | LED strip — Tray B | 250–400 mA | 20 AWG |
| CH3 | LED strip — Tray C | 250–400 mA | 20 AWG |
| CH4 | Peristaltic pump | 400–800 mA | 20 AWG |

---

### 3.7 LED Grow Lighting

**Research basis:** Full-spectrum white (5000–6500K) or dedicated plant-spectrum strip. Target PPFD: 100 µmol/m²/s at tray surface (10 cm clearance). Research finding FINDING-009 confirms 100 µmol/m²/s balances sulforaphane, carotenoids, and vitamin C production optimally.

**Why not Samsung LM301H/LM281B boards:** All genuine Samsung quantum boards operate at 38–54V DC constant-current. They are incompatible with a 12V single-rail design without a 12V→48V boost converter — an additional conversion stage violating the single-rail design principle. Strip-based 12V panels are the correct choice for this constraint.

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| LED1–3 | **Primary:** 12V full-spectrum plant grow strip (red+blue+white, 5050) | AliExpress item 32816538353 | https://www.aliexpress.com/item/32816538353.html | ~$11.41 (covers all 3 trays) |
| LED1–3 | **Alt (white spectrum):** Tesfish 12V 2835 6000K 240LED/m 5m roll | Amazon B08T89VRPP | https://www.amazon.com/dp/B08T89VRPP | ~$10 (covers all 3 trays) |

**Panel construction (DIY, per tray):**
1. Cut strip to **3× 60cm lengths** (4× 15cm sub-lengths per panel in zigzag) from one roll
2. Mount in zigzag pattern on 3D-printed `led_panel.stl` sled (100×100mm)
3. Back sled with aluminium tape for passive heat sinking
4. Seal strip with clear conformal coating (acrylic spray) for humidity protection
5. Terminate with JST-XH 2-pin connector (male, 20AWG leads) to relay NO/GND

**Power per panel (60cm of 5050 strip at 12V):**
```
5050 strip: ~60 LED/m × 0.15–0.25W/LED = ~9–15W/m
60cm strip: ~5.4–9W per panel

→ Exceeds 3W target. To limit to 3W, use a 10Ω 5W series resistor per panel.
  At 250mA draw: V_drop = 0.25A × 10Ω = 2.5V; power in resistor = 0.625W (safe)

Alternative: Use a shorter cut (25cm of 5050 strip) ≈ 3.75W ≈ within target.
```

**For the 2835 alternative (Tesfish 240LED/m):**
```
240LED/m at 12V ≈ 14.4W/m (typical for 2835 high density)
25cm cut ≈ 3.6W → close to 3W target, no resistor needed
Arrange: 1× 25cm strip folded in tight U-shape on 100×100mm sled
```

**LED wiring per channel:**
```
Relay CH[n] NO ──► 20AWG red ──► [Series resistor 10Ω 5W if using 60cm] ──► Strip V+
Strip V− ──► 20AWG black ──► GND
```

---

### 3.8 Peristaltic Pump

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| M1 | **Primary:** INTLLAB 12V peristaltic pump, 5–100 mL/min, 4-pack | Amazon B088TBKNSY | https://www.amazon.com/dp/B088TBKNSY | ~$25.80/4pk (~$6.45 each; buy 1 pack, keep 3 spare) |
| M1 | **Alt (adjustable):** Gikfun EK1971, 8–70 mL/min, with tubing | Amazon B0B4FMSJPV | https://www.amazon.com/dp/B0B4FMSJPV | ~$15–20 |
| M1 | **Alt (AliExpress):** R385 motor peristaltic head, 12V | AliExpress item 32770860268 | https://www.aliexpress.com/i/32770860268.html | ~$4–8 |

**Flow rate target:** 25 mL per tray per event × 3 trays = 75 mL per pump run.
At 50 mL/min, run time per event = 90 seconds. At 100 mL/min, 45 seconds.
> Set `pump_run_seconds` in firmware accordingly after measuring actual flow rate.

**Wiring:**
```
Relay CH4 NO ──► 20AWG red  ──► Pump V+ (red wire)
GND          ──► 20AWG black ──► Pump V− (black wire)
```
Pump polarity: red = positive. Reversing polarity reverses pumping direction — ensure correct orientation.
Tubing: 3mm ID × 5mm OD food-grade silicone (typically included with pump).

---

### 3.9 Coir Moisture Sensors (×3, one per tray)

**Design role:** Analog feedback for watering control. Supplements timer-based scheduling. If sensor reads "dry" after a scheduled event, firmware can trigger a short top-up cycle. If it reads "saturated" before a scheduled event, firmware skips that event.

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| S1–S3 | Capacitive Soil Moisture Sensor V1.2 | AliExpress item 32853373769 | https://www.aliexpress.com/item/32853373769.html | ~$1.22 each |
| S1–S3 | Amazon alt. (2-pack) | Gikfun EK1940 B07H3P1NRM | https://www.amazon.com/dp/B07H3P1NRM | ~$8–10/2pk |

**Wiring (identical for all three sensors):**
```
ESP32 3V3  ──► Sensor VCC
ESP32 GND  ──► Sensor GND
Sensor AOUT ──► ESP32 GPIO34 (Sensor A, Tray A — bottom)
Sensor AOUT ──► ESP32 GPIO35 (Sensor B, Tray B — middle)
Sensor AOUT ──► ESP32 GPIO32 (Sensor C, Tray C — top)
```

**Analog output behaviour (3.3V powered):**
- Dry coir (0% moisture): ~2.8–3.0V output
- Moist coir (field capacity, ~50%): ~1.5–1.8V output
- Saturated: ~0.8–1.2V output

**Calibration procedure (required on first use):**
1. Read raw ADC value with sensor in dry air → record as `DRY_THRESHOLD`
2. Read raw ADC value with sensor fully submerged in water → record as `WET_THRESHOLD`
3. `moisture_percent = map(adc_reading, DRY_THRESHOLD, WET_THRESHOLD, 0, 100)`
4. Firmware uses `moisture_percent < 30` as "needs water" flag; `moisture_percent > 70` as "skip watering"

**Physical installation:** Insert sensor vertically into coir to approximately half sensor depth (~3–4cm). Route cable through the rear wall drip port or a dedicated small cable grommet. Conformal-coat the sensor body (not the sensing tip) to protect from humidity.

---

### 3.10 Reservoir Float Switch

**Design role:** Binary low-water alarm. Provides definitive HIGH/LOW signal without calibration. Replaces the XKC-Y25-V capacitive approach (which requires precise flush mounting on PETG exterior — difficult in practice).

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| SW1 | ZP2508 mini vertical float switch, NC (normally closed) | AliExpress item 4000246458661 | https://www.aliexpress.com/item/4000246458661.html | ~$0.62 |

**Specs:** Body 19mm × 36mm total height, PP float, reed switch internal, max 0.5A switching, −10 to +85°C, 2-wire passive.

**Normally closed (NC) behaviour:**
- Float DOWN (water LOW): NC contacts **closed** → GPIO reads LOW (alarm condition)
- Float UP (water ADEQUATE): NC contacts **open** → GPIO reads HIGH (normal)

**Wiring:**
```
ESP32 3V3 ──► 10kΩ resistor ──┬──► ESP32 GPIO33 (input, INPUT_PULLUP mode)
                               │
                          Float switch
                          (NC contact)
                               │
                             GND
```
> In `INPUT_PULLUP` mode the ESP32 provides an internal ~45kΩ pull-up. The external 10kΩ adds a stronger pull-up. LOW = water low = trigger alert.

**Physical installation:** The float switch mounts inside the reservoir through a Ø5mm hole drilled or printed into the reservoir lid (reservoir_lid.stl). Use a rubber cable gland (M5 size, ~$0.30 each) to waterproof the wire entry. Suspend the switch body by its cable, positioned at the desired low-water threshold height (~20mm above reservoir floor). The float must hang freely without touching reservoir walls.

**Reservoir lid modification:** The current reservoir_lid.stl design has no cable gland port. Either:
- Drill a 5mm hole in a printed lid and install a rubber cable gland, or
- Add the port to the OpenSCAD source (`reservoir_lid.scad` — `lid_h` section) for next print

---

### 3.11 Status Indicators

**Wiring (all from 3.3V GPIO via current-limiting resistors):**
```
GPIO18 ──► 330Ω ──► Green LED anode ──► LED cathode ──► GND   [Power on]
GPIO19 ──► 330Ω ──► Yellow LED anode ──► LED cathode ──► GND  [Water low]
GPIO5  ──► 330Ω ──► Red LED anode ──► LED cathode ──► GND     [Tray A harvest]
GPIO17 ──► 330Ω ──► Red LED anode ──► LED cathode ──► GND     [Tray B+C harvest]
GPIO16 ──► 100Ω ──► Active buzzer + ──► Buzzer − ──► GND      [Audio alert, optional]
```
LED current: (3.3V − 2.0V) / 330Ω ≈ 4mA per LED — well within ESP32 12mA GPIO limit.
All four LEDs on simultaneously: 4 × 4mA = 16mA total — within ESP32 total output current limits.

---

### 3.12 Ventilation Fan — 40mm 12V Brushless Fan with Manual Switch (DECISION-024)

**Purpose:** Active humidity management. User-controlled — no relay, no firmware involvement. Run the fan when surface mould is observed, humidity is persistently high, or during warm-weather operation.

| Ref | Component | Vendor / Part | URL | Price |
|-----|-----------|--------------|-----|-------|
| FAN1 | 40mm 12V brushless fan, 40×40×10mm, ≤25 dBA | AliExpress / Amazon | — | ~$3.00 |
| SW2 | SPST mini toggle switch, panel-mount, 6mm body, 12V rated | AliExpress / Electronics shop | — | ~$1.00 |
| GRD1 | 40mm fan guard/grill, snap-fit | AliExpress | — | ~$0.50 |

**Circuit (manual, hardware-only):**
```
12V_BUS ──► SW2 (toggle switch — top cap front face) ──► FAN1 red (+) wire
FAN1 black (−) wire ──► GND
```

**Physical installation:**
- Fan mounted on top cap top surface; fan body sits in 42mm recess; label/inlet side faces INTO the cap; exhaust goes upward
- Fan secured with 4× M3×12mm bolts through fan corners into 4× M3 hex nuts (fan_bolt_ctc = 32mm square pattern)
- Fan guard snaps onto the fan exterior (top-facing) surface
- Toggle switch mounted in 6.5mm panel-cut hole on top cap front face, X=255mm, Z=50mm (right side, clear of OLED and status LEDs)
- Power tap: 20AWG wire from 12V bus at stripboard → SW2 input → SW2 output → FAN1 red (+) → FAN1 black (−) → GND bus

**Passive intake path:** Existing ring vent slots (25×8mm slide-cover slots at the top of each ring's front and rear walls) allow ambient air in from the lower rings when slide covers are removed. Airflow: intake through lower ring vent slots → up through column interior → exhaust via top cap fan.

**Electrical specs:**
- Typical 40mm 12V brushless fan: 0.08–0.15A at 12V = ~1–1.8W
- No relay required (toggle switch rated for 12V DC directly)
- Negligible impact on power budget: <2W peak, zero when off
- No firmware changes required — completely independent hardware circuit

---

## 4. Complete Wire-by-Wire Connection Table

| From | From pin/terminal | To | To pin/terminal | Wire | Colour |
|------|------------------|----|----------------|------|--------|
| J1 (barrel jack) | + tip | Q1 (AO3401 Source) | S | 20 AWG | Red |
| J1 (barrel jack) | − sleeve | GND bus | — | 20 AWG | Black |
| Q1 (AO3401 Drain) | D | F1 (fuse holder) | in | 20 AWG | Red |
| F1 (fuse holder) | out | 12V bus | — | 20 AWG | Red |
| 12V bus | — | U1 (MP1584) | VIN+ | 20 AWG | Red |
| GND bus | — | U1 (MP1584) | VIN− | 20 AWG | Black |
| U1 (MP1584) | VOUT+ | 5V bus | — | 20 AWG | Orange |
| U1 (MP1584) | VOUT− | GND bus | — | 20 AWG | Black |
| 5V bus | — | U2 (ESP32) | VIN | 24 AWG | Orange |
| GND bus | — | U2 (ESP32) | GND | 24 AWG | Black |
| 5V bus | — | K1 (relay) | JD-VCC | 24 AWG | Orange |
| 5V bus | — | K1 (relay) | VCC | 24 AWG | Orange |
| GND bus | — | K1 (relay) | GND | 24 AWG | Black |
| U2 GPIO26 | — | K1 (relay) | IN1 | 24 AWG | Yellow |
| U2 GPIO27 | — | K1 (relay) | IN2 | 24 AWG | Yellow |
| U2 GPIO25 | — | K1 (relay) | IN3 | 24 AWG | Yellow |
| U2 GPIO13 | — | K1 (relay) | IN4 | 24 AWG | Yellow |
| 12V bus | — | K1 (relay) CH1 | COM | 20 AWG | Red |
| 12V bus | — | K1 (relay) CH2 | COM | 20 AWG | Red |
| 12V bus | — | K1 (relay) CH3 | COM | 20 AWG | Red |
| 12V bus | — | K1 (relay) CH4 | COM | 20 AWG | Red |
| K1 CH1 | NO | LED strip A | V+ | 20 AWG | Red |
| K1 CH2 | NO | LED strip B | V+ | 20 AWG | Red |
| K1 CH3 | NO | LED strip C | V+ | 20 AWG | Red |
| K1 CH4 | NO | M1 (pump) | V+ | 20 AWG | Red |
| LED strip A | V− | GND bus | — | 20 AWG | Black |
| LED strip B | V− | GND bus | — | 20 AWG | Black |
| LED strip C | V− | GND bus | — | 20 AWG | Black |
| M1 (pump) | V− | GND bus | — | 20 AWG | Black |
| ESP32 3V3 | — | U3 (DS3231) | VCC | 24 AWG | Purple |
| GND bus | — | U3 (DS3231) | GND | 24 AWG | Black |
| U2 GPIO21 | SDA | U3 (DS3231) | SDA | 24 AWG | Blue |
| U2 GPIO22 | SCL | U3 (DS3231) | SCL | 24 AWG | Green |
| ESP32 3V3 | — | U4 (OLED) | VCC | 24 AWG | Purple |
| GND bus | — | U4 (OLED) | GND | 24 AWG | Black |
| U2 GPIO21 | SDA | U4 (OLED) | SDA | 24 AWG | Blue |
| U2 GPIO22 | SCL | U4 (OLED) | SCL | 24 AWG | Green |
| ESP32 3V3 | — | S1 (moist. A) | VCC | 24 AWG | Purple |
| ESP32 3V3 | — | S2 (moist. B) | VCC | 24 AWG | Purple |
| ESP32 3V3 | — | S3 (moist. C) | VCC | 24 AWG | Purple |
| GND bus | — | S1 (moist. A) | GND | 24 AWG | Black |
| GND bus | — | S2 (moist. B) | GND | 24 AWG | Black |
| GND bus | — | S3 (moist. C) | GND | 24 AWG | Black |
| S1 | AOUT | U2 GPIO34 | ADC | 24 AWG | White |
| S2 | AOUT | U2 GPIO35 | ADC | 24 AWG | White |
| S3 | AOUT | U2 GPIO32 | ADC | 24 AWG | White |
| ESP32 3V3 | — | 10kΩ resistor | one end | 24 AWG | Purple |
| 10kΩ resistor | other end | U2 GPIO33 | digital in | 24 AWG | White |
| 10kΩ resistor | other end | SW1 (float) | wire 1 | 24 AWG | White |
| SW1 (float) | wire 2 | GND bus | — | 24 AWG | Black |
| U2 GPIO18 | — | 330Ω | — | 24 AWG | — |
| 330Ω | — | Green LED anode | — | 24 AWG | Green |
| Green LED cathode | — | GND bus | — | 24 AWG | Black |
| U2 GPIO19 | — | 330Ω | — | 24 AWG | — |
| 330Ω | — | Yellow LED anode | — | 24 AWG | Yellow |
| Yellow LED cathode | — | GND bus | — | 24 AWG | Black |
| U2 GPIO5 | — | 330Ω | — | 24 AWG | — |
| 330Ω | — | Red LED A anode | — | 24 AWG | Red |
| Red LED A cathode | — | GND bus | — | 24 AWG | Black |
| U2 GPIO17 | — | 330Ω | — | 24 AWG | — |
| 330Ω | — | Red LED B anode | — | 24 AWG | Red |
| Red LED B cathode | — | GND bus | — | 24 AWG | Black |
| U2 GPIO16 | — | 100Ω | — | 24 AWG | — |
| 100Ω | — | Buzzer + | — | 24 AWG | — |
| Buzzer − | — | GND bus | — | 24 AWG | Black |

---

## 5. Power Budget

| Load | Voltage | Typical current | Typical power | Duty cycle | Avg power |
|------|---------|----------------|--------------|------------|-----------|
| LED strip A | 12V | 250–500 mA | 3–6W | 14/24h | 1.75–3.5W |
| LED strip B | 12V | 250–500 mA | 3–6W | 14/24h | 1.75–3.5W |
| LED strip C | 12V | 250–500 mA | 3–6W | 14/24h | 1.75–3.5W |
| Pump | 12V | 300–700 mA | 3.6–8.4W | ~3min/day | ~0.03W |
| Relay coils (all 4) | 5V | 4× 60–80 mA = 240–320 mA | 1.2–1.6W | always | 1.2–1.6W |
| ESP32 (active) | 5V | 80–240 mA | 0.4–1.2W | always | 0.5W |
| DS3231 RTC | 3.3V | 1.5 mA | 0.005W | always | 0.005W |
| SSD1306 OLED | 3.3V | 10–20 mA | 0.05W | always | 0.05W |
| 3× moisture sensors | 3.3V | 3× 5 mA | 0.05W | ~5min/hr | 0.004W |
| Status LEDs (worst case all on) | 3.3V | 4× 4 mA | 0.05W | varies | ~0.02W |
| Ventilation fan (when on) | 12V | 80–150 mA | 1–1.8W | manual | varies |
| **Peak power (all LEDs + pump)** | 12V in | **~1.25A** | **~15W** | — | — |
| **Average power (LEDs 14h/day)** | 12V in | **~0.55A** | **~6.6W** | — | — |
| **Peak with fan running** | 12V in | **~1.40A** | **~16.8W** | — | — |

**5A fuse at 12V = 60W capacity.** Peak of 15W is well within fuse rating.
**40W solar panel** at 4 peak-sun-hours × 0.85 efficiency = 136 Wh/day vs 6.6W × 24h = 158 Wh/day → marginal. Consider 50W panel for comfortable solar margin.

---

## 6. Connector Map

All inter-module connections use JST-XH 2.54mm connectors for quick-disconnect service. Wire colours follow automotive convention (red=+12V, orange=+5V, purple=+3.3V, black=GND, yellow=signal, blue=SDA, green=SCL, white=analog, grey=misc signal).

| Connector | Pins | Location | Connected to |
|-----------|------|----------|--------------|
| J2 | 2-pin XH | Base electronics bay | LED strip A (ring 1) |
| J3 | 2-pin XH | Base electronics bay | LED strip B (ring 2) |
| J4 | 2-pin XH | Base electronics bay | LED strip C (ring 3) |
| J5 | 2-pin XH | Base electronics bay | Pump |
| J6 | 3-pin XH | Base electronics bay | Moisture sensor A (Tray A) |
| J7 | 3-pin XH | Base electronics bay | Moisture sensor B (Tray B) |
| J8 | 3-pin XH | Base electronics bay | Moisture sensor C (Tray C) |
| J9 | 2-pin XH | Reservoir lid port | Float switch SW1 |
| J10 | 4-pin XH | Top cap | OLED display |
| J11 | 2-pin XH | Base / top cap | 12V power in from barrel jack |

---

## 7. Safety and Verification Checklist

Perform these checks in order before first power-on:

- [ ] Buck converter output verified at 5.00V DC (multimeter on VOUT terminals, no load)
- [ ] Relay JD-VCC jumper removed (optocoupler supply isolated from coil supply)
- [ ] All JST-XH connectors fully seated (audible click)
- [ ] Polarity verified on pump, LED strips (red = positive)
- [ ] Float switch cable gland in reservoir lid fully tightened (watertight)
- [ ] 5A fuse installed in F1 holder
- [ ] No 12V wiring near water paths (reservoir, sub-trays, drain tubing)
- [ ] ESP32 not yet connected when adjusting buck converter output
- [ ] I2C bus scan performed after first boot (confirms DS3231 at 0x68, OLED at 0x3C)
- [ ] Relay channels tested individually via serial console before enabling schedule
- [ ] Moisture sensors calibrated (dry air → submerged water readings recorded)
- [ ] Float switch LOW/HIGH state confirmed: pull float down → GPIO33 LOW; release → HIGH

---

## 8. Schematic Reference Diagram

```
                    ┌──────────────────────────────────────────────────────────────┐
                    │                    ESP32-WROOM-32 (U2)                       │
           ┌────────┤ VIN(5V)   3V3 ├────────────────────────────────────────────┐│
           │        │                │  DS3231(U3) VCC                            ││
           │        │ GND       GND ├────┬───────────────────────────────────────┤│
           │        │                │   │ GND bus                                ││
  5V bus ──┤        │ GPIO26    21(SDA)├─┬─┤ DS3231 SDA, OLED SDA                ││
           │        │ GPIO27    22(SCL)├─┴─┤ DS3231 SCL, OLED SCL                ││
           │        │ GPIO25         │                                             ││
           │        │ GPIO13   GPIO34├───┤ Sensor A AOUT                          ││
           │        │ GPIO18   GPIO35├───┤ Sensor B AOUT                          ││
           │        │ GPIO19   GPIO32├───┤ Sensor C AOUT                          ││
           │        │ GPIO5    GPIO33├───┤ Float switch (10kΩ pull-up to 3V3)     ││
           │        │ GPIO17   GPIO16├───┤ Buzzer (100Ω)                          ││
           └────────┤ GND            │                                             ││
                    └────────────────────────────────────────────────────────────┘│
                           │26│27│25│13│18│19│5│17                                 │
                           ▼  ▼  ▼  ▼                                              │
                    ┌──────────────────────────────────────────────────────────┐   │
                    │  K1: 4-CHANNEL RELAY MODULE                             │   │
                    │  IN1 IN2 IN3 IN4  [optocoupler isolated]                │   │
                    │  VCC JD-VCC ◄── 5V bus                                  │   │
                    │  GND ◄── GND bus                                        │   │
                    │  CH1 COM CH2 COM CH3 COM CH4 COM ◄── 12V bus            │   │
                    │  CH1 NO  CH2 NO  CH3 NO  CH4 NO                         │   │
                    └──┬──────┬──────┬──────┬──────────────────────────────────┘   │
                       │LED A  │LED B  │LED C  │Pump                               │
                       ▼       ▼       ▼       ▼                                   │
                   [LED sled] [LED sled] [LED sled] [Peristaltic pump]             │
                   (ring 1)  (ring 2)  (ring 3)   (base unit)                     │
                       └───────┴───────┴───────────────────────── GND ────────────┘
```

---

## 9. Wiring Harness Layout

Wire routing inside the enclosure column (bottom to top):

```
BASE UNIT (electronics bay)
├── Stripboard: MP1584 buck + AO3401 + fuse holder
├── ESP32 dev board (on pin headers)
├── DS3231 RTC module
├── K1: 4-channel relay module
└── All inter-module wiring (24AWG)

12V TRUNK (20AWG, red/black pair, routed up rear wall of rings)
├── Ring 1: LED strip A tap-off via JST-XH
├── Ring 2: LED strip B tap-off via JST-XH
└── Ring 3: LED strip C tap-off via JST-XH

SENSOR WIRING (24AWG, routed in separate bundle up front wall)
├── Ring 1: Moisture sensor A → GPIO34
├── Ring 2: Moisture sensor B → GPIO35
├── Ring 3: Moisture sensor C → GPIO32
└── Reservoir: Float switch → GPIO33

TOP CAP
├── OLED display (JST-XH 4-pin)
└── Status LED panel (JST-XH 6-pin: 4× GPIO + 2× GND)
```

Keep 12V power wiring and 3.3V signal wiring in separate bundles where possible. Twist 12V pairs (red+black) to minimise EMI interference on adjacent ADC sense lines.
