# Lighting System Design

**Phase:** 02 Design
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Summary

Each of the 3 tray levels has a dedicated 12V LED grow panel mounted directly above the growing tray at 10 cm clearance. Target PPFD is 100 µmol/m²/s (balanced for sulforaphane and vitamins). Default photoperiod is 14 hours on / 10 hours off. Each LED channel is independently software-controlled by the ESP32, allowing the germination blackout (days 1–2) to be enforced per-tray without physical intervention.

---

## Lighting Requirements (from design-requirements.md)

| Requirement | Value |
|-------------|-------|
| PPFD at tray surface | 80–120 µmol/m²/s |
| Spectrum | Full-spectrum 5000–6500K white, or red (660nm) + blue (450nm) |
| Photoperiod | 14h on / 10h off (default) |
| Germination blackout | Days 0–2 per tray: LED off |
| Power supply | 12V DC |
| Max power per tray | 5W (budget); target 3W with efficient LEDs |
| Independent control | Yes — each tray has its own switched channel |

---

## Spectrum Selection

### Option A: Full-Spectrum White LED (Recommended)

**Specification: 5500–6500K colour temperature, high CRI (≥80)**

| Pros | Cons |
|------|------|
| Simpler wiring (single LED type) | Slightly less efficient than tuned red/blue |
| Low cost (standard LED strips) | Cannot tune spectrum post-build |
| Produces natural-looking plant growth | — |
| Easier to source and replace | — |

White LEDs at 6000K emit strongly in both the blue (430–480nm) and red (620–680nm) absorption peaks of chlorophyll, plus a broad midrange that supports carotenoid and anthocyanin synthesis. For microgreens harvested at day 8–10, the full spectrum is appropriate and avoids the all-red "leggy growth" phenomenon.

### Option B: Red + Blue Bichromatic

**Specification: ~660nm red + ~450nm blue, ratio 3:1 (R:B)**

| Pros | Cons |
|------|------|
| Most efficient photosynthetic activation | Produces purple/magenta light (visually unappealing) |
| Targeted spectrum | More complex driver; two LED types |
| Can tune for carotenoid (more red) or vitamin C (more blue) | — |

**Selected: Option A (full-spectrum white)** — simpler, lower cost, adequate performance, easier to source replacements. If a future revision requires spectrum tuning, Option B LED drivers can be swapped in without changing the enclosure.

---

## LED Panel Specification

| Parameter | Value |
|-----------|-------|
| Quantity | 3 (one per tray level) |
| Format | PCB LED board, 100×100 mm (custom) OR pre-made 10×10cm LED panel |
| Voltage | 12V DC |
| Power per panel | **3W nominal** (current-limited by driver); budget for 5W |
| Current at 12V / 3W | 250 mA |
| LED type | Samsung LM301H, LM281B+, or equivalent high-efficacy LED (≥2.7 µmol/J) |
| OR (budget option) | 12V LED grow strip 60 LEDs/m, SMD 2835, 4.8W/m; cut to 60 cm, folded into 15×15cm grid |
| Colour temperature | 5000–6500K |
| Expected PPFD at 10cm | ~100–130 µmol/m²/s (measured at center; ~80 µmol/m²/s at edges) |
| Beam angle | 120° (wide flood to maximise coverage over 25×25cm) |
| Mounting clearance | **10 cm above tray surface** (adjustable ±3 cm via slotted bracket) |
| Heat dissipation | Passive; aluminium PCB or aluminium tape backing; no fan required at 3W |

### PPFD Calculation (3W, 2.7 µmol/J LEDs, 10cm distance)

```
Light output: 3W × 2.7 µmol/J = 8.1 µmol/s total
Coverage area: 25×25 cm = 625 cm² = 0.0625 m²
Average PPFD: 8.1 µmol/s / 0.0625 m² = 130 µmol/m²/s (theoretical)

Accounting for optical losses (~25%): 130 × 0.75 = ~97 µmol/m²/s

Result: ~97–100 µmol/m²/s at tray center — meets NFR-009 target. ✓
```

At 5W (budget panel): ~162 µmol/m²/s theoretical, ~122 µmol/m²/s actual — also acceptable (upper range of target).

---

## Wiring

Each LED panel connects to a relay channel on the relay module:
- **Common positive:** 12V rail → relay NO (normally open) contact → LED panel V+
- **Common negative:** LED panel V− → GND rail
- **Relay coil:** 5V signal from ESP32 GPIO via 2N2222 transistor (or relay board with optocoupler)
- **Wire gauge:** 24 AWG for LED connections (250 mA max per panel); 20 AWG for main 12V run

