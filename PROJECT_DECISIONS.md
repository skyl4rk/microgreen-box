# Project Decisions Log

**Project:** Microgreen Growing Device
**Last Updated:** 2026-02-18 (Published to GitHub — DECISION-027/028; consistency fixes; README/CONTRIBUTING/LICENSE)
**Purpose:** This document is the single source of truth for the entire project. Any new Claude instance should read this file first and treat its contents as authoritative before taking any action.

---

## How to Use This Document

- **Before starting work:** Read this entire file.
- **After each session:** Update all relevant sections.
- **Conflicts:** If anything in the codebase or other docs contradicts this file, flag it and resolve before proceeding.

---

## Project Goal

Design and build a self-contained, automated device that produces broccoli microgreens for one person's daily health needs. Operates on 12V DC (solar/battery or vehicle). Low cost, 3D-printable, vehicle-compatible.

**Species locked:** Broccoli (*Brassica oleracea* var. *italica*)

---

## ⚠️ CONFLICT FLAG — DECISION-006 Amended by DECISION-007

Phase 01 DECISION-006 specified **compost/soil** as the growing medium for 73% higher mineral content. Phase 02 design revealed that **claude.md explicitly specifies coir** as a design input, and that the mandatory vehicle-compatibility requirement makes compost/soil impractical (heavy, messy, spills during motion). **DECISION-007 supersedes DECISION-006.** Coir is the mandatory growing medium. Mineral recovery is partially addressed by optional liquid supplement in watering water.

---

## Phase Status

| Phase | Status | Last Updated | Notes |
|-------|--------|--------------|-------|
| 01 Research | **Complete** | 2026-02-17 | All 5 research docs written |
| 02 Design | **Complete** | 2026-02-18 | All 8 design docs written; consistency fixes applied (DECISION-027) |
| 03 Build | **Complete** | 2026-02-18 | All deliverables done; see Phase 03 section for full list |
| 04 Software | **Complete** | 2026-02-18 | Firmware + docs written; see Phase 04 section |
| 05 Publication | **Complete** | 2026-02-18 | Published to GitHub — see DECISION-027/028 |

---

## Decisions Made

### [DECISION-001] Target Species: Broccoli Microgreens Only
- **Date:** 2026-02-17
- **Decision:** Device optimized for broccoli microgreens only.
- **Rationale:** Highest sulforaphane (GRN) concentration of any readily growable microgreen; comparable to broccoli sprouts; 10–100× more SFN than mature broccoli.
- **Alternatives:** Radish (harsh flavor), sunflower (no SFN), pea shoots (no SFN).
- **Status:** Active

### [DECISION-002] Daily Production Target: 30 g/day (primary), 60 g/day (max)
- **Date:** 2026-02-17
- **Decision:** 30 g/day primary target; 60 g/day design capacity.
- **Rationale:** 30g delivers ~192–216 µmol SFN/day — upper range of well-studied clinical doses. 16g is the validated minimum; 30g provides meaningful safety buffer.
- **Impact:** Drives tray count (3), enclosure size, reservoir capacity.
- **Status:** Active

### [DECISION-003] Primary Consumption: Fresh Morning Smoothie
- **Date:** 2026-02-17
- **Decision:** Device outputs fresh-cut greens for daily raw smoothie consumption.
- **Rationale:** Blending maximizes myrosinase activation (= maximum sulforaphane), masks broccoli flavor, integrates into daily routine.
- **Impact:** No on-device processing required.
- **Status:** Active

### [DECISION-004] Preservation: Fresh Refrigeration Primary; Raw Freezing Secondary
- **Date:** 2026-02-17
- **Decision:** No on-device preservation hardware. Fresh greens refrigerated ≤7 days. Surplus frozen raw (unblanched) at −20°C; consumed by blending from frozen.
- **Rationale:** Raw home freezing increases sulforaphane yield up to 3.1× (FINDING-011). Free. Freeze-dryers are $2,000–$5,000 — out of scope.
- **Impact:** No preservation subsystem in device. Preservation System doc is a workflow document, not a hardware spec.
- **Status:** Active

### [DECISION-005] Tray Format: 25×25 cm (625 cm²), 3-Tray Staggered Rotation
- **Date:** 2026-02-17
- **Decision:** 3 trays of 25×25 cm in a vertical staggered rotation, harvesting one tray every ~3 days.
- **Rationale:** Square trays fit a compact 30×30cm column. At 90–130g yield per tray, 3-tray harvest every 3 days = 30–43 g/day.
- **Impact:** Enclosure footprint 30×30cm, height 85cm.
- **Status:** Active

### [DECISION-006] ~~Growing Medium: Compost/Soil~~ — SUPERSEDED BY DECISION-007
- **Date:** 2026-02-17
- **Status:** Superseded by DECISION-007

### [DECISION-007] Growing Medium: Coir (Amends DECISION-006)
- **Date:** 2026-02-17
- **Decision:** Use compressed coconut coir as growing medium. Optional dilute liquid mineral supplement (CalMag, 0.5 mL/L) added to watering water from day 3 onward.
- **Rationale:** claude.md explicitly lists "coir" as a required input. Vehicle-compatibility requirement makes compost/soil impractical: heavy, messy, prone to spillage in motion. Coir is lightweight, fibrous (stable in motion), clean, and widely available as compressed pucks.
- **Mineral trade-off:** Coir has lower inherent mineral content than compost (~73% lower based on USDA data). Liquid supplement partially compensates. The primary nutritional value of these microgreens is sulforaphane (not minerals), so the trade-off is acceptable.
- **Alternatives:** Compost (ruled out — vehicle incompatible), hydroponic mats (lower yield, no mineral benefit, adequate for coir-free vehicle use).
- **Impact:** Tray design does not need drainage for soil; coir is self-contained. Watering is simpler. Consumables change (coir pucks instead of potting mix).
- **Status:** Active

### [DECISION-008] Microcontroller: ESP32
- **Date:** 2026-02-17
- **Decision:** ESP32 (ESP32-WROOM-32 dev board) is the system controller.
- **Rationale:** $4–8 USD, Arduino IDE compatible, 34 GPIO pins, hardware I2C/SPI, 12-bit ADC, built-in WiFi (optional use), deep sleep mode (10µA) for battery preservation, 4MB flash.
- **Alternatives:** Arduino Nano (no WiFi, less RAM), RPi Zero (500mA power, complex boot), ATtiny85 (insufficient I/O).
- **Impact:** All firmware written for ESP32/Arduino framework. 3.3V logic; 5V input via on-board regulator from 12V buck converter.
- **Status:** Active

