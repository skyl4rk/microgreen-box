# Growing System Design

**Phase:** 02 Design
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Summary

The growing system consists of 3 identical tray levels in a vertical column. Each level holds a 25×25 cm growing tray filled with coir growing medium and broccoli seeds, sitting above a sealed sub-tray that serves as a water retention and drainage chamber. Trays are seeded on a staggered 3-day interval, providing a harvest every ~3 days at approximately 90–130 g per event. This yields ~30–43 g/day, meeting the primary 30 g/day target.

---

## Growing Medium: Coir

**Selected medium:** Compressed coconut coir (available as pucks or bricks)

### Why Coir (Amendment to DECISION-006)

Original DECISION-006 specified compost/soil for 73% higher mineral content. However, **claude.md specifies coir as a required input** and mandates vehicle-compatible operation. Compost/soil is not suitable for a vehicle: it is heavy, prone to spillage during motion, and significantly messier for user handling. See DECISION-007 in PROJECT_DECISIONS.md for the full decision record.

**Resolution:** Coir growing medium with an optional dilute liquid mineral supplement (CalMag or equivalent) added to the watering solution. This partially recovers the mineral density difference while maintaining vehicle compatibility.

### Coir Properties

| Property | Value |
|----------|-------|
| Form | Compressed puck or brick (expands 6–8× when wetted) |
| pH | 5.5–6.8 (ideal for broccoli: 6.0–7.0) |
| Texture | Fibrous; excellent water retention and air pockets |
| Weight dry | ~8 g per 25×25 cm tray (from 50 g coir puck compressed) |
| Weight wet | ~200–250 g per tray at field capacity |
| Mineral content | Low (negligible inherent minerals vs. compost) |
| Vehicle stability | Excellent — fibrous mat, does not slosh or spill |
| Reusability | Single use per grow cycle; compostable after use |
| Source | Compressed coir pucks: widely available, $5–15 for 10–20 pucks |

### Mineral Supplement Protocol

To partially compensate for coir's low inherent mineral content:
- Add CalMag liquid supplement at **0.5 mL per liter of water** (quarter-strength dilution)
- Apply from day 3 onward (not during germination to avoid seed burn)
- Optional — device produces nutritionally valuable microgreens even without supplement

---

## Tray Design

### Growing Tray (inner dimensions)

| Dimension | Value |
|-----------|-------|
| Inside width | 250 mm |
| Inside depth | 250 mm |
| Inside height | 50 mm |
| Wall thickness | 3 mm |
| Outer dimensions | 256 × 256 × 53 mm |
| Drain holes | 4× Ø8mm holes in base (covered by coir mat) |
| Material | PETG (food-safe, moisture resistant) |
| Print time (estimate) | ~4–6 hours |

Drain holes allow excess water from top-drip to pass through into the sub-tray below. The coir mat naturally filters the water; roots do not block the holes at the cotyledon stage.

### Sub-Tray (water retention / sealed drainage)

| Dimension | Value |
|-----------|-------|
| Inside width | 256 mm (matches growing tray outer width) |
| Inside depth | 256 mm |
| Inside height | 40 mm |
| Drain outlet | Ø8mm fitting on one side wall, connects to waste chamber tubing |
| Overflow threshold | 25 mm (sub-tray holds up to 25mm = ~163 mL before overflowing to waste) |
| Material | PETG |
| Lid/seal | Growing tray sits on top of sub-tray with 3mm lip for stability |

The sub-tray catches all drain water from the growing tray. Passive overflow fitting drains to the waste chamber at the base when sub-tray fills beyond 25mm. This creates a stable, sealed water path with no open surfaces — critical for vehicle use.

---

## Seeding Specifications

| Parameter | Value | Notes |
|-----------|-------|-------|
| Seed variety | Broccoli (*Brassica oleracea*) — microgreen grade | De Cicco, Calabrese, or similar dense-seeding cultivar |
| Seed quantity per tray | **12–15 g** per 625 cm² tray | ~0.19–0.24 g/cm² |
| Pre-soak | **4–8 hours in water** before planting | Improves germination rate and uniformity |
| Seeding method | Scatter evenly over moistened coir; press lightly | No burial needed; broccoli germinates at surface |
| Post-seed | Cover with blackout lid (or simply disable tray LED); keep moist | Germination in dark, humid environment |
| Germination rate | 85–95% expected | Broccoli seeds germinate reliably |
| Coir prep | Expand coir puck in 300 mL warm water; squeeze to ~field capacity; fill tray | Coir should be damp but not dripping |

---

