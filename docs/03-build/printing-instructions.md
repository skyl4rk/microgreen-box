# 3D Printing Instructions

**Phase:** 03 Build
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Overview

All structural parts are printed in **PETG**. Pre-built STL files for all 20 parts are included in the repository at `hardware/3d-models/stl/` — ready to print or upload to a print service.

**CRITICAL: Use PETG for all parts.** PLA will warp in hot vehicles (Tg ~60°C) and degrade in moisture. PETG is mandatory for all structural, water-contact, and tray parts.

---

## Option A — Order from a 3D print service (no printer required)

If you do not have a 3D printer, any online or local print service can produce the parts:

1. **Download the STL files** from `hardware/3d-models/stl/` (20 files)
2. **Upload to a service** — for example:
   - [Craftcloud](https://craftcloud3d.com) — compares prices across many services
   - [JLCPCB 3D Printing](https://3d.jlcpcb.com) — low cost, ships internationally
   - [Treatstock](https://www.treatstock.com) — find local print shops
   - Local library or makerspace with a 3D printer
3. **Select PETG** as the material — do not accept substitution with PLA
4. **Specify quantities and infill** using the parts table below
5. **Specify 4 perimeters / wall loops** and **6 top/bottom layers** for water-tight parts (reservoir, sub-trays)

**Estimated cost from a print service:** ~$80–150 depending on service, shipping, and region (filament-only cost is ~$55; services add labour and overhead).

---

## Option B — Print yourself

Minimum build plate: 200×200mm. Heated bed required.

---

## Printer Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Build volume | 200×200×200mm | 250×250×250mm |
| Heated bed | Yes (70°C) | Yes |
| Direct drive or Bowden | Either | Direct drive (better PETG retraction) |
| Slicer | Cura, PrusaSlicer, or Bambu Studio | PrusaSlicer 2.7+ |

---

## Global Print Settings (PETG)

| Parameter | Value | Notes |
|-----------|-------|-------|
| Layer height | 0.20 mm | Standard quality |
| First layer height | 0.25 mm | Better bed adhesion |
| Nozzle temperature | 235–245°C | Tune to your filament brand |
| Bed temperature | 70–85°C | PETG prefers warmer beds |
| Print speed | 40–60 mm/s | Slower = better layer adhesion for water-tight parts |
| Fan speed | 20–30% | PETG needs minimal cooling; too much → delamination |
| Retraction | 2–4mm (direct), 6–8mm (Bowden) | Tune to eliminate stringing |
| Perimeters / wall loops | **4** | Critical for water-tight reservoir walls |
| Top / bottom layers | **6** | Critical for water resistance |
| Infill | Per part (see table below) | |
| Infill pattern | Gyroid or grid | Gyroid for strength; grid for speed |
| Seam position | Rear | Minimises visible seam on front-facing parts |
| Supports | **None** (designed support-free) | All parts oriented for no-support FDM |
| Brim | 5mm on first layer for tall parts | Prevents warping |

---

## Parts List and Print Settings

### BASE UNIT

| Part | File | Qty | Infill | Filament | Est. Time | Notes |
|------|------|-----|--------|----------|-----------|-------|
| Base front half | `base_front.stl` | 1 | 40% | 280g | 8h | Split at centre; bolt together with base_rear |
| Base rear half | `base_rear.stl` | 1 | 40% | 250g | 7h | Contains reservoir and electronics bay chambers |
| Reservoir lid | `reservoir_lid.stl` | 1 | 40% | 30g | 1h | Screw cap with O-ring groove; must be watertight |
| Waste chamber lid | `waste_lid.stl` | 1 | 40% | 20g | 0.75h | Removable for emptying |
| Electronics bay cover | `electronics_cover.stl` | 1 | 30% | 25g | 0.75h | Sealed from water zone |
| Pump mount bracket | `pump_mount.stl` | 1 | 40% | 15g | 0.5h | Holds peristaltic pump in base |

**Base subtotal: ~620g filament, ~18h**

### TRAY LEVEL RING (×3)

Each ring is split into 4 quarters for print bed compatibility. Print 3 complete sets.

| Part | File | Qty per level | Infill | Filament per set | Est. Time per set | Notes |
|------|------|--------------|--------|-----------------|------------------|-------|
| Ring front-left quarter | `ring_FL.stl` | 1 | 30% | 100g | 3h | L-shaped corner quarter; front-left |
| Ring front-right quarter | `ring_FR.stl` | 1 | 30% | 100g | 3h | L-shaped corner quarter; front-right |
| Ring rear-left quarter | `ring_RL.stl` | 1 | 30% | 95g | 2.5h | L-shaped corner quarter; rear-left |
| Ring rear-right quarter | `ring_RR.stl` | 1 | 30% | 95g | 2.5h | L-shaped corner quarter; rear-right |
| **Ring subtotal (×1)** | | | | **390g** | **11h** | |
| **Ring subtotal (×3)** | | | | **1,170g** | **33h** | |

### GROWING TRAY (×3)

| Part | File | Qty | Infill | Filament | Est. Time | Notes |
|------|------|-----|--------|----------|-----------|-------|
| Growing tray | `growing_tray.stl` | 3 | 30% | 60g each | 2h each | 4× Ø8mm drain holes in base; lip fits sub-tray |
| **Tray subtotal (×3)** | | | | **180g** | **6h** | |

### SUB-TRAY (×3)

| Part | File | Qty | Infill | Filament | Est. Time | Notes |
|------|------|-----|--------|----------|-----------|-------|
| Sub-tray body | `sub_tray.stl` | 3 | 40% | 50g each | 1.5h each | Sealed; overflow port on side wall at 25mm; **waterproof coat required** |
| **Sub-tray subtotal (×3)** | | | | **150g** | **4.5h** | |

### LED BRACKETS (×3)

| Part | File | Qty | Infill | Filament | Est. Time | Notes |
|------|------|-----|--------|----------|-----------|-------|
| LED bracket | `led_bracket.stl` | 3 | 30% | 20g each | 0.5h each | Slotted for height adjustment; holds LED panel |
| **LED bracket subtotal** | | | | **60g** | **1.5h** | |

### FRONT DOORS (×3)

| Part | File | Qty | Infill | Filament | Est. Time | Notes |
|------|------|-----|--------|----------|-----------|-------|
| Hinged door | `tray_door.stl` | 3 | 20% | 30g each | 1h each | Fits ring_front hinge points; magnetic catch at closure |
| **Door subtotal** | | | | **90g** | **3h** | |

### TOP CAP

| Part | File | Qty | Infill | Filament | Est. Time | Notes |
|------|------|-----|--------|----------|-----------|-------|
| Top cap body | `top_cap.stl` | 1 | 25% | 80g | 2.5h | Seed storage, bag storage, LED windows, handle |
| Seed box lid | `seed_box_lid.stl` | 1 | 25% | 15g | 0.5h | Small sliding or hinged lid for seed compartment |
| **Top cap subtotal** | | | | **95g** | **3h** | |

### MISCELLANEOUS PRINTED PARTS

| Part | File | Qty | Infill | Filament | Est. Time | Notes |
|------|------|-----|--------|----------|-----------|-------|
| Tubing saddle clips | `tube_clip.stl` | 12 | 50% | 5g each | 0.25h each | Secures silicone tubing inside column every 50mm |
| Water manifold | `manifold_3way.stl` | 1 | 60% | 10g | 0.5h | 1-to-3 splitter for drip tubing; alternative to barbed fittings |
| Drip emitter cap | `drip_emitter.stl` | 3 | 60% | 3g each | 0.25h each | 2mm orifice; press-fits onto 6mm OD tubing |
| Status LED panel | `led_panel.stl` | 1 | 25% | 10g | 0.3h | 4× 3mm LED mounting panel for top cap |
| **Misc subtotal** | | | | **100g** | **4h** | |

---

## Total Filament and Time Summary

| Section | Filament | Print Time |
|---------|----------|------------|
| Base unit | 620g | 18h |
| Tray rings (×3) | 1,170g | 33h |
| Growing trays (×3) | 180g | 6h |
| Sub-trays (×3) | 150g | 4.5h |
| LED brackets (×3) | 60g | 1.5h |
| Front doors (×3) | 90g | 3h |
| Top cap | 95g | 3h |
| Miscellaneous | 100g | 4h |
| **Total** | **~2,465g** | **~73h** |

**At $22/kg PETG: ~$54 filament cost**
**At 65+ hours print time: plan for 7–10 days on a single printer running ~10h/day**

---

## Post-Processing

### 1. Support removal
None required (all parts designed support-free).

### 2. Seam cleaning
Lightly sand any layer seams on mating surfaces with 220-grit sandpaper. Flat mating faces should be smooth for gasket sealing.

### 3. Waterproofing (CRITICAL for reservoir and sub-trays)

PETG layer lines are not inherently watertight. Apply one of the following to all interior surfaces of the **reservoir**, **waste chamber**, and **sub-trays**:

**Option A: XTC-3D Epoxy Coating (recommended)**
- Mix XTC-3D 2:1 by volume
- Apply thin coat with a foam brush to all interior surfaces
- Let cure 4 hours; apply second coat if needed
- Fully cured in 24 hours
- Result: glassy, hard, fully watertight
- Cost: ~$15–20 per bottle (covers 3–4 parts)

**Option B: Rustoleum Crystal Clear spray lacquer**
- Apply 3–4 coats to interior, letting each dry 30 min
- Not as robust as XTC-3D but adequate for water-at-rest (not pressure)
- Cost: ~$8–12

**Option C: Silicone RTV**
- Brush RTV silicone into all joints and seams only (not full surface coat)
- Requires 24h cure before water contact
- Good for joints; combine with Option A or B for full waterproofing

**Test before first use:** Fill the reservoir and sub-trays with water and leave for 24 hours. Check for weeping. Re-coat if needed.

### 4. Assembly of split parts

Base front + rear halves join with:
- 6× M3×20mm bolts and M3 nuts through pre-printed holes
- PETG solvent weld (dichloromethane or MEK applied to seam with cotton swab; allow 10 min to bond) — optional for watertight seam
- Bead of RTV silicone on inner seam surface before bolting together

### 5. Heat-set inserts

Vehicle mounting points (4× M5 in base corners): use a soldering iron at 200°C to press-fit M5 threaded heat-set inserts into the pre-printed recesses.

### 6. Light-sealing

Apply 3mm closed-cell foam weather-strip to all ring section interfaces (top and bottom flanges) and around door perimeters. This prevents light leakage between levels, which would disrupt the blackout phase of adjacent trays.

---

## Print Order Recommendation

Print in this order to allow waterproofing and testing before completing the full enclosure:

1. **Reservoir + waste chamber** (base halves) → waterproof → fill test
2. **One tray ring** (4 quarter-parts) → assemble → fit test
3. **One growing tray + one sub-tray** → waterproof sub-tray → water test
4. **LED bracket** → test with LED panel
5. **Front door** → fit to ring
6. If prototype test passes: print remaining 2 rings, 2 growing trays, 2 sub-trays
7. **Top cap** last (after full electrical assembly is confirmed)

---

## Print Troubleshooting

| Problem | Cause | Solution |
|---------|-------|---------|
| PETG stringing | Too-high temp or too-low retraction | Reduce temp 5°C; increase retraction 0.5mm increments |
| Part warping | Bed too cold or draft | Increase bed temp to 85°C; enclose printer |
| Layer delamination | Fan speed too high | Reduce fan to 20% or off for first 10 layers |
| Leaking reservoir | Insufficient perimeters | Reprint with 5 walls; apply XTC-3D coat |
| Tray doesn't slide smoothly | Dimensional tolerance | Sand the slide rails lightly; PETG is slightly flexible and will break in |
| Door hinge too tight | FDM tolerance | Drill out hinge hole slightly with 3mm drill bit |