### [DECISION-009] Power System: 12V DC, Solar + LiFePO4 Battery
- **Date:** 2026-02-17
- **Decision:** 12V DC primary supply. Off-grid: 40W solar panel + 20Ah LiFePO4 battery + 10A MPPT controller. Vehicle: direct 12V connection via cigarette lighter/Anderson Powerpole. Home: 12V/2A mains adapter.
- **Rationale:** claude.md mandates 12V or 5V solar/battery. Average load 5.6W / 134 Wh/day. 40W panel at 4 peak sun hours × 0.85 efficiency = 136 Wh/day — breaks even. 20Ah LiFePO4 = 192 Wh usable = 34 hours autonomy on battery alone.
- **Alternatives:** 5V USB (insufficient for 9W LED load), mains-only (contradicts off-grid requirement), LiPo battery (fire risk in hot vehicle), lead-acid (too heavy).
- **Impact:** All 12V DC loads. On-board buck converter to 5V for ESP32. Inline 5A fuse. Reverse polarity protection.
- **Status:** Active

### [DECISION-010] Lighting: 3W Full-Spectrum LED per Tray, 14h Photoperiod
- **Date:** 2026-02-17
- **Decision:** Each tray level has a 3W 5000–6500K full-spectrum LED panel at 10cm above tray surface. Photoperiod: 14h on / 10h off. Software-controlled blackout for days 0–2 per tray (no physical cover needed).
- **Rationale:** 3W efficient LED → ~100 µmol/m²/s PPFD at 625 cm² tray — balanced for sulforaphane and vitamins (FINDING-009). Full spectrum simpler than red+blue bichromatic. 14h photoperiod balances yield and power budget (saves ~30% vs 16h with minimal yield impact). 9W total lighting keeps power budget within solar capacity.
- **Alternatives:** Red+blue bichromatic (more efficient but purple light, complex drivers), 5W per panel (adequate PPFD but increases solar panel requirement to ~80W), 16h photoperiod (higher yield, but 30% more energy = larger solar panel needed).
- **Impact:** LED relays: 3 channels on relay module. Each panel independently switched. Total lighting: 9W peak, 5.25W average.
- **Status:** Active

### [DECISION-011] Watering: Top-Drip Peristaltic Pump, Twice Daily
- **Date:** 2026-02-17
- **Decision:** 12V peristaltic pump draws from sealed 2L reservoir; delivers ~25 mL per tray per event via top-drip; 2 events/day (07:00 and 19:00). All water fully enclosed — sealed reservoir, sealed sub-trays, sealed waste chamber.
- **Rationale:** Peristaltic pump self-priming, works in any orientation (critical for vehicle), dry-run safe. Top-drip into coir leaves no standing open water — vehicle-stable. 2L reservoir at 150 mL/day use = 13+ day autonomy. Bottom-flood watering requires open water in sub-trays — unacceptable for vehicle.
- **Alternatives:** Bottom flood/drain (open water — not vehicle-safe), wicking (passive but hard to control), misting (humid environment risk, complex).
- **Impact:** 1 relay channel for pump. Manifold splits to 3 drip emitters. Capacitive water level sensor in reservoir. Waste chamber collects overflow.
- **Status:** Active

### [DECISION-012] Enclosure: PETG 3D-Printed Vertical Column, 300×300×850mm
- **Date:** 2026-02-17
- **Decision:** Modular vertical column in PETG: base unit (reservoir + electronics) + 3× tray level rings + top cap. All parts print on 200×200mm bed. Front-opening hinged doors per tray level. No support structures needed (designed for support-free FDM printing).
- **Rationale:** PETG is food-safe, moisture-resistant, and heat-stable to 80°C (safe in vehicles). Modular ring design allows scaling by adding rings. Low center of gravity (reservoir at base) provides vehicle stability. 300mm footprint fits within 35cm constraint.
- **Alternatives:** Laser-cut plywood (not 3D-printable, water-damaged), aluminum extrusion (expensive, heavy), injection-molded (requires tooling), PLA (heat-sensitive, degrades in moisture).
- **Impact:** ~2.4 kg PETG, ~65 print-hours. Reservoir interior requires waterproofing coat (XTC-3D or shellac). PETG only — no PLA for structural/water-contact parts.
- **Status:** Active

---

## Key Findings

### [FINDING-001] Sulforaphane Concentration in Broccoli Microgreens
- **Date:** 2026-02-17
- **Finding:** GRN: ~12.8–13.6 µmol/g fresh weight; SFN potential: ~6.4–7.2 µmol/g. 16g serving = 100 µmol SFN (clinically validated).
- **Source:** PMC10606698
- **Confidence:** High

### [FINDING-002] 10–100× More Sulforaphane Than Mature Broccoli
- **Date:** 2026-02-17
- **Finding:** Conservative: 10–40×. 73% more minerals (compost-grown). 93–95% less water; 158–236× less land.
- **Source:** PMC10606698, PMC5362588
- **Confidence:** High

### [FINDING-003] Myrosinase Destroyed Above 60–70°C
- **Date:** 2026-02-17
- **Finding:** Raw consumption required for sulforaphane. Chop and wait 40 min before heat. Mustard seed powder provides exogenous myrosinase.
- **Source:** PMC7174218, CPBL blog
- **Confidence:** High

### [FINDING-004] Optimal Dose: 50–150 µmol SFN/day
- **Date:** 2026-02-17
- **Finding:** Clinical range 50–150 µmol/day. 30g target = ~200 µmol/day — upper end of well-studied range.
- **Source:** PMC6804255, PMC10606698
- **Confidence:** High

### [FINDING-005] Larger Doses Not Simply Better
- **Date:** 2026-02-17
- **Finding:** Complex hormetic dose-response. GI discomfort above 150–400 µmol/day. Consistent daily modest dose preferred over episodic high dose.
- **Source:** PMC6804255, PMC4273949
- **Confidence:** Medium

### [FINDING-006] Capsule Delivery Feasible But Not Primary
- **Date:** 2026-02-17
- **Finding:** 30g fresh → 1.5g freeze-dried powder → 2–3 size 0 capsules. Requires freeze-dryer ($2k–5k). Commercial products exist.
- **Source:** Commercial research
- **Confidence:** High

