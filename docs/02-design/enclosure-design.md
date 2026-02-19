# Enclosure Design

**Phase:** 02 Design
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Summary

The enclosure is a vertical column, 30 × 30 cm footprint × 85 cm tall, 3D-printed in PETG. It consists of stackable ring sections (one per tray level), a base unit (reservoir + electronics bay), and a top cap (seed storage + optional OLED display). All parts print on a 200×200mm print bed. The design is modular: adding a 4th tray requires only one additional ring section. Vehicle stability is achieved through a wide base and optional mounting bracket.

---

## Overall Dimensions

| Dimension | Value | Notes |
|-----------|-------|-------|
| Footprint (external) | 300 × 300 mm | Fits within 35×35cm constraint |
| Height (3-tray + base + cap) | ~850 mm | Within 90cm NFR target |
| Height (4-tray, scalable) | ~1100 mm | |
| Wall thickness | 4 mm | PETG structural strength |
| Internal width | 292 mm | 300 − 2×4mm walls |
| Material | PETG | Moisture-resistant, food-safe, high temp tolerance |
| Interior finish | White or reflective silver liner | Maximizes LED light reflection |
| Exterior finish | Matte black or user choice | Any PETG colour |

---

## Assembly Sections

The enclosure is made up of printed sections that stack and lock together:

### 1. Base Unit (300×300×200mm)

Contains:
- **Water reservoir** (2.4L sealed chamber, 204×142×84mm internal, rear-left quadrant)
- **Waste chamber** (1.0L sealed, 84×142×84mm internal, rear-right quadrant)
- **Electronics bay** (100×140×84mm, front-left quadrant, sealed from water zone by PETG partition + silicone gasket)
- **Power inlet** (5.5/2.1mm barrel jack, side-mounted)
- **Water fill port** (top-access screw cap, Ø40mm, positioned above reservoir)
- **Anti-slip pad** (4× silicone feet, press-fit into recesses on base bottom)
- **Vehicle mounting points** (4× M5 threaded inserts on base corners, for strap or bracket attachment)

Internal partition wall between electronics bay and water zone: PETG wall + RTV silicone bead. Any water condensation or micro-leak stays in the water zone.

### 2. Tray Level Ring (300×300×190mm per level — 3 required)

Each ring section contains one complete grow level:

```
┌─ LED Panel bracket (top of ring) ──────────────────┐
│  LED panel mounts to 3D-printed bracket, 10cm      │
│  above tray surface. Adjustable ±3cm via slot.     │
├─ Growing tray slot (middle of ring) ───────────────┤
│  Tray slides in from front; 5mm lip on both sides  │
│  holds tray in place during vehicle motion.        │
├─ Sub-tray slot (bottom of ring) ───────────────────┤
│  Sub-tray seated in lower pocket; drain fitting    │
│  routes to waste chamber tubing.                   │
└────────────────────────────────────────────────────┘
```

| Dimension | Value |
|-----------|-------|
| Outer | 300 × 300 × 190 mm |
| Tray opening | 256 × 256 mm (tray slides in from front) |
| Front door | Hinged PETG panel with magnetic catch |
| Interior height clearance (tray to LED) | ~80–110 mm (adjustable via LED bracket slot) |
| Drip inlet port | Ø8mm hole in rear wall for drip tubing |
| Drain outlet port | Ø8mm hole in base of sub-tray pocket |
| Stack connector | 6× M3 bolt holes top and bottom; sections bolt together |
| Print strategy | 4 L-shaped corner quarters (FL, FR, RL, RR) each ≤ 200×200mm |

**Front door:** Each tray level has a hinged PETG panel (150×174mm) with a magnetic catch. To harvest, open the door and slide out the growing tray. Door seals against a foam weather-strip to exclude light (important during adjacent tray germination phases).

### 3. Top Cap (300×300×80mm)