### Wiring Diagram (per channel)

```
12V ──── Relay NO ──── LED+
                       │
                     [LED PANEL]
                       │
GND ────────────────── LED-

ESP32 GPIO (3.3V) → Relay module IN pin (optocoupler isolated)
```

---

## Relay Module

| Parameter | Value |
|-----------|-------|
| Type | 4-channel 5V relay module with optocoupler isolation |
| Channels used | 3 (one per LED panel) + 1 spare (for pump) |
| Input signal | 3.3V GPIO from ESP32 (active LOW or active HIGH; configurable) |
| Contact rating | 10A @ 250VAC / 10A @ 30VDC — ample for 250mA loads |
| Cost | ~$3–6 USD |
| Part number | SRD-05VDC-SL-C relay module (generic 4-channel, widely available) |

Using all 4 relay channels: 3× LED + 1× pump. This consolidates all switched 12V loads onto a single relay board.

---

## Photoperiod Schedule

| Phase | Duration | Default time window |
|-------|----------|---------------------|
| Lights ON | 14 hours | 06:00 – 20:00 (configurable) |
| Lights OFF | 10 hours | 20:00 – 06:00 |
| Germination override | Days 1–2 per tray | LED suppressed regardless of time |

**Why 14 hours:**
- 12h minimum for adequate DLI (Daily Light Integral) at 100 µmol/m²/s
- 16h maximum studied for microgreens; diminishing returns above 14h
- 14h × 100 µmol/m²/s = DLI of 5.04 mol/m²/day — within the optimal 4–8 mol/m²/day range for brassica microgreens
- Saves ~30% lighting power vs 16h photoperiod without meaningful yield loss

**Low-power mode option (configurable in firmware):** 12h photoperiod reduces daily lighting energy from 126Wh to 108Wh — useful in marginal solar conditions.

---

## Power Calculations

| Configuration | Peak lighting power | Daily energy |
|--------------|--------------------:|-------------:|
| 3× 3W panels, 14h | 9 W | 126 Wh |
| 3× 5W panels, 14h | 15 W | 210 Wh |
| 3× 3W panels, 12h (low-power mode) | 9 W | 108 Wh |

**Design basis: 3× 3W = 9W peak, 126 Wh/day lighting energy.**

---

## LED Panel Options (Procurement)

### Option 1: Pre-made 12V LED Grow Panel (easiest)
- Search: "12V 10W LED grow panel 100×100mm" or "12V 5W LED grow light board"
- Current-limit to 3W by adding series resistor or adjustable LED driver
- Cost: $5–12 per panel on AliExpress
- Delivery: 2–4 weeks from China, or available on Amazon ($10–20)

### Option 2: DIY Strip on 3D-Printed Backing (most customizable)
- 12V 2835 LED strip, 60 LEDs/m, 4.8W/m, 6000K
- Cut 4× 15cm strips (= 60cm total, ~2.88W)
- Mount on 3D-printed 100×100mm sled with reflective tape backing
- Seal with clear conformal coating for moisture protection
- Cost: $3–5 per panel

### Option 3: Samsung LM301H PCB (highest efficiency, custom)
- Order custom PCB from JLCPCB ($5 for 5 boards)
- Hand-solder 9× LM301H LEDs in 3S3P configuration (3W at 12V)
- Requires basic PCB design (KiCad or EasyEDA)
- Cost: $8–15 per panel; highest quality
- **Recommended for final production version**

**Phase 03 will finalize LED panel selection. Option 1 recommended for prototype.**

---

## Thermal Management

At 3W per panel, heat dissipation is minimal:
- LED efficiency: ~40–50% → ~1.5W heat per panel
- No forced cooling required at this power level
- Aluminium-backed PCB (standard for LED strips) sufficient
- Enclosure provides passive convection

Monitor that growing chamber temperature stays between **18–24°C** for optimal broccoli growth. If ambient temperature exceeds 30°C, consider adding a small 5V computer fan ($2) for forced convection. This is not required for typical room-temperature or vehicle operation.

---

## Nutrient Impact of Light Settings

From research ([nutritional-profile.md](../01-research/nutritional-profile.md)):
- **100–150 µmol/m²/s:** Higher chlorophyll, carotenoids, anthocyanins
- **50–75 µmol/m²/s:** Higher vitamin C and total phenolics

The 100 µmol/m²/s target balances both. If the user desires maximum vitamin C, reduce LED drive current by ~40% (add resistor or use PWM dimming via ESP32) — no hardware change required.