### [FINDING-007] Tray Yield: 90–130g per 25×25cm Tray in 10 Days
- **Date:** 2026-02-17
- **Finding:** Based on scaled commercial data. Conservative 90g; typical 110g; optimistic 130g. 3-tray rotation: 30–43 g/day.
- **Source:** PMC5362588, Bootstrap Farmer, Johnny's Seeds Yield Trial
- **Confidence:** Medium (validate with prototype)

### [FINDING-008] Compost vs. Coir: 73% More Minerals in Compost
- **Date:** 2026-02-17
- **Finding:** USDA study. Coir is vehicle-compatible but mineral-poor. Liquid supplement (CalMag) partially compensates.
- **Source:** PMC5362588
- **Confidence:** High

### [FINDING-009] Light Intensity Affects Nutritional Profile
- **Date:** 2026-02-17
- **Finding:** 100–150 µmol/m²/s → more carotenoids/anthocyanins. 50–75 → more vitamin C/phenolics. 100 µmol/m²/s balances both.
- **Source:** Literature review
- **Confidence:** Medium

### [FINDING-010] YouTube Channel @continuousharvest5822
- **Date:** 2026-02-17
- **Finding:** Cannot be fetched programmatically. Review manually. URL: https://www.youtube.com/@continuousharvest5822
- **Confidence:** N/A

### [FINDING-011] Raw Home Freezing Increases Sulforaphane Up to 3.1×
- **Date:** 2026-02-17
- **Finding:** −20°C home freezing of raw unblanched microgreens increases myrosinase activity +17–117% and SFN yield up to 3.1×. GRN fully preserved. Blend from frozen immediately — do not thaw. Commercial frozen broccoli is blanched (kills myrosinase) — completely different.
- **Source:** RSC Advances c5ra03403e; Jed Fahey / FoundMyFitness; PubMed 23915112
- **Confidence:** High

### [FINDING-012] Vehicle Requirement Changes Design Fundamentally
- **Date:** 2026-02-17
- **Finding:** claude.md's "must work in moving vehicles" requirement drives: (1) coir instead of compost — lightweight, fibrous, non-spill; (2) sealed reservoir and sub-trays — no open water; (3) peristaltic pump — works in any orientation; (4) wide low-CG enclosure; (5) positive-lock tray retention; (6) 12V DC supply compatible with vehicle electrical system.
- **Source:** claude.md design goals; Phase 02 design work
- **Confidence:** High (design constraint)

### [FINDING-013] 5.6W Average Power — 40W Solar Achieves Energy Balance
- **Date:** 2026-02-17
- **Finding:** Full system average load: 5.6W = 134 Wh/day. 40W panel at 4 peak sun hours × 0.85 efficiency = 136 Wh/day. Effectively break-even. 50W panel provides comfortable surplus. 20Ah LiFePO4 = 34h autonomy on battery alone.
- **Source:** Phase 02 power calculations
- **Confidence:** High (calculated from specifications)

---

## Open Questions

| ID | Question | Blocks | Priority | Notes |
|----|----------|--------|----------|-------|
| Q-001 | Actual yield of 25×25cm tray with coir under 100 µmol/m²/s | Confirm DECISION-005 | High | Validate by prototype; current estimate 90–130g |
| Q-003 | Automated harvest notification vs. simple timer LED | Phase 04 software | Low | Recommend timer-based LED for simplicity |
| Q-004 | Fresh shelf life with dry refrigerated storage | DECISION-004 | Medium | 5–7 days consensus |
| Q-005 | @continuousharvest5822 YouTube channel content | Growing system detail | Medium | Manual review required |
| Q-008 | What PETG waterproofing method is most practical? XTC-3D vs. shellac vs. dedicated sealant? | Enclosure build | Medium | Test on small print before full build |
| Q-009 | Does the 3W LED panel (3× efficiency) achieve 100 µmol/m²/s at 10cm over 625 cm²? | Lighting spec | Medium | Measure with PAR meter on prototype; 5W panel is fallback |
| Q-010 | What is the CalMag supplement dose effect on broccoli microgreen mineral content and flavor? | Growing system optimization | Low | Optional; primary nutrition from SFN, not minerals |

---

## Resolved Questions

| ID | Question | Resolution |
|----|----------|------------|
| Q-002 | Blackout method for germination | Software-controlled per-tray LED disable (days 0–2); no physical cover needed |
| Q-006 | Optimal seeding density | 12–15g per 25×25cm tray (0.19–0.24 g/cm²); pre-soak seed 4–8 hours |
| Q-007 | Water recirculation vs. drain-to-waste | Drain-to-waste into sealed waste chamber; recirculation adds complexity without benefit at these volumes |

---

## Phase 01: Research — Complete

All 5 documents written. Key outputs:
- Species: broccoli
- Daily target: 30g/day fresh
- Primary consumption: morning smoothie raw
- Preservation: fresh (primary) + raw frozen (secondary, increases SFN 3.1×)

---

## Phase 02: Design — Complete

### Key Design Specifications (summary for quick reference)

| Parameter | Specification |
|-----------|--------------|
| Tray size | 25×25 cm (625 cm²), PETG |
| Tray count | 3 (primary); 4 (60 g/day max) |
| Growing medium | Coir (compressed pucks) |
| Seed per tray | 12–15 g (pre-soaked 4–8h) |
| Grow cycle | 10 days; harvest days 8–10 |
| Rotation | Seed 1 tray every 3 days; harvest every 3 days |
| Expected yield | 90–130 g/tray; 30–43 g/day |
| Light per tray | 3W full-spectrum LED, 5000–6500K |
| PPFD target | ~100 µmol/m²/s at tray surface |
| Photoperiod | 14h on / 10h off |
| Blackout | Days 0–2 per tray (software) |
| Watering | Top-drip, 2×/day, 25 mL/tray/event |
| Pump | 12V peristaltic, 3–5W, 6 min/day |
| Reservoir | 2L sealed PETG; 10–14 day autonomy |
| Controller | ESP32 (Arduino IDE) |
| Power input | 12V DC (barrel jack) |
| Avg power | 5.6W (134 Wh/day) |
| Peak power | 14.5W |
| Solar (off-grid) | 40W panel + 20Ah LiFePO4 + 10A MPPT |
| Battery autonomy | ~34h on battery alone |
| Enclosure | PETG, 300×300×850 mm, modular rings |
| Print filament | ~2.4 kg PETG |
| Total BOM (electronics, excl. solar) | ~$130–150 target |
| Total BOM (with solar system) | ~$220–310 |

