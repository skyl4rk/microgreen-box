# Production Targets

**Phase:** 01 Research
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Summary

The device should produce a minimum of **30 g/day fresh broccoli microgreens**, with a design target of **60 g/day** for flexibility and to accommodate therapeutic doses. At 30 g/day and a 10-day grow cycle, this requires a **staggered system of 3 trays** (one seeded every ~3 days), each approximately 25×25 cm (10"×10") or equivalent area. At 60 g/day, 6 trays or larger tray area is required. The system is designed around a **10-day grow cycle with daily harvest capability**.

---

## Inputs from Prior Research

| Input | Value | Source |
|-------|-------|--------|
| Daily target (primary) | 30 g fresh weight | [daily-requirements.md](daily-requirements.md) |
| Daily target (therapeutic) | 60–100 g fresh weight | [daily-requirements.md](daily-requirements.md) |
| SFN potential per gram | ~6.4–7.2 µmol/g | [nutritional-profile.md](nutritional-profile.md), PMC10606698 |
| Preferred consumption form | Fresh in smoothie | [consumption-methods.md](consumption-methods.md) |
| Preferred preservation | Fresh refrigeration (primary) | [preservation-methods.md](preservation-methods.md) |
| Grow cycle | 7–10 days | Literature consensus |

---

## Broccoli Microgreen Yield Data

### Per Standard 10"×20" Tray (1,290 cm²)

| Source / Condition | Fresh Yield |
|--------------------|-------------|
| USDA PMC study (5"×5" = 645 cm²), × 2 | ~160–195 g |
| Commercial growers (optimized) | 200–325 g |
| Home growers (typical) | 140–200 g |
| Seed input | ~25 g per 10×20 tray |
| Grow time | 7–10 days |

**Design yield used: 150 g per 10×20 tray in 10 days (conservative home-scale estimate)**

This is deliberately conservative to account for:
- Non-commercial growing conditions
- Learning curve for seed density and watering
- Not all trays performing equally

Actual yield may be 25–50% higher with optimization.

---

## Daily Fresh Weight Targets

| Mode | Daily Target | SFN Equivalent | Use Case |
|------|-------------|----------------|----------|
| Minimum (clinical baseline) | 16 g/day | ~100 µmol/day | Clinically validated single serving |
| **Primary target (recommended)** | **30 g/day** | **~192–216 µmol/day** | **Daily health maintenance** |
| Moderate therapeutic | 60 g/day | ~380–430 µmol/day | Cancer prevention, metabolic support |
| Maximum therapeutic | 100 g/day | ~640–720 µmol/day | Practitioner-supervised treatment |

**Device design target: 30 g/day (primary), 60 g/day (design maximum)**

---

## Tray Count Calculation

### For 30 g/day (Primary Target)

```
Daily need:           30 g/day
Yield per tray:       150 g / 10 days = 15 g/day/tray
Trays required:       30 ÷ 15 = 2 trays
```

**But** a continuous harvest system uses staggered trays, not simultaneous harvest. Each tray is seeded on a different day and harvested once at its peak (day 7–10). To extract 30 g/day:

Option A: **3 trays, harvest one-third of each tray every day**
- Trays are at different stages: Day 1, Day 4, Day 7
- When Day 7 tray is consumed, seed a new tray
- Each tray yields 150g over its harvest window (~5 days), averaging 30 g/day

Option B: **2 larger trays, harvest half a tray every 5 days**
- Batch-harvest 150g every 5 days; store refrigerated for up to 5–7 days
- Simpler operation; slightly less fresh on later days

**Recommended: Option B — 2 large trays on a 5-day stagger** for simplicity. Harvest one full tray every 5 days (150g), consume 30g/day over the next 5 days from refrigerator. Seed a new tray on harvest day.

### For 60 g/day (Therapeutic / Design Maximum)

```
Daily need:           60 g/day
Yield per tray:       15 g/day/tray
Trays required:       60 ÷ 15 = 4 trays
```

4 trays on a staggered 2.5-day seeding interval, or 2 larger trays (20"×20" equivalent) on a 5-day stagger.

---

## Tray Sizing Options

### Option A: Standard 10"×20" (25×51 cm) Trays
- Widely available, standard growing supply
- Yield: ~150 g per tray
- 30 g/day requires: 2 trays in rotation (stagger sowing every 5 days)
- 60 g/day requires: 4 trays in rotation
- Stack height with lighting clearance: ~25–30 cm per tray level

