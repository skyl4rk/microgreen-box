# Power System Design

**Phase:** 02 Design
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Summary

The device operates on 12V DC primary power, sourced from a solar panel + LiFePO4 battery system (off-grid / vehicle), or a standard 12V DC mains adapter (home use). The system draws an average of 5.6W and a peak of 14.5W. A 40W solar panel with a 20Ah LiFePO4 battery provides adequate power in regions with ≥4 peak sun hours/day. In a vehicle, the 12V vehicle electrical system serves as the primary supply. All logic runs at 3.3V supplied by an on-board regulator from the 12V rail.

---

## Power Requirements (from design-requirements.md)

| Parameter | Value |
|-----------|-------|
| Primary supply voltage | 12V DC |
| Average power draw | 5.6W (134 Wh/day) |
| Peak power draw | 14.5W |
| Average current (12V) | 0.47A |
| Peak current (12V) | 1.21A |
| Input connector | 5.5/2.1mm barrel jack |

---

## Load Analysis

| Load | Component | Peak Power | Duty | Avg Power |
|------|-----------|------------|------|-----------|
| Lighting | 3× LED panel (3W each) | 9.0 W | 14/24 = 58% | 5.25 W |
| Pump | 12V peristaltic | 5.0 W | 6min/day = 0.4% | 0.02 W |
| MCU | ESP32 (active) | 0.35 W | ~70% active | 0.25 W |
| RTC | DS3231 | 0.01 W | 100% | 0.01 W |
| Sensors | Water level | 0.1 W | 50% polling | 0.05 W |
| Display | 0.96" OLED (optional) | 0.05 W | 25% | 0.01 W |
| Status LEDs | 4× 3mm LED | 0.04 W | varies | 0.02 W |
| **Total** | | **14.55 W peak** | | **5.61 W avg** |

**Daily energy: 5.61W × 24h = 134.6 Wh/day**

---

## Power Supply Options

### Option 1: Solar + Battery (Primary Off-Grid / Vehicle Option)

#### Solar Panel
| Parameter | Value |
|-----------|-------|
| Rated power | **40W** (minimum); 50W recommended |
| Type | Monocrystalline, 12V nominal |
| Open circuit voltage (Voc) | ~21V |
| Max power voltage (Vmp) | ~17V |
| Short circuit current (Isc) | ~2.5A (40W) |
| Size (approximate) | ~40W: 530×355mm; fits on vehicle roof rack |
| Cost | $25–45 USD |

**Energy balance check:**
```
Generation (40W, 4 peak sun hours, 85% efficiency):
  40W × 4h × 0.85 = 136 Wh/day

Daily consumption: 135 Wh/day

Net: +1 Wh/day (break-even at 4 peak sun hours)
```
→ 40W panel achieves energy balance in 4 peak sun hours (conservative US average).
→ In 3 peak sun hours: 40 × 3 × 0.85 = 102Wh/day — draws 33Wh/day from battery.
→ In 5 peak sun hours: 40 × 5 × 0.85 = 170Wh/day — surplus 35Wh/day charges battery.

**Recommendation: 50W panel** for comfortable positive energy balance in all but extreme low-sun conditions ($35–55).

#### MPPT Solar Charge Controller
| Parameter | Value |
|-----------|-------|
| Type | MPPT (Maximum Power Point Tracking) — 8–15% more efficient than PWM |
| Rating | 10A, 12V/24V auto |
| Input voltage range | Up to 50V input — suitable for 40W panel |
| Output | 12V to battery |
| Protection | Overcharge, overdischarge, short circuit, reverse polarity |
| Cost | $12–25 USD |
| Example | Epever 10A MPPT, Victron SmartSolar 75/10, generic 10A MPPT |

#### Battery
| Parameter | Value |
|-----------|-------|
| Chemistry | **LiFePO4** (lithium iron phosphate) |
| Voltage | 12V (4S LiFePO4: 4 × 3.2V = 12.8V nominal) |
| Capacity | **20Ah** |
| Usable energy | 20Ah × 12V × 0.8 (80% DoD) = **192 Wh** |
| Autonomy (no solar) | 192 Wh / 5.61W = **34 hours** |
| Autonomy (30W solar, 3h sun) | Deficit = 135 – 102 = 33 Wh/day; battery lasts 192/33 = **5.8 days** |
| Charge cycles | >2000 cycles to 80% capacity |
| Weight | ~2.5 kg |
| BMS | Built-in (required) |
| Cost | $35–70 USD |
| Form factor | Standard 20Ah LiFePO4 12V box battery |

**Why LiFePO4 over lead-acid:**
- Much lighter (2.5 kg vs. ~7 kg for equivalent lead-acid)
- Tolerates 80% depth of discharge vs. 50% for lead-acid
- Stable chemistry (no off-gassing; safe in enclosed vehicle)
- Longer cycle life

**Why LiFePO4 over lithium polymer (LiPo):**
- Safer in high-temperature vehicle environments
- No fire risk from over-discharge or puncture
- BMS is simpler/cheaper

### Option 2: Vehicle 12V Supply (Mobile Use, No Solar Panel Needed)