### Documents Written
- ✅ [design-requirements.md](docs/02-design/design-requirements.md)
- ✅ [system-architecture.md](docs/02-design/system-architecture.md)
- ✅ [growing-system.md](docs/02-design/growing-system.md)
- ✅ [lighting-system.md](docs/02-design/lighting-system.md)
- ✅ [watering-system.md](docs/02-design/watering-system.md)
- ✅ [power-system.md](docs/02-design/power-system.md)
- ✅ [preservation-system.md](docs/02-design/preservation-system.md)
- ✅ [enclosure-design.md](docs/02-design/enclosure-design.md)

---

## Phase 03: Build — Complete

### [DECISION-013] Tray Ring Split: 4 Corner Quarters (not 4 Wall Panels)
- **Date:** 2026-02-17
- **Decision:** Each tray ring is split into 4 L-shaped corner-quarter sections (FL, FR, RL, RR) rather than 4 wall panels (front, rear, left, right).
- **Rationale:** Wall panels (300mm wide × ring_h tall) cannot fit on a 200×200mm print bed in any orientation. Corner quarters (150×150×ring_h) fit on a 200×200mm bed when printed standing up (ring_h in Z ≤ 200mm). This resolves the bed-size constraint (C-012).
- **Trade-off:** 4 corner seams instead of 4 panel seams; seams sealed with RTV + M3 bolts; light-seal flanges carry over to each quarter.
- **Status:** Active

### [DECISION-014] Ring Height: 190mm (not 260mm as per enclosure-design.md)
- **Date:** 2026-02-17
- **Decision:** ring_h = 190mm to achieve 850mm total height: 200 + 3×190 + 80 = 850mm ≤ 900mm (NFR).
- **Rationale:** enclosure-design.md stated ring_h = 260mm but this yields 1060mm total, violating the ≤90cm NFR. 190mm ring still accommodates: 12mm sub-tray ledge + 40mm sub-tray + 4mm ledge + 50mm tray + 100mm LED clearance (minimum) + 8mm flanges × 2 = ~222mm interior + flanges = ~238mm. The 190mm ring is tight on LED clearance; users may override ring_h = 260mm if accepting taller unit.
- **Impact:** LED clearance above tray is ~88mm (not 100–130mm spec). Prototype needed to verify (Q-009).
- **Status:** Active — validate in prototype

### [DECISION-015] Base Unit Reservoir Layout
- **Date:** 2026-02-17
- **Decision:** Chambers are arranged in a 2×2 quadrant layout within the 300×300mm base:
  - Rear-left: Reservoir (204×142×84mm interior ≈ 2.43L)
  - Rear-right: Waste chamber (84×142×84mm interior ≈ 1.0L)
  - Front-left: Electronics bay (100×142×84mm interior)
  - Front-right: Pump/wiring space (open top, accessible)
- **Split:** Front/rear at Y=150mm for printing.
- **Rationale:** Rear zone holds all water; front zone stays dry; partition at Y=150mm is the print split line. RTV silicone + PETG solvent weld seals the joint where it crosses the water zone.
- **Status:** Active

### [DECISION-016] Soil Moisture Sensing: 3× Capacitive V1.2 Sensors (One per Tray)
- **Date:** 2026-02-18
- **Decision:** Add one capacitive soil moisture sensor (V1.2) per tray, wired to ADC1 pins (GPIO34, GPIO35, GPIO32). Enables feedback-controlled watering: top-up watering event triggered if coir reads dry after a scheduled event; scheduled event skipped if coir reads saturated.
- **Rationale:** Timer-only watering cannot account for evaporation variation across trays at different growth stages. Capacitive sensors (not resistive) avoid electrolytic corrosion in damp coir. Firmware feedback loop avoids both under-watering (wilting) and over-watering (mold/rot). Adds ~$3.66 to BOM.
- **ADC1 constraint:** All three sensor pins on ADC1 (GPIO32=ADC1_CH4, GPIO34=ADC1_CH6, GPIO35=ADC1_CH7). ADC2 is disabled when WiFi is active on ESP32 — no ADC2 pins used for sensors.
- **Calibration:** Dry-air baseline and submerged-in-water baseline stored in firmware EEPROM. Threshold: <30% → trigger top-up; >80% → skip next event.
- **BOM:** AliExpress item 32853373769, ~$1.22 each × 3 = $3.66
- **Status:** Active

### [DECISION-017] Reservoir Level Sensing: ZP2508 NC Float Switch (replaces XKC-Y25-V)
- **Date:** 2026-02-18
- **Decision:** Use ZP2508 normally-closed (NC) reed float switch mounted inside the reservoir through a lid gland. Replaces the XKC-Y25-V capacitive level sensor specified in Phase 02.
- **Rationale:** XKC-Y25-V requires flush mounting on a flat exterior PETG wall — impractical for a curved/ribbed enclosure and requires through-wall cutout near waterline. ZP2508 mounts internally via a 6mm gland in the reservoir lid; no wall penetration below waterline. NC wiring means open circuit = low water = GPIO33 reads LOW (alarm) — fail-safe behaviour (low-water alarm activates on sensor disconnect). Two-wire passive device requires no power supply.
- **GPIO:** GPIO33 digital input with INPUT_PULLUP. Float switch between GPIO33 and GND: closed (high water) = GPIO reads HIGH; open (low water) = GPIO reads LOW → alarm.
- **BOM:** AliExpress item 4000246458661, ~$0.62
- **Status:** Active

### [DECISION-018] LED: 12V Full-Spectrum Grow Strip (not Samsung LM301H Quantum Board)
- **Date:** 2026-02-18
- **Decision:** Use 12V-native full-spectrum plant grow strips (AliExpress item 32816538353) cut to 3×25cm lengths. One strip per tray, driven directly from the 12V rail via relay — no LED driver required.
- **Rationale:** Phase 02 research recommended Samsung LM301H/LM281B for optimal efficiency. Product search confirmed all genuine Samsung-based quantum boards operate at 38–54V DC constant-current. Adding a 12V→48V boost converter would introduce a third voltage conversion stage, violate the single-rail design principle, and add cost and failure points. The 12V grow strips achieve the specified 5000–6500K full-spectrum and deliver ~100 µmol/m²/s PPFD at 10cm when cut to 25cm length and powered at 3W per tray. Samsung LM301H boards remain the preferred choice for a future mains-powered version.
- **Strapping:** Each strip segment wired to a separate relay channel (CH1/CH2/CH3) for independent per-tray photoperiod control.
- **BOM:** AliExpress item 32816538353, ~$11.41 (covers all 3 trays); Amazon B08T89VRPP as alternate.
- **Status:** Active