## Grow Cycle Stages

| Stage | Days | Light | Watering | Notes |
|-------|------|-------|----------|-------|
| Germination | Days 1–2 | **OFF** (blackout) | Once on day 1 (~25mL mist); check moisture on day 2 | Seeds need dark, humid, ~20–24°C |
| Early growth | Days 3–5 | **ON** (14h/day) | 2× daily, 25 mL per event | First true stem extension; etiolation phase ends |
| Active growth | Days 6–8 | **ON** (14h/day) | 2× daily, 25–30 mL per event | Cotyledons open; green color develops |
| Harvest window | Days 8–10 | **ON** | Normal watering | Cut when cotyledons fully open and stem is 3–5 cm tall |
| Maximum hold | Day 11 | Turn off | Reduce watering | Do not leave past day 11; quality and GRN decline |

**Blackout on days 1–2:** The MCU tracks the seeding date for each tray and suppresses the LED for that tray level during the first 2 days. No physical blackout cover is required — software-controlled.

---

## Rotation Schedule

Three trays (A, B, C) are staggered with a 3-day seeding interval:

```
Day  Tray A       Tray B       Tray C
───  ──────────   ──────────   ──────────
 1   Seed day 1   —            —
 2   Germ (dark)  —            —
 3   Light on     —            —
 4   Growing      Seed day 1   —
 5   Growing      Germ (dark)  —
 6   Growing      Light on     —
 7   Harvest      Growing      Seed day 1
     window
 8   ─HARVEST─    Growing      Germ (dark)
     (reseed A')
 9   Germ (dark)  Harvest win  Light on
10   Light on     ─HARVEST─    Growing
                  (reseed B')
11   Growing      Germ (dark)  Harvest win
12   Growing      Light on     ─HARVEST─
                               (reseed C')
13   ─HARVEST─    Growing      Germ (dark)
     (reseed A'')
...  (cycle repeats every 9–10 days per tray)
```

**Steady state (after day 8):**
- A tray is harvested approximately every **3 days**
- Each harvest yields **~90–130 g** fresh microgreens
- 90 g / 3 days = **30 g/day** (conservative)
- 130 g / 3 days = **43 g/day** (typical)

---

## Harvest Procedure (User Workflow)

1. When harvest LED illuminates (day 8–10 for that tray):
2. Open the enclosure door / slide out the tray level
3. Using scissors or a sharp knife, cut stems at the coir line
4. Place cut greens in a container
5. **Refrigerate 30g immediately** (next 2–3 days)
6. **Freeze remainder** in pre-weighed 30g portions in sealed zip bags
   - Label with date
   - Place flat in freezer
   - Use within 3–6 months; blend from frozen directly into smoothie
7. Remove spent coir from tray (compost or discard)
8. Rinse and dry tray and sub-tray
9. Prep fresh coir, pre-soak seeds, reseed
10. Reset the MCU tray counter (press button or automatic after re-insertion)
11. Return tray to enclosure — cycle restarts

**Total user time per harvest event: ~5–10 minutes**
**User interactions per week: ~2 (harvest once, top up water reservoir)**

---

## Expected Yield Summary

| Condition | Yield per Tray | Daily Average (3-tray, 3-day harvest) |
|-----------|---------------|---------------------------------------|
| Conservative (coir, basic light) | 80 g | 27 g/day |
| Expected (coir, 100 µmol/m²/s) | 110 g | 37 g/day |
| Optimistic (dense seed, CalMag) | 130 g | 43 g/day |

**All scenarios meet or approach the 30 g/day primary target. The target is conservative; actual yield is expected to exceed it after the user optimizes seeding density.**

---

## Seed Storage

- Store seed in a sealed, opaque container
- Location: cool, dry, dark — seed storage shelf inside top cap of enclosure
- Storage capacity: 100 g (≈6–7 tray cycles); replenish monthly
- Shelf life: 2–3 years in dry storage
- Source: bulk broccoli microgreen seed, ~$15–30/kg

---

## Growing System BOM Estimate

| Item | Qty | Unit Cost | Total |
|------|-----|-----------|-------|
| PETG filament (trays + sub-trays) | ~800g | $0.025/g | $20 |
| Coir pucks (50g each, ~1/tray) | 24/year | $0.50–1.00 | $12–24/yr |
| Broccoli microgreen seed | 200g/yr | $5–10 | $10–20/yr |
| CalMag liquid supplement (optional) | 1 bottle/yr | $10 | $10/yr |
| **Growing system hardware total** | | | **~$20 one-time + $32–54/yr consumables** |
