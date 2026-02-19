# Preservation System

**Phase:** 02 Design
**Status:** Complete — No On-Device Preservation Hardware Required
**Last Updated:** 2026-02-17

---

## Summary

The device has no on-board preservation subsystem. Per DECISION-004, the device outputs fresh-cut microgreens. Post-harvest preservation is handled by the user using a standard kitchen refrigerator (primary) and standard kitchen freezer (secondary, and surprisingly superior for sulforaphane bioavailability). This document defines the user workflow and design features that support the preservation process.

---

## Why No On-Device Preservation

From DECISION-004 (established in Phase 01 research):

1. **Fresh refrigeration** preserves 100% of myrosinase activity and sulforaphane bioavailability — no device needed beyond the user's refrigerator.

2. **Raw home freezing** (FINDING-011) actually *increases* sulforaphane yield by up to 3.1× vs. unfrozen — and requires only the user's standard kitchen freezer. The device does not need to replicate this.

3. The two remaining preservation methods evaluated (freeze-drying, low-temp dehydration) are either too expensive ($2,000–$5,000 for a home freeze-dryer) or add significant device complexity for modest gain when raw freezing is freely available and superior.

4. Adding a refrigeration or dehydration module would increase cost, power draw, enclosure size, and mechanical complexity — all contrary to the design goals.

**Conclusion: The preservation system is the user's refrigerator + freezer. The device's job is to produce and present fresh-cut greens efficiently.**

---

## Device Features That Support Preservation

While no preservation hardware is included, the device design incorporates several features to streamline the post-harvest workflow:

### 1. Harvest Ready Indicator

The ESP32 tracks the seeding day for each tray. On days 8–10, a harvest-ready LED illuminates for that tray level. This prevents over-maturation (which reduces GRN concentration) and ensures the user harvests at peak sulforaphane content.

### 2. Dry-Before-Harvest Protocol

The firmware suppresses the final watering event before the scheduled harvest window. Specifically, the watering event on the morning of day 8 (the first day of the harvest window) is withheld for the target tray. Dry microgreens:
- Store longer in the refrigerator (surface moisture promotes mold)
- Are easier to cut cleanly
- Freeze without clumping

This is implemented as a software flag; no hardware is required.

### 3. Portion Marking System

The enclosure top cap includes a small compartment (30 mL volume) for storing:
- A permanent marker for dating freezer bags
- Small zip-lock bags (30g portions) for the freezer
- Optionally, a luggage scale label / reference card

This is a minor 3D-printed feature with no electronics.

---

## Post-Harvest User Workflow

### For Fresh Consumption (Days 1–3 after harvest)

1. Harvest the target tray when harvest LED illuminates
2. Cut greens at coir level with scissors
3. Place in airtight container lined with paper towel
4. Refrigerate immediately at 2–5°C
5. Consume within 5–7 days — blend into morning smoothie raw

### For Frozen Storage (Surplus from each harvest event)

1. Harvest tray (~90–130g)
2. Take 30–60g to refrigerator for immediate use
3. Remaining 60–100g: portion into 30g lots
4. Place each portion in a small zip-lock bag; press out air, seal
5. Label with date using permanent marker
6. Lay bags flat in freezer at −20°C for minimum 24 hours before use
7. Use within 3–6 months — blend directly from frozen (do NOT thaw)
8. Add to blender with fruit; blend immediately; drink within 20 minutes

**This protocol maximizes sulforaphane — the frozen-then-blended approach can yield up to 3× more sulforaphane than consuming fresh-unfrozen greens.**

---

## Shelf Life Reference Card

This card should be printed and placed inside the enclosure top cap for user reference:

```
┌────────────────────────────────────────────────────────┐
│          MICROGREEN STORAGE GUIDE                      │
│                                                        │
│  FRESH (refrigerator 2–5°C)                           │
│  └─ Shelf life: 5–7 days                              │
│  └─ Sulforaphane: MAXIMUM                             │
│  └─ Use: raw in smoothie or salad                     │
│                                                        │
│  FROZEN (−20°C, raw, unblanched)                      │
│  └─ Shelf life: 3–6 months                            │
│  └─ Sulforaphane: UP TO 3× MORE than fresh            │
│  └─ Use: blend directly from frozen — do NOT thaw     │
│                                                        │
│  NEVER: cook, blanch before freezing, or discard      │
│         thaw liquid                                    │
└────────────────────────────────────────────────────────┘
```

---

## Quantities at Each Harvest Event

| Scenario | Tray yield | To refrigerator | To freezer |
|----------|-----------|-----------------|------------|
| Conservative (80g/tray) | 80g | 30g (3 days) | 50g (50÷30 = 1.6 → 1 bag) |
| Expected (110g/tray) | 110g | 30g (3 days) | 80g (2–3 bags of 30g) |
| High yield (130g/tray) | 130g | 60g (5 days) | 70g (2 bags of 30g) |

At the expected yield of 110g per harvest every 3 days:
- **2–3 frozen 30g portions** are produced per harvest event
- After 4 cycles, the user has 8–12 frozen doses in reserve — a 24–36 day backup supply

---

## Design Boundary Statement

| System boundary | In scope | Out of scope |
|----------------|----------|-------------|
| Growing and harvesting | ✅ | — |
| Harvest-ready notification | ✅ | — |
| Dry-harvest protocol (last watering withheld) | ✅ | — |
| Portion bag storage compartment | ✅ | — |
| Refrigeration hardware | ❌ (user's fridge) | — |
| Freezer hardware | ❌ (user's freezer) | — |
| Freeze-drying | ❌ (out of scope) | — |
| Dehydration | ❌ (user's dehydrator, optional) | — |