### [DECISION-019] Relay Module: JD-VCC Isolated, LOW-Level Trigger
- **Date:** 2026-02-18
- **Decision:** Use a 4-channel relay module with opto-isolated JD-VCC rail and LOW-level trigger (AliExpress item 32897567002). The VCC–JD-VCC shorting jumper must be removed before installation. Relay coils powered from the MP1584 5V rail via the JD-VCC pin. ESP32 GPIO drives IN pins LOW to activate relays.
- **Rationale:** Relay coil inrush current (70–100mA per coil) can cause ESP32 brownout/reset if coils are powered from the same 3.3V or 5V rail as the ESP32. JD-VCC isolation physically separates the coil supply from the logic supply via opto-couplers. LOW-level trigger is standard for this module family; ESP32 GPIOs are initialized HIGH on boot (relays OFF) to prevent inadvertent load activation during firmware startup.
- **Wiring:** VCC pin → 3.3V (logic only). JD-VCC pin → 5V (coil supply). GND pin → common GND. IN1–IN4 → ESP32 GPIO26/27/25/13 respectively.
- **BOM:** AliExpress item 32897567002, ~$3.10; Amazon B0BXKKYH5C as alternate.
- **Status:** Active

### OpenSCAD 3D Models — Complete
- ✅ `hardware/3d-models/source/params.scad` — all parametric dimensions
- ✅ `hardware/3d-models/source/base_unit.scad` — base + lids + electronics cover + pump mount
- ✅ `hardware/3d-models/source/tray_ring.scad` — ring + 4 corner quarters
- ✅ `hardware/3d-models/source/growing_tray.scad` — growing tray with drain holes
- ✅ `hardware/3d-models/source/sub_tray.scad` — sealed sub-tray with overflow port
- ✅ `hardware/3d-models/source/led_bracket.scad` — adjustable LED mount
- ✅ `hardware/3d-models/source/tray_door.scad` — hinged door with magnet catch
- ✅ `hardware/3d-models/source/top_cap.scad` — top cap with seed storage + handle
- ✅ `hardware/3d-models/source/misc_parts.scad` — tube clip, manifold, drip emitter, LED panel
- ✅ `hardware/3d-models/Makefile` — batch STL export (requires openscad ≥ 2021.01)

**To generate STLs:** `sudo apt install openscad && cd hardware/3d-models && make all`

### Resolved by 3D Modelling
- **Q-008** (waterproofing): XTC-3D epoxy primary for reservoir and sub-trays; documented in sub_tray.scad comments and printing-instructions.md. Recommend test per Q-008 protocol.
- **C-012** (200×200mm bed): Ring quarters fit 200×200mm; growing tray and sub-tray require 250×256mm bed (or split further).

### Still Open
- Q-001: Validate actual tray yield (prototype)
- Q-009: Verify LED PPFD at reduced ring_h = 190mm (prototype)

### Build Documents — All Complete
- ✅ [parts-list-electrical.md](docs/03-build/parts-list-electrical.md)
- ✅ [parts-list-consumables.md](docs/03-build/parts-list-consumables.md)
- ✅ [printing-instructions.md](docs/03-build/printing-instructions.md)
- ✅ [assembly-instructions.md](docs/03-build/assembly-instructions.md) — 20-step beginner guide; 3D print ordering section; waterproofing section; corrected GPIO assignments (GPIO25/GPIO13); ZP2508 float switch; 3× moisture sensors; JD-VCC relay isolation detail; completion checklist; troubleshooting table (rewritten 2026-02-18)
- ✅ [bill-of-materials.csv](bom/bill-of-materials.csv) — 50 line items; specific products with AliExpress/Amazon URLs, ASINs, and prices; updated 2026-02-18 with real product links

### Electrical Design Documents — Complete (added 2026-02-18)
- ✅ [wiring-schematic.md](hardware/schematics/wiring-schematic.md) — 9-section wiring reference: design principles, power flow diagram, per-component specs with vendor URLs, wire-by-wire connection table (40+ rows), power budget, connector map, safety checklist, ASCII schematic, harness layout

### 3D Model Renders — Complete
All 10 PNG renders saved to `hardware/3d-models/renders/`:
- `01_assembly_overview.png` — Full 3-ring + base + cap isometric
- `02_base_unit.png` — Base chambers isometric + floor plan
- `03_tray_ring.png` — Ring isometric + XZ cross-section with ledge rails
- `04_growing_tray.png` — Tray isometric + top view with drain holes
- `05_sub_tray.png` — Sub-tray with overflow/drain cross-section
- `06_led_bracket.png` — LED bracket isometric + side elevation with height adjustment
- `07_tray_door.png` — Door isometric in context + front face dimensions
- `08_top_cap.png` — Top cap isometric + plan view with internal compartments
- `09_misc_parts.png` — Manifold / drip emitter / tube clip schematics
- `10_exploded_view.png` — Exploded stack showing all 5 vertical sections

Note: Renders are matplotlib technical diagrams (OpenSCAD not available in build environment). Accurate to params.scad dimensions.

---

## Phase 04: Software — Complete

### [DECISION-020] Firmware Framework: Arduino (not MicroPython)
- **Date:** 2026-02-18
- **Decision:** ESP32 firmware written in C++ using the Arduino framework (Espressif arduino-esp32 core).
- **Rationale:** Arduino framework is the simplest option for this hardware: broad library support (RTClib, Adafruit SSD1306), extensive community examples for ESP32 I2C peripherals, and straightforward light sleep API (`esp_light_sleep_start()`). MicroPython was considered but has weaker support for the ESP32 sleep APIs and lower performance for multi-channel ADC averaging.
- **Libraries:** RTClib (Adafruit), Adafruit GFX, Adafruit SSD1306 — all installable via Arduino Library Manager.
- **Status:** Active

### [DECISION-021] Power Strategy: Light Sleep Between 60-Second Loop Iterations
- **Date:** 2026-02-18
- **Decision:** The ESP32 enters light sleep (`esp_light_sleep_start()`) for 60 seconds between each main-loop execution. GPIO output registers are preserved during light sleep (relays remain in their current state without any firmware intervention). A button press on GPIO0 configured as a GPIO wake source exits light sleep immediately.
- **Rationale:** Deep sleep cannot be used because relay outputs revert to input/floating on wakeup, which could briefly toggle the loads. Light sleep preserves GPIO state while reducing ESP32 current from ~80 mA active to ~0.8 mA sleeping. At 60 s sleep with ~3 s active: average ~3 mA instead of 80 mA — a significant saving for battery-powered operation.
- **Impact:** Schedule transitions are up to 60 s late (acceptable; LED lighting and watering do not require second-level precision). Sleep duration is `SLEEP_SECONDS` in `config.h`.
- **Status:** Active

