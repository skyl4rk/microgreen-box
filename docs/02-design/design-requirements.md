# Design Requirements

**Phase:** 02 Design
**Status:** Complete
**Last Updated:** 2026-02-17

---

## Summary

This document translates all Phase 01 research findings and the claude.md design goals into specific, measurable engineering requirements. All subsystem designs must satisfy these requirements. Any proposed design change that conflicts with a requirement listed here must be flagged and resolved in PROJECT_DECISIONS.md before proceeding.

---

## Source Constraints (from claude.md)

The following constraints are non-negotiable design goals from the project brief:

| Constraint | Value |
|-----------|-------|
| Power supply | 12V or 5V DC from solar panel / battery system |
| Operating environment | Must function in a moving vehicle |
| Cost | Low cost; 3D-printed structure + low-cost supplier parts |
| Structure | All structural parts 3D printable (PETG preferred) |
| Inputs | Minimal: broccoli seed, water, coir |
| Interaction | Minimal human interaction; ideally only at harvest and seeding |
| Scalability | Easily scalable for multiple persons |
| Output | Daily dose in an easily usable form |
| Autonomy | 7+ days unattended operation (reservoir capacity) |

---

## Functional Requirements

| ID | Requirement | Value | Source | Priority |
|----|-------------|-------|--------|----------|
| FR-001 | Device shall produce fresh broccoli microgreens at the daily target rate | **30 g/day (primary), 60 g/day (max)** | DECISION-002 | Must |
| FR-002 | Device shall support a staggered 3-tray rotation for continuous harvest | **3 trays, one harvested every ~3 days** | DECISION-005 | Must |
| FR-003 | Device shall operate on 12V DC primary power | 12V nominal (±10%) | claude.md | Must |
| FR-004 | Device shall provide automated lighting on a configurable schedule | **14h on / 10h off** default; 0h during germination phase | FINDING-009, claude.md | Must |
| FR-005 | Device shall provide automated watering on a configurable schedule | **2× per day, ~25 mL per tray per event** | Broccoli microgreen literature | Must |
| FR-006 | Device shall contain all water in sealed reservoirs and sealed sub-trays | No open water surfaces; sealed fittings | claude.md (vehicle use) | Must |
| FR-007 | Device shall deliver harvested greens in a fresh, cut-ready state | No processing; user harvests by cutting | DECISION-003, DECISION-004 | Must |
| FR-008 | Device shall operate the germination phase without light | Software-controlled per-tray light inhibit for days 0–2 | Broccoli grow protocol | Must |
| FR-009 | Device shall alert the user when the water reservoir is low | Low-water indicator (LED or buzzer) | — | Must |
| FR-010 | Device shall alert the user when a tray is ready to harvest | Day-count indicator (LED or display) | — | Should |
| FR-011 | Device shall be scalable by stacking additional tray modules | Modular vertical design; each module adds one tray level | claude.md | Should |
| FR-012 | Device shall use coir as growing medium (not soil/compost) | See DECISION-007; vehicle-compatible | claude.md, DECISION-007 | Must |

---

## Non-Functional Requirements

| ID | Requirement | Value | Rationale | Priority |
|----|-------------|-------|-----------|----------|
| NFR-001 | Autonomous operation between user interactions | **≥7 days** (water reservoir, seed pre-loaded) | Minimal interaction goal | Must |
| NFR-002 | Maximum enclosure footprint | **≤35 × 35 cm** | Kitchen/vehicle counter space | Must |
| NFR-003 | Maximum enclosure height (3-tray primary) | **≤90 cm** | Practical for vehicle/countertop | Should |
| NFR-004 | Silent operation | Pump noise ≤ 50 dB at 1m during water cycle | Vehicle and home use | Should |
| NFR-005 | Total BOM cost (electronics + consumables, excluding solar) | **≤ USD $150** | Low-cost design goal | Must |
| NFR-006 | Structural parts 3D-printable in PETG | All enclosure and tray parts print on standard FDM printer (200×200 mm bed minimum) | claude.md | Must |
| NFR-007 | Food-safe material contact | Growing trays, sub-trays, and water paths use PETG or food-safe ABS; no PLA near water | Food safety | Must |
| NFR-008 | Stable under vehicle motion | No tipping, no spill; center of gravity ≤50% of base width | claude.md | Must |
| NFR-009 | PPFD at tray surface | **80–120 µmol/m²/s** | FINDING-009: balanced nutrient profile | Must |
| NFR-010 | Growing medium mineral quality | Coir + optional dilute liquid mineral supplement in water (CalMag or equivalent) | DECISION-007 | Should |

