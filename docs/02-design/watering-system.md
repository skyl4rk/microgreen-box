# Watering System Design

**Phase:** 02 Design
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Summary

Water is delivered via a 12V peristaltic pump drawing from a sealed 2-liter reservoir at the base of the unit. The pump runs twice daily, delivering approximately 25 mL per tray per event via individual top-drip emitters. Excess water drains through the growing tray into the sealed sub-tray, and overflows to a sealed waste chamber. There are no open water surfaces — the system is fully sealed and vehicle-safe.

---

## Water System Requirements

| Requirement | Value | Source |
|-------------|-------|--------|
| Water containment | Fully sealed — no open surfaces | FR-006, claude.md (vehicle) |
| Daily water volume | ~50–150 mL total (all trays) | production-targets.md (USDA data) |
| Reservoir capacity | **2 L minimum** (targets 7+ days unattended) | NFR-001 |
| Low-water alert | Visual LED indicator | FR-009 |
| Power supply | 12V DC | FR-003 |
| Vehicle stability | Sealed reservoir; all fittings sealed or valved | FR-006 |
| Noise | Pump ≤ 50 dB at 1m | NFR-004 |

---

## Water Delivery Architecture

```
[2L Sealed Reservoir]
         │
   [Peristaltic Pump — 12V]
         │
   [4-way silicone manifold]
    /     │     \
[Tray A] [Tray B] [Tray C]
(drip)   (drip)   (drip)
    ↓        ↓        ↓
[Sub-tray A] [Sub-tray B] [Sub-tray C]
(sealed)     (sealed)     (sealed)
    ↓           ↓           ↓
[Overflow tubing to Waste Chamber]
```

The pump runs for a timed duration; no flow-rate sensors are needed. Timing is calibrated during setup to deliver the correct volume. All tubing runs inside the enclosure.

---

## Watering Method: Top-Drip

**Selected method:** Top-drip from above, through coir, into sealed sub-tray.

| Method | Suitability for vehicle | Notes |
|--------|------------------------|-------|
| Top-drip | ★★★★★ | Enclosed drip path; no standing water at surface |
| Bottom flood/drain | ★★☆☆☆ | Open water in sub-tray sloshes in vehicle |
| Misting / fogging | ★★★☆☆ | Harder to contain; more complex plumbing |
| Wicking from below | ★★★★☆ | Passive, no pump needed, but harder to control delivery precisely |

**Rationale:** Top-drip is the most vehicle-compatible active watering method. Water exits the drip emitter into the coir, which absorbs it. No standing water remains at the coir surface. Sub-trays catch drain-through water in a sealed chamber. If the vehicle moves, water stays in sealed sub-trays and waste chamber — no spill risk.

---

## Pump Selection

**Selected: 12V DC Peristaltic Pump**

| Parameter | Value |
|-----------|-------|
| Type | Peristaltic (roller type) |
| Voltage | 12V DC |
| Flow rate | 40–100 mL/min (adjustable by tubing ID and motor speed) |
| Power consumption | 3–5W during operation |
| Tubing ID | 4–6mm silicone (food-grade) |
| Dry-run safe | Yes — peristaltic pumps can run dry without damage |
| Run duration per watering event | ~20–40 seconds (to deliver 25 mL per tray; 75 mL total at 3 trays) |
| Noise level | ~40–50 dB at 30cm; quiet during brief cycles |
| Mounting | Any orientation (peristaltic pumps work inverted) — important for vehicle |
| Cost | $8–18 USD (AliExpress/Amazon) |
| Example parts | Kamoer F01A, generic 12V peristaltic pump, widely available |

**Why peristaltic over submersible:**
- No priming needed — self-priming
- Works in any orientation (critical for vehicle tilting)
- Food-safe silicone tubing is the only water-contact surface
- No risk of running reservoir dry and burning out motor
- Precise timing = precise volume delivery

---

## Reservoir Design

| Parameter | Value |
|-----------|-------|
| Capacity | **2.0 L** |
| Material | PETG (3D-printed) or food-grade HDPE container |
| Form | Rectangular, fits in enclosure base: ~200×150×70mm |
| Fill port | Top-access screw cap (O-ring sealed) |
| Outlet fitting | Ø6mm barbed fitting, silicone sealed, at base of reservoir |
| Water level sensor port | Ø10mm port at side, for sensor probe or sight glass |
| Vent | 0.5mm pin hole in cap + hydrophobic PTFE vent membrane (prevents pressure lock, excludes water) |
| Vehicle stability | Secured in enclosure base with retaining brackets; sealed cap |

### Reservoir Autonomy

```
Daily water use: ~150 mL/day (3 trays × 2 events × 25 mL)
Reservoir capacity: 2,000 mL
Autonomy: 2,000 / 150 = ~13.3 days
```