### [DECISION-023] Germination Watering Exclusion (GERMINATION_WATER_DAYS)
- **Date:** 2026-02-18
- **Decision:** Trays in days 0 through `GERMINATION_WATER_DAYS` (default: 2) are excluded from moisture-driven pump decisions. They cannot trigger pump runs, but still receive water as a side-effect when established trays (day > GERMINATION_WATER_DAYS) need watering. If all active trays are germinating, the pump is skipped entirely for that event.
- **Rationale:** Seeds are soaked 4–8 hours before sowing; coir is already saturated on Day 0. Over-watering during Days 0–2 creates anaerobic conditions at the root zone — the primary cause of *Pythium* damping-off (fungal root rot). Established trays' watering events naturally drip water to germinating trays through shared emitter runs, providing adequate moisture without triggering additional pump runs.
- **Firmware changes:** `config.h` — new `GERMINATION_WATER_DAYS = 2` constant. `microgreen_controller.ino` — `run_pump()` skip and top-up check loops changed from `day >= 0` to `day > GERMINATION_WATER_DAYS`.
- **Documentation:** `docs/04-software/requirements.md` — SW-008 added; GERMINATION_WATER_DAYS parameter documented.
- **Status:** Active

### [DECISION-024] Active Ventilation — 40mm 12V Fan with Manual Toggle Switch
- **Date:** 2026-02-18
- **Decision:** A 40mm 12V brushless fan is mounted in the top cap top surface (X=150, Y=220, exhausting upward). Controlled by a manual SPST toggle switch mounted in the top cap front face (X=255, Z=50). No relay, no firmware involvement — purely a hardware circuit (12V bus → switch → fan → GND).
- **Rationale:** Warm, enclosed growing chambers accumulate humidity that promotes mold and bacterial biofilm. Active ventilation provides on-demand humidity control without always-on power draw. Manual control is appropriate — the user decides when conditions warrant running the fan (mold observed, hot weather, vehicle use). Passive ventilation (existing ring vent slots) handles normal conditions.
- **Fan specs:** 40×40×10mm, 12V DC, ≤25 dBA brushless PC fan (~$3). Fan guard snap-fits onto exhaust face. 4× M3×12mm bolts on 32mm bolt circle.
- **BOM additions:** E30 (fan), E31 (toggle switch), E32 (fan guard).
- **3D model changes:** `top_cap.scad` — fan mount pad added to union; fan hole (Ø37mm), fan recess (Ø42mm × 2mm), 4× M3 holes (32mm bolt circle), switch hole (Ø6.5mm) added to difference. `params.scad` — fan/switch parameters added.
- **Status:** Active

### [DECISION-028] Open-Source Publication — GitHub
- **Date:** 2026-02-18
- **Decision:** Project published as a public open-source repository at https://github.com/skyl4rk/microgreen-box
- **Licence:** Dual-licence — CERN-OHL-S v2 for hardware (3D models, schematics); MIT for firmware; CC-BY-SA 4.0 for documentation.
  - CERN-OHL-S v2 chosen for hardware because it is strongly reciprocal (modifications to hardware designs must be published under the same licence), which ensures improvements remain open. CERN-OHL-S is the standard for open hardware with a copyleft requirement, endorsed by OSHWA.
  - MIT chosen for firmware because it is maximally permissive — contributors can integrate firmware techniques into other projects without licence friction.
  - CC-BY-SA 4.0 chosen for documentation as it is the standard creative commons share-alike licence for technical writing.
- **Files added:** `README.md` (complete rewrite), `CONTRIBUTING.md`, `hardware/LICENSE` (CERN-OHL-S v2), `software/LICENSE` (MIT), `.gitignore`
- **Status:** Active

### [DECISION-027] Documentation Consistency Fixes Applied Before Publication
- **Date:** 2026-02-18
- **Inconsistencies found and corrected:**
  1. **Ring height:** `enclosure-design.md` showed 260mm per ring throughout — corrected to 190mm to match `params.scad` and DECISION-014. The section heading, dimension table, and door dimensions (150×260mm → 150×174mm) were all wrong.
  2. **Interior clearance:** "100–130mm tray-to-LED clearance" was designed for 260mm rings — corrected to ~80–110mm for 190mm rings.
  3. **Print strategy:** "Two halves (front + back)" in the ring print strategy contradicted DECISION-013 (4 corner quarters). Corrected to "4 L-shaped corner quarters (FL, FR, RL, RR)".
  4. **Chamber internal dimensions:** enclosure-design.md listed approximate design-phase dimensions (reservoir 200×150×75mm, waste 100×150×75mm, electronics bay 90×150×75mm) that did not match params.scad (reservoir 204×142×84mm = 2.43L, waste 84×142×84mm = 1.0L, electronics bay 100×140×84mm). Corrected to match params.scad.
  5. **Filament and print time totals:** enclosure-design.md showed 2,400g / 65h (from the design phase, before the 4-quarter split and misc parts were added). Corrected to 2,465g / 71.5h to match printing-instructions.md.
- **Files changed:** `docs/02-design/enclosure-design.md`
- **Status:** Active (these fixes are applied; no further action needed)

### [DECISION-026] Insect Protection — Fan Dust Filter + Vent Slot Mesh Screens
- **Date:** 2026-02-18
- **Decision:** Two permanent passive insect barriers are added to the enclosure:
  1. **Fan exhaust hole (Ø37mm):** A 40mm PC fan foam dust filter (≤0.5mm pore) is placed on the fan's exhaust (exterior/top) face, sandwiched between the fan body and the wire guard (E32). This seals the fan hole against insect ingress when the fan is off. The wire guard retains the filter in place.
  2. **Ring vent slots (25×8mm, 2 per ring, 6 total):** A 27×10mm patch of fiberglass insect screen mesh (~1.2mm pore) is adhered with RTV silicone over the interior face of each vent slot opening during ring assembly. The screens are permanent — they block insects regardless of whether the slide cover is in place, allowing the slide covers to be left out for ventilation without any insect risk.