Contains:
- **Seed storage compartment** (60×60×50mm sealed box with lid)
- **Bag/marker storage** (open tray, 80×80×30mm)
- **Optional OLED display window** (Ø30mm or 40×20mm cutout, with clear PETG lens glued in place)
- **Handle / lift point** (integral loop handle on top surface)
- **Status LED window** (4× 3mm holes for indicator LEDs)
- **Ventilation fan mount** (37mm exhaust hole + 42mm recess + 4× M3 holes at fan rear; 40mm fan exhausts upward — DECISION-024)
- **Toggle switch cutout** (6.5mm panel-cut hole in front face right side for fan on/off switch)

---

## Print Strategy

All parts must fit on a 200×200mm print bed. Parts larger than this are split and joined with M3 hardware + PETG solvent weld or press-fit.

Each tray ring is printed as **4 L-shaped corner quarters** (FL=front-left, FR=front-right, RL=rear-left, RR=rear-right), each fitting on a 200×200mm bed — see DECISION-013.

| Part | Print bed needed | Qty | Est. filament | Est. print time |
|------|-----------------|-----|--------------|----------------|
| Base unit front half | 200×200mm | 1 | 310g | 9h |
| Base unit rear half | 200×200mm | 1 | 310g | 9h |
| Tray ring FL quarter | 200×200mm | 3 | 100g each | 3h each |
| Tray ring FR quarter | 200×200mm | 3 | 100g each | 3h each |
| Tray ring RL quarter | 200×200mm | 3 | 95g each | 2.5h each |
| Tray ring RR quarter | 200×200mm | 3 | 95g each | 2.5h each |
| Growing tray | 200×200mm | 3 | 60g each | 2h each |
| Sub-tray | 200×200mm | 3 | 50g each | 1.5h each |
| Top cap | 200×200mm | 1 | 95g | 3h |
| LED bracket | 200×200mm | 3 | 20g each | 0.5h each |
| Front door | 200×200mm | 3 | 30g each | 1h each |
| Misc (clips, manifold, emitters, LED panel) | 200×200mm | 1 set | 100g | 4h |
| **Total** | | | **~2,465g** | **~71.5h** |

**Total filament: approximately 2.5 kg PETG (~$50–62 at $20–25/kg)**

**Total print time: approximately 71.5 hours** (7–9 days on a single printer at normal speed; parallelizable across multiple printers)

---

## Print Settings

| Parameter | Value | Notes |
|-----------|-------|-------|
| Material | PETG | Moisture-resistant; food-safe; better than PLA for this application |
| Layer height | 0.2mm | Standard quality |
| Infill | 25% (decorative), 40% (structural: base, tray rings) | Higher infill for load-bearing parts |
| Wall perimeters | 4 | Critical for water-tight walls |
| Top/bottom layers | 6 | Helps with water resistance |
| Print temperature | 235–240°C (PETG typical) | Tune for your specific filament |
| Bed temperature | 70–85°C |  |
| Cooling | Moderate (50% fan) | Too much cooling causes PETG layer delamination |
| Supports | None (designed to print without supports) | Parts oriented for support-free printing |
| Water tightness | Post-process: apply XTC-3D epoxy coating or spray shellac to inner surfaces of reservoir | Ensures no weeping through layer lines |

---

## Material

**PETG (Polyethylene Terephthalate Glycol)**

| Property | Value | Relevance |
|----------|-------|-----------|
| Food safety | Generally food-safe (FDA food contact materials list) | Growing trays, water reservoir |
| Heat resistance | 80°C glass transition | Safe in vehicles (max interior: typically 60°C with windows closed) |
| UV resistance | Moderate | Better than PLA; acceptable indoors/in-vehicle |
| Moisture resistance | Excellent | Critical for water contact parts |
| Layer adhesion | Good | Important for water-tight printing |
| Flexibility | Slight | Reduces brittleness vs. PLA |
| Shrinkage | Low | Good dimensional accuracy |
| Cost | $20–25/kg | Mid-range |

**Do not use PLA for water-contact or heat-exposed parts.** PLA has a glass transition of only 60°C and will warp in a hot vehicle. PLA also degrades in moist environments over time. PETG is mandatory for all water-adjacent and structurally loaded parts. PLA may be used for decorative external parts only.

---

## Structural Design for Vehicle Use