### Option B: Custom Square Trays (25×25 cm)
- Easier to stack in a cube enclosure
- Yield: ~75 g per tray (½ of 10×20)
- 30 g/day requires: 4 trays in rotation
- 60 g/day requires: 8 trays in rotation
- More modular; easier to handle

### Option C: Shallow Custom Trays (30×30 cm)
- 900 cm² ≈ 70% of a 10×20 tray
- Yield: ~105 g per tray
- 30 g/day requires: 3 trays in rotation
- Nice balance of size and yield

**Recommended tray for design: 25×25 cm (10"×10") custom trays in a 3- or 4-tray rotation**. This gives a compact, roughly cubic footprint, is stackable, and is printable/fabricable at home.

---

## Device Footprint Estimate

### 3-Tray Stack (30 g/day target, 25×25 cm trays)

| Dimension | Value |
|-----------|-------|
| Tray width | 25 cm |
| Tray depth | 25 cm |
| Tray stack height (3 × ~25 cm clearance) | ~75 cm |
| Total enclosure (W×D×H) | ~30 × 30 × 80 cm |
| Footprint | ~900 cm² (0.09 m²) |

This is approximately the size of a tall kitchen appliance (countertop convection oven scale).

### 4-Tray Stack (60 g/day target, 25×25 cm trays)

| Dimension | Value |
|-----------|-------|
| Total enclosure (W×D×H) | ~30 × 30 × 105 cm |
| Footprint | ~900 cm² (0.09 m²) |

This is a full countertop column or free-standing unit.

---

## Seed Consumption

| Daily target | Trays per month | Seed per tray | Monthly seed use | Annual seed use |
|-------------|----------------|--------------|-----------------|-----------------|
| 30 g/day | ~6 trays/month | 15 g seed | ~90 g/month | ~1.1 kg/year |
| 60 g/day | ~12 trays/month | 15 g seed | ~180 g/month | ~2.2 kg/year |

Broccoli microgreen seed is widely available at ~$15–30/kg in bulk. Annual seed cost: **$17–$66/year** depending on dose and supplier.

---

## Water Consumption

From USDA study (PMC5362588): 65–90 mL per 5"×5" tray over a 7-day cycle.
Scaled to 25×25 cm tray: ~260–360 mL per tray per 10-day cycle.
At 2–4 trays in rotation: **~50–150 mL/day water use total**.

This is negligible — less than a small glass of water per day. A modest on-device reservoir (1–2 liters) would last 7–20 days without refilling.

---

## Summary of Targets for Design Phase

| Parameter | Primary Target | Max Design Target |
|-----------|---------------|-------------------|
| Daily fresh yield | 30 g | 60 g |
| Number of trays | 2–3 (25×25 cm) | 4 (25×25 cm) |
| Tray area each | 625 cm² | 625 cm² |
| Grow cycle | 10 days | 10 days |
| Sowing interval | Every 5 days (primary target) | Every 2.5 days |
| Reservoir capacity | 1–2 L | 2 L |
| Enclosure footprint | ~30×30 cm | ~30×30 cm |
| Enclosure height | ~80 cm (3 trays) | ~105 cm (4 trays) |
| Seed use | ~90 g/month | ~180 g/month |
| Water use | ~50–100 mL/day | ~100–150 mL/day |

---

## Sources

- [Sulforaphane Bioavailability in Fresh Broccoli Microgreens (PMC10606698)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10606698/)
- [Broccoli Microgreens: A Mineral-Rich Crop (PMC5362588)](https://pmc.ncbi.nlm.nih.gov/articles/PMC5362588/)
- [Microgreens Yield Cheatsheet — MicrogreenManager](https://microgreenmanager.com/blog/microgreens-yield-cheatsheet)
- [What Do My Microgreens Yield Per Tray? — Home Microgreens](https://homemicrogreens.com/microgreens-yield-per-tray/)
- [Ultimate Microgreen Cheat Sheet — Bootstrap Farmer](https://www.bootstrapfarmer.com/blogs/microgreens/the-ultimate-microgreen-cheat-sheet)
- [Micro Greens Yield Trial 2017 — Johnny's Seeds (PDF)](https://www.johnnyseeds.com/on/demandware.static/-/Library-Sites-JSSSharedLibrary/default/dw320cb0ff/assets/information/micro-greens-yield-trial-results-tech-sheet.pdf)
- [How to Grow a Continuous Supply of Microgreens — EasyGroHydro](https://easygrohydro.wordpress.com/2020/03/17/how-to-grow-a-continuous-supply-microgreens/)