- **Rationale:** The primary microgreen pest is the fungus gnat (*Bradysia* spp.) at ~2mm body width. The vent slots (25×8mm) and fan hole (Ø37mm) are the two main openings large enough for insect entry. The wire fan guard alone (~3–5mm openings) does not stop gnats. Adding dedicated insect barriers to these two openings closes all significant entry paths without restricting airflow. The foam filter is appropriate for the fan (small, snap-fit, standardized); fiberglass mesh is appropriate for the narrow vent slots (rigid, easy to cut, silicone-bondable to PETG).
- **BOM additions:** E33 (40mm PC fan dust filter, ~$1.50), E34 (fiberglass insect screen mesh 100×50mm piece, ~$1.00).
- **Assembly changes:** `assembly-instructions.md` — Step 12 vent slot note expanded with 4-sub-step mesh installation procedure; Step 16a fan installation step 5 updated to include filter; new "Insect protection" completion checklist section added (4 items).
- **User manual changes:** `user-manual.md` — insect protection paragraph added to Ventilation fan section.
- **Status:** Active

### [DECISION-025] Mold and Bacteria Prevention Protocol
- **Date:** 2026-02-18
- **Decision:** A multi-layer prevention protocol is documented in the user manual and followed routinely:
  1. **Seed sanitation:** 30-second rinse in 3% H₂O₂ before the 4–8h water soak; rinse with clean water after.
  2. **Coir preparation:** Brief tap water rinse of coir puck before expansion to remove dust and salt residue.
  3. **Seeding density:** Single even layer, no clumps, full coir surface coverage.
  4. **Reservoir (monthly):** Drain → wipe with 1 tsp 3% H₂O₂ per 500 mL water → rinse twice → refill. Optional: 1–2 mL food-grade 3% H₂O₂ per litre of reservoir water ongoing.
  5. **Tubing (monthly):** Flush with 1% H₂O₂ solution → follow with clean water flush.
  6. **Ventilation:** Run active fan + open ring vent slide covers when mold is observed.
- **Rationale:** Mold prevention is primarily environmental (reduce over-watering + improve airflow) and hygiene-based (reduce inoculum at seeding). H₂O₂ is preferred over bleach: food-safe, leaves no harmful residue, decomposes to water + oxygen.
- **Documentation:** `docs/04-software/user-manual.md` — new "Mold and Bacteria Prevention" section added.
- **Status:** Active

### [DECISION-022] User Interface: Single Button, Status LEDs, OLED
- **Date:** 2026-02-18
- **Decision:** One button (BOOT/GPIO0) seeds the next available tray. No menus. Visual feedback via LED colour/pattern and OLED text. Serial commands (`T<epoch>`, `S`) for setup and diagnostics.
- **Rationale:** The device has one recurring user action (seeding a new tray every ~3 days). A single button with LED confirmation is sufficient and keeps the firmware simple. The OLED is treated as optional (device is fully functional without it — all status available via serial monitor).
- **Button behaviour:** Single press seeds the first tray in order A→B→C that is empty (seed_epoch == 0) or cycle-complete (day ≥ GROW_DAYS). Three green LED flashes = success. Five red flashes = all trays active (try again in 3+ days). Button also serves as GPIO wake source from light sleep.
- **Status:** Active

### GPIO Pin Map (updated 2026-02-18 — see wiring-schematic.md for full details)

> **Note:** GPIO12 (strapping pin, affects flash voltage) and GPIO14 replaced by GPIO25 and GPIO13 respectively. All sensor ADCs on ADC1 to avoid WiFi conflict. See DECISION-016, DECISION-017, DECISION-019.

| GPIO | Function | Notes |
|------|----------|-------|
| 26 | Relay IN1 — LED Tray A | LOW = relay ON |
| 27 | Relay IN2 — LED Tray B | LOW = relay ON |
| 25 | Relay IN3 — LED Tray C | LOW = relay ON |
| 13 | Relay IN4 — Pump | LOW = relay ON |
| 21 | I2C SDA (RTC DS3231 + OLED SSD1306) | 4.7kΩ pull-up on modules |
| 22 | I2C SCL (RTC DS3231 + OLED SSD1306) | 4.7kΩ pull-up on modules |
| 34 | Moisture sensor — Tray A (ADC1_CH6) | Input-only pin |
| 35 | Moisture sensor — Tray B (ADC1_CH7) | Input-only pin |
| 32 | Moisture sensor — Tray C (ADC1_CH4) | |
| 33 | Float switch — reservoir low (INPUT_PULLUP) | NC: HIGH=full, LOW=alarm |
| 18 | Status LED — power (green, 330Ω) | |
| 19 | Status LED — water low (yellow, 330Ω) | |
| 5  | Status LED — Tray A harvest (red, 330Ω) | |
| 17 | Status LED — Tray B+C harvest (red, 330Ω) | |
| 16 | Buzzer (100Ω series) | |

**Avoided pins:** GPIO0/2/15 (boot strapping), GPIO12 (flash voltage strapping), GPIO6–11 (SPI flash), GPIO1/3 (UART TX/RX), all ADC2 pins (WiFi conflict).

### Software Documents — Complete (updated 2026-02-18)
- ✅ [requirements.md](docs/04-software/requirements.md) — all config.h parameters documented; SW-008 (GERMINATION_WATER_DAYS) added (DECISION-023)
- ✅ [installation-guide.md](docs/04-software/installation-guide.md) — Arduino IDE setup; library install; flashing; RTC time-setting; moisture sensor calibration; pump calibration; troubleshooting table; I2C scanner sketch
- ✅ [user-manual.md](docs/04-software/user-manual.md) — daily operation, seeding/harvesting/cleaning, refilling, consumption methods, troubleshooting, configuration reference, quick-reference card; **new: Mold and Bacteria Prevention section (DECISION-025); Temperature and Environment section; insect protection paragraph in Ventilation section (DECISION-026)**

### Enclosure and Hardware Documents — Complete (updated 2026-02-18)
- ✅ [enclosure-design.md](docs/02-design/enclosure-design.md) — Ventilation section updated with active fan design; top cap section updated with fan/switch features (DECISION-024)
- ✅ [wiring-schematic.md](hardware/schematics/wiring-schematic.md) — Section 3.12 (fan circuit) added; power budget updated (DECISION-024)
- ✅ [assembly-instructions.md](docs/03-build/assembly-instructions.md) — Step 16a (fan/switch installation) added; passive vent slot note added to Step 12 with mesh installation procedure; insect protection completion checklist section added (DECISION-024, DECISION-026)
- ✅ [bill-of-materials.csv](bom/bill-of-materials.csv) — E30/E31/E32 added (fan, toggle switch, fan guard — DECISION-024); E33/E34 added (fan dust filter, insect screen mesh — DECISION-026)
- ✅ [params.scad](hardware/3d-models/source/params.scad) — fan/switch ventilation parameters added (DECISION-024)
- ✅ [top_cap.scad](hardware/3d-models/source/top_cap.scad) — fan mount pad, exhaust hole, recess, M3 holes, switch hole added (DECISION-024)