| Challenge | Design solution |
|-----------|----------------|
| Tipping | Wide 300mm base; low center of gravity (water reservoir at base) |
| Tray sliding out | Each tray has a 5mm positive-lock lip; requires deliberate pull to remove |
| LED panel vibration | LED panel retained by 2× M3 bolts; no loose parts |
| Tubing vibration | All tubing secured every 50mm with 3D-printed clip-on saddles |
| Door rattling | Magnetic door catch; foam weather-strip around door perimeter |
| Vehicle mounting | 4× M5 inserts in base corners; user provides strap or custom bracket for their vehicle |

**Center of gravity:** With full reservoir (2kg water) at the base and minimal mass at the top, CG is approximately 200mm above the base — well within the 150mm (50% of 300mm base) stability limit.

---

## Ventilation

At 5.6W average power, the growing chamber temperature should remain close to ambient. Two complementary ventilation modes are available: passive (always available) and active (manual on-demand).

### Passive Ventilation — Ring Vent Slots

Each tray ring has two **25×8mm vent slots** (one in the front wall, one in the rear wall), positioned near the top of the ring (Z = ring_h − flange_h − 12mm). Each slot has a removable slide cover.

- **Normal operation:** Slide covers in place — ring is light-sealed during germination blackout periods.
- **Enhanced ventilation:** Remove slide covers on one or more rings — allows passive stack convection from lower rings upward.
- **Airflow path (passive):** Ambient air enters through lower ring vent slots → rises through the column (warm air from LED strips creates convection) → exits through any open upper slots or the active fan.

### Active Ventilation — 40mm 12V Fan with Manual Switch (DECISION-024)

A **40mm 12V brushless fan** is mounted in the top cap top surface and exhausts upward. It is controlled by a **manual SPST toggle switch** on the top cap front face — no firmware involvement.

| Parameter | Value |
|-----------|-------|
| Fan size | 40×40×10mm, 12V DC |
| Airflow | ~5–8 CFM (adequate for 56L column) |
| Noise | ≤25 dBA (brushless PC fan) |
| Power | ~1–1.8W at 12V (manual, not always on) |
| Fan location | Top cap top surface, centred at X=150mm, Y=220mm |
| Switch location | Top cap front face, right side, X=255mm, Z=50mm |
| Circuit | 12V bus → toggle switch → fan (no relay, no firmware) |

**Airflow path (active):** Ambient air enters through ring vent slots (slide covers open) → rises through column → exhausts upward via top cap fan.

**When to use the fan:**
- Surface mould or white fuzz observed on coir
- Persistent condensation on ring interior walls
- Ambient temperature above 28°C (vehicle in direct sun)
- During watering events in high-humidity environments

**Temperature target inside growing chamber: 18–24°C.** Broccoli microgreens tolerate 15–27°C but perform best at 20–22°C.

---

## Light Sealing

Each tray level must be light-sealed to ensure the germinating tray (LED off) is not illuminated by adjacent tray LEDs. The ring sections achieve this via:
- 2mm light-seal flange at every section join
- Black PETG or black felt strip at all section interfaces
- Front door foam weather-strip (3mm closed-cell foam, adhesive-backed)

This ensures that a tray in blackout phase stays dark even if the tray below it has its LED on.

---

## Enclosure BOM Estimate

| Item | Qty | Unit Cost | Total |
|------|-----|-----------|-------|
| PETG filament | 2.4 kg | $22/kg | $53 |
| M3 bolt/nut kit (50 pcs each) | 1 | $5 | $5 |
| M5 heat-set inserts (4×) | 1 | $2 | $2 |
| Magnetic door catches (3 pairs) | 1 | $3 | $3 |
| Foam weather-strip (3m) | 1 | $4 | $4 |
| Silicone anti-slip feet (4×) | 1 | $2 | $2 |
| XTC-3D epoxy (reservoir waterproofing) | 1 | $15 | $15 |
| O-ring for fill cap (Ø36mm) | 1 | $1 | $1 |
| Clear PETG sheet (OLED window) | 1 | $3 | $3 |
| **Enclosure total** | | | **~$88** |