---

## Power Budget

| Load | Peak Power | Avg Power (daily profile) | Notes |
|------|------------|--------------------------|-------|
| LED panel (per tray) | 3W | 1.75W (14h/24h) | 3 trays = 9W peak, 5.25W avg |
| Peristaltic pump | 5W | 0.035W (6 min/day) | 2 events/day × 3 trays |
| ESP32 MCU | 0.3W | 0.25W | Light sleep between events |
| RTC module | 0.01W | 0.01W | DS3231 or similar |
| Water level sensor | 0.1W | 0.05W | Periodic polling |
| Status LEDs | 0.1W | 0.05W | 3mm indicator LEDs |
| **Total** | **~14.5W peak** | **~5.6W avg** | |

**Daily energy: 5.6W × 24h = ~134 Wh/day**
**Average current at 12V: 134 / (12 × 24) = 0.47 A**
**Peak current at 12V: 14.5 / 12 = 1.2 A**

---

## Power Supply Requirements

| Mode | Specification |
|------|--------------|
| Primary input | 12V DC, ≥2A (24W) continuous |
| Peak demand | 12V DC, ≥2A (14.5W — within 2A with margin) |
| Solar (off-grid) | 40W panel minimum; 50W recommended |
| Battery (off-grid) | 20Ah LiFePO4 at 12V (= ~192 Wh usable at 80% DoD) |
| MPPT controller | 10A, 12V/24V auto |
| Autonomy (full battery, no solar) | ~34 hours (192Wh / 5.6W avg) |
| Autonomy (40W solar, 4 sun hours) | Indefinite — 40×4×0.85=136 Wh/day > 134 Wh/day |
| Mains alternative | 12V/2A DC wall adapter (≈$10) |

---

## Interface Requirements

| Interface | Specification |
|-----------|--------------|
| Power input | 5.5/2.1mm barrel jack, 12V DC |
| Solar input | Via MPPT controller (external) |
| User indicators | 4× 3mm LEDs: Power, Water Low, Tray A ready, Tray B/C ready |
| Optional display | 0.96" OLED I2C (addressable via ESP32) |
| Connectivity | WiFi (ESP32 built-in); not required for operation |
| Water fill port | Top-access sealed cap on reservoir |
| Harvest access | Front-opening door or top-slide tray extraction |
| Seed/coir loading | Tray removal for manual loading |

---

## Constraints Summary

| ID | Constraint | Value |
|----|------------|-------|
| C-001 | Footprint | ≤35×35 cm |
| C-002 | Average power draw | ≤10W (target 5.6W) |
| C-003 | Peak power draw | ≤15W |
| C-004 | Primary voltage | 12V DC |
| C-005 | BOM cost (excl. solar) | ≤$150 USD |
| C-006 | Growing medium | Coir only (vehicle safe, see DECISION-007) |
| C-007 | Water containment | Fully sealed — no open water surfaces |
| C-008 | Material (food contact) | PETG or food-safe equivalent |
| C-009 | 3D printability | Max part size ≤ 200×200×200 mm |
| C-010 | Scalability | Adding one tray module must not require redesign of base |

---

## Resolved Open Questions

| Q-ID | Question | Resolution |
|------|----------|------------|
| Q-002 | Blackout / germination duration | Days 0–2 (48h) LED off per tray; controlled by MCU day counter |
| Q-006 | Seeding density | 12–15 g seed per 625 cm² tray; 0.019–0.024 g/cm² |
| Q-007 | Water recirculation | Drain-to-waste within sealed enclosure (waste sub-reservoir); no recirculation for simplicity |

## Remaining Open Questions

| Q-ID | Question | Priority |
|------|----------|----------|
| Q-001 | Actual yield of 25×25cm tray with coir under 100 µmol/m²/s | High — validate by prototype |
| Q-003 | Automated harvest notification vs. simple timer LED | Low |
| Q-004 | Fresh shelf life with dry refrigerated storage | Medium |
| Q-005 | @continuousharvest5822 YouTube channel review | Medium |