**A 2L reservoir provides >13 days of autonomous operation** — well exceeding the 7-day NFR target. In practice, some water evaporates through the growing medium, so real-world autonomy is approximately **10–14 days**.

---

## Watering Schedule

| Parameter | Value | Notes |
|-----------|-------|-------|
| Events per day | **2** | Morning and evening |
| Default times | 07:00 and 19:00 | Configurable in firmware |
| Duration per event | 20–40 sec (calibrate at setup) | Delivers ~25 mL per tray |
| Volume per event (3 trays) | ~75 mL | Pump runs once; manifold splits to 3 trays |
| Germination adjustment | No change needed | Coir absorbs same amount; blackout only affects light |
| Harvest day adjustment | Withhold last watering before harvest | Dry greens are easier to cut and store; reduces mold risk |

### Calibration Procedure

At initial setup, calibrate pump duration to deliver 25 mL per tray:
1. Disconnect manifold; run pump into measuring cup for 30 seconds
2. Measure volume; calculate mL/second
3. Set pump_duration = 25 mL × 3 trays / (mL/sec flow rate)
4. Record in firmware configuration

Recalibrate if tubing or pump is replaced.

---

## Water Distribution Manifold

| Parameter | Value |
|-----------|-------|
| Type | 1-to-3 splitter (Y + T fittings, or 3D-printed manifold block) |
| Tubing | 4mm ID × 6mm OD food-grade silicone |
| Drip emitters | 1 emitter per tray; Ø2mm drip hole or gravity emitter |
| Emitter flow (gravity at 25cm head) | ~2–5 mL/min — pump creates positive pressure; flow rate controlled by pump |
| Tubing length | ~50 cm per run (top tray) to ~10 cm (bottom tray) |
| Routing | Internal to enclosure column; secured with printed cable clips |

**Vehicle note:** All tubing is firmly clipped to the interior wall of the enclosure. No loose tubes that can dislodge during motion.

---

## Drainage and Waste System

### Sub-Tray to Waste Path

Each sub-tray has an overflow port at 25mm from the base (25×25cm = 625cm²; 25mm depth = 156mL capacity before overflow). Under normal operation, the sub-tray retains 5–15mm of water which wicks back up into the coir — no overflow expected unless the drip emitter is blocked or over-configured. Overflow fitting ensures sub-tray never exceeds 25mm.

### Waste Chamber

| Parameter | Value |
|-----------|-------|
| Location | Adjacent to main reservoir in the base |
| Capacity | 500 mL |
| Material | PETG (3D-printed) |
| Drain interval | User empties as needed; expected <50 mL/week under normal operation |
| Access | Sealed cap for pouring out; or barbed drain fitting for tubing |

---

## Water Level Sensor

| Parameter | Value |
|-----------|-------|
| Type | Float switch (simple, reliable) OR capacitive liquid level sensor (no moving parts, preferred) |
| Mount | On the side wall of the 2L reservoir |
| Trigger level | Activates at ~200 mL remaining (10% capacity = ~1 day reserve) |
| Output | Digital signal to ESP32 GPIO |
| Alert | Red/yellow LED on device; optional WiFi push notification |
| Cost | $1–5 (float switch) or $3–8 (capacitive) |

**Preferred: capacitive or optical water level sensor** (no moving parts, vehicle-stable — float switches can give false readings under motion).

---

## Vehicle-Specific Design Features

| Feature | Design solution |
|---------|----------------|
| Reservoir tipping | Sealed cap + O-ring; no open fill port during operation |
| Tubing dislodgement | Barbed fittings + zip-tie clips; tubing runs inside column |
| Sub-tray spillage | Deep sub-tray walls (40mm); sealed overflow to waste chamber |
| Pump orientation | Peristaltic works in any orientation; mounted at base for low CG |
| Condensation | PETG interior; absorbed by coir; no drip paths to electronics |
| Electronics isolation | Electronics bay sealed from growing/water zones by PETG wall with gasket |

---

## Watering System BOM Estimate

| Item | Qty | Unit Cost | Total |
|------|-----|-----------|-------|
| 12V peristaltic pump | 1 | $8–18 | $8–18 |
| Silicone tubing 4mm ID, 6mm OD, 2m | 1 | $3–6 | $3–6 |
| 3-way manifold fitting (or 3D-printed) | 1 | $1–3 | $1–3 |
| Drip emitters (2mm Ø) | 3 | $0.50 | $1.50 |
| Barbed fittings (Ø6mm) | 5 | $0.50 | $2.50 |
| Capacitive water level sensor | 1 | $3–8 | $3–8 |
| PETG filament (reservoir + waste chamber) | ~400g | $0.025/g | $10 |
| O-ring kit (seals) | 1 | $3–5 | $3–5 |
| **Watering system total** | | | **~$32–54** |