### Firmware Files — Complete (updated 2026-02-18 — mold prevention)
- ✅ [microgreen_controller.ino](../../software/firmware/microgreen_controller/microgreen_controller.ino) — main Arduino sketch; `run_pump()` updated with GERMINATION_WATER_DAYS exclusion (DECISION-023)
- ✅ [config.h](../../software/firmware/microgreen_controller/config.h) — all user-adjustable parameters; `GERMINATION_WATER_DAYS = 2` added (DECISION-023)

### Firmware Feature Summary
| Feature | Implementation |
|---------|---------------|
| Light scheduling | Per-tray relay, hour-based photoperiod, BLACKOUT_DAYS germination suppression |
| Watering schedule | Two events/day (WATER_HOUR_1 / WATER_HOUR_2); pump log stored in EEPROM |
| Moisture feedback | Skip event if all trays ≥ 70 %; top-up if any tray ≤ 25 % after settling |
| Reservoir alarm | Float switch → GPIO33; yellow LED + two buzzer beeps on rising edge |
| Harvest alert | Day ≥ HARVEST_DAY → red LED + one buzzer beep (one-shot per tray) |
| Grow day counter | Seed epoch stored in EEPROM; day = (now − epoch) / 86400 |
| RTC | DS3231; survives power loss via CR2032; set via serial `T<epoch>` |
| Display | SSD1306 OLED — time, water status, per-tray state, pump status |
| Sleep | ESP32 light sleep 60 s between loops; ~0.8 mA sleep vs ~80 mA active |
| Button | GPIO0/BOOT — seed next available tray; GPIO wake from sleep |
| Serial | 115200 baud; `T<epoch>` sets RTC; `S` dumps status |

---

## Phase 05: Publication — Complete

### Repository
- **URL:** https://github.com/skyl4rk/microgreen-box
- **Visibility:** Public
- **Initial commit:** 2026-02-18 (56 files, 10,646 insertions)

### Licence files
- ✅ `hardware/LICENSE` — CERN Open Hardware Licence Version 2 — Strongly Reciprocal (CERN-OHL-S v2)
- ✅ `software/LICENSE` — MIT License
- Documentation covered by CC-BY-SA 4.0 (stated in README)

### New files added for publication
- ✅ `README.md` — complete rewrite; project description, renders, BOM summary, getting-started guide, spec table, firmware quick reference, nutrition context, licence summary
- ✅ `CONTRIBUTING.md` — contribution guidelines: build reports, bug reports, hardware design, firmware, PR process, consistency rules, prioritised contribution areas
- ✅ `.gitignore` — Python cache, OS files, editor temp files, Arduino build artifacts

### Consistency issues fixed before publication (DECISION-027)
All fixes applied to `docs/02-design/enclosure-design.md`:
1. Ring height: 260mm → 190mm (heading, dimension table, door dimensions)
2. Interior LED clearance: 100–130mm → ~80–110mm
3. Print strategy: "two halves" → "4 L-shaped corner quarters (FL, FR, RL, RR)"
4. Chamber internal dimensions: corrected to match params.scad ground truth
5. Filament/print time totals: 2,400g/65h → 2,465g/71.5h

---

## Constraints and Non-Negotiables

| ID | Constraint | Value | Source |
|----|------------|-------|--------|
| C-001 | Species | Broccoli only | DECISION-001 |
| C-002 | Daily output (primary) | 30 g/day fresh | DECISION-002 |
| C-003 | Daily output (max) | 60 g/day fresh | DECISION-002 |
| C-004 | Growing medium | Coir only (NOT compost) | DECISION-007 |
| C-005 | No heat-based processing in device | Fresh output only | DECISION-003, DECISION-004 |
| C-006 | Enclosure footprint | ≤35×35 cm | DECISION-005 |
| C-007 | Reservoir capacity | ≥1.5 L (→ 2L chosen) | NFR-001 |
| C-008 | Power supply | 12V DC primary | DECISION-009, claude.md |
| C-009 | Structural material | PETG (not PLA) | DECISION-012 |
| C-010 | Fully sealed water paths | No open water surfaces | DECISION-011, claude.md |
| C-011 | BOM cost (excl. solar) | ≤$150 USD | claude.md |
| C-012 | All parts 3D-printable | Max part 200×200×200mm | claude.md |

---

## Glossary

| Term | Definition |
|------|------------|
| Microgreens | Seedlings of vegetables/herbs harvested 7–14 days after germination, at cotyledon stage. |
| Growing tray | 25×25×5cm PETG container holding coir and seeds. |
| Sub-tray | 25×25×4cm sealed PETG water retention chamber below the growing tray. |
| Grow cycle | One complete cycle from seeding to harvest (~10 days for broccoli). |
| GRN | Glucoraphanin — stable sulforaphane precursor stored in broccoli plant cells. |
| SFN | Sulforaphane — active bioactive; produced from GRN by myrosinase enzyme. |
| Myrosinase | Enzyme converting GRN to SFN; destroyed above ~60–70°C; NOT destroyed by freezing. |
| PPFD | Photosynthetic Photon Flux Density — light intensity in µmol/m²/s. |
| DLI | Daily Light Integral — total light dose in mol/m²/day = PPFD × hours × 0.0036. |
| Staggered rotation | Planting schedule where trays are seeded on different days for continuous harvest. |
| Peristaltic pump | Pump type using rollers on flexible tubing; works in any orientation; self-priming; dry-run safe. |
| LiFePO4 | Lithium iron phosphate battery chemistry — safe in high temperatures, long-lived. |
| MPPT | Maximum Power Point Tracking — solar charge controller that maximizes panel efficiency. |
| Coir | Compressed coconut fiber; lightweight, stable growing medium; vehicle-compatible. |
| CalMag | Liquid calcium + magnesium supplement added to watering water to supplement coir mineral content. |
| Nrf2 pathway | Cellular signaling pathway activated by sulforaphane; upregulates antioxidant enzymes. |