In a vehicle, the device connects directly to the vehicle's 12V electrical system:
- Via cigarette lighter / 12V accessory socket (typically fused at 10–20A — ample)
- Or direct to battery via inline 5A fuse

| Consideration | Detail |
|---------------|--------|
| Voltage range | Vehicle 12V varies 11.5–14.8V (charging) — device must tolerate this |
| Regulator requirement | Yes — use a buck converter to regulate to stable 12V for LEDs |
| Connection | Cigarette lighter plug (5A rated) or Anderson Powerpole connector |
| Running while parked | Draws 0.47A avg; OK for vehicle battery if vehicle runs daily |
| Risk | Avoid fully depleting vehicle battery if parked >2 days without running |
| Mitigation | Low-voltage cutoff relay at 11.5V (protects vehicle battery) |

### Option 3: 12V Mains Adapter (Home Use)

Simplest option for stationary home use:

| Parameter | Value |
|-----------|-------|
| Adapter spec | 12V DC, 2A (24W) — provides margin over 14.5W peak |
| Connector | 5.5/2.1mm barrel (positive centre) |
| Cost | $8–15 USD |
| Protection | Regulated output; short-circuit protected |

This option requires no battery, no MPPT controller, and no solar panel. Total home-use BOM is significantly lower.

---

## On-Board Power Distribution

### Voltage Rails

| Rail | Voltage | Source | Loads |
|------|---------|--------|-------|
| V_BAT | 12V (unregulated, 11–14.8V) | Battery / vehicle / adapter | LED panels, pump relay |
| V_12 | 12V regulated | Buck converter (if needed) | Relay module coil |
| V_5 | 5V regulated | LM7805 or MP1584 buck module | ESP32 VIN, relay logic |
| V_3V3 | 3.3V | ESP32 internal LDO | MCU, sensors, OLED |

**Preferred regulator: MP1584EN-based buck module** (wide input 4–28V, adjustable output, 3A max, ~$1–2 USD). More efficient and lower heat than LM7805 linear regulator.

### Power Input Stage

```
12V Input (barrel jack)
      │
   [Reverse polarity protection — P-channel MOSFET or Schottky diode]
      │
   [5A Inline fuse]
      │
   [12V Bus]
   /         \
[LED relays]  [Buck converter → 5V → ESP32]
[Pump relay]
```

**Inline fuse:** 5A polyblade automotive fuse in fuse holder — protects wiring from short circuits.

**Reverse polarity protection:** Required for solar/vehicle use where polarity errors are possible.

---

## Protection Features

| Protection | Implementation |
|-----------|---------------|
| Reverse polarity | P-channel MOSFET gate circuit or series Schottky diode |
| Overcurrent | 5A inline fuse |
| LED short circuit | LED panels individually fused or current-limited via driver |
| Low battery cutoff | MPPT controller built-in + optional low-voltage relay at 11.5V |
| Overtemperature | ESP32 NTC monitoring (optional); enclosure passive cooling sufficient at 5.6W avg |
| Water ingress into electronics | Electronics bay physically separated from growing/water zone by PETG wall + gasket |

---

## Power System BOM Estimate

### Off-Grid Solar Configuration (Full)

| Item | Qty | Unit Cost | Total |
|------|-----|-----------|-------|
| 40W or 50W monocrystalline solar panel | 1 | $30–55 | $30–55 |
| 10A MPPT solar charge controller | 1 | $15–25 | $15–25 |
| 20Ah LiFePO4 12V battery | 1 | $40–70 | $40–70 |
| Solar panel cable + connectors (MC4) | 1 set | $5–10 | $5–10 |
| Anderson Powerpole connectors | 1 set | $3–5 | $3–5 |
| **Solar subtotal** | | | **$93–165** |

### On-Device Electronics

| Item | Qty | Unit Cost | Total |
|------|-----|-----------|-------|
| 5.5/2.1mm barrel jack (panel mount) | 1 | $1 | $1 |
| MP1584EN buck converter module (12V→5V) | 1 | $1–2 | $1–2 |
| 5A blade fuse + holder | 1 | $1–2 | $1–2 |
| P-channel MOSFET (reverse polarity) | 1 | $0.50 | $0.50 |
| Wiring (20 AWG hookup wire, 3m) | 1 | $3–5 | $3–5 |
| JST-XH connectors (power distribution) | 1 set | $2–4 | $2–4 |
| **On-device power hardware** | | | **~$8–15** |

### Mains-Only Alternative

| Item | Qty | Unit Cost | Total |
|------|-----|-----------|-------|
| 12V 2A mains adapter | 1 | $8–15 | $8–15 |
| **Mains subtotal** | | | **$8–15** |

---

## Vehicle Installation Notes

1. Connect via cigarette lighter with an inline 5A fuse or direct to battery via Anderson Powerpole.
2. Ensure the 12V accessory socket is switched off when ignition is off (most modern vehicles) OR use the low-voltage cutoff relay to prevent battery drain.
3. Route cable away from heat sources (exhaust, engine bay).
4. Secure the device with a friction mat or Velcro for vehicle stability.
5. The device can run while driving; pump and light cycles continue normally while vehicle is in motion.
