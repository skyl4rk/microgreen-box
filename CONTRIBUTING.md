# Contributing to Microgreen Box

Thank you for your interest in improving this project. Contributions of all kinds are welcome: build reports, bug fixes, design improvements, documentation corrections, and new features.

---

## Before you start

1. **Read [PROJECT_DECISIONS.md](PROJECT_DECISIONS.md) in full.** It records every design decision made and the reasoning behind it. Avoid proposing changes that contradict existing decisions without also proposing to amend the decision.

2. **Read the relevant design documents** in `docs/02-design/` for the subsystem you want to change.

3. **Check open issues** to see if your idea is already being discussed.

---

## Types of contribution

### Build reports and validation data

The most valuable contribution right now is building the device and reporting back:

- Did the printed parts fit together as specified?
- What yield did you get per tray (grams at harvest)?
- What moisture sensor readings did you observe across the grow cycle?
- Any mold incidents — what caused them, what fixed them?

Open an issue with the label `build-report` and share your results.

### Bug reports

Open an issue with:
- Which file or component is affected
- What the document/firmware says vs. what you observed
- Steps to reproduce (for firmware bugs)

### Documentation fixes

Small documentation fixes (typos, broken links, factual errors) can be submitted directly as a pull request. For larger documentation changes, open an issue first to discuss.

### Hardware design improvements

Improvements to the 3D models, schematics, or BOM:

1. Open an issue describing the improvement and why it's needed
2. Wait for discussion before spending time on implementation
3. Make changes in the OpenSCAD source files — do not submit binary STL-only changes without the source
4. Test that `make all` still generates valid STL files
5. Update `params.scad` if any dimensions change
6. Update the relevant design documents and BOM if components change
7. Submit a pull request referencing the issue

Under the CERN-OHL-S v2 licence, hardware modifications you distribute must be released under the same licence.

### Firmware improvements

For firmware changes:

1. Open an issue first for non-trivial changes
2. Keep `config.h` as the single source of user-adjustable parameters — no hardcoded values in the `.ino` file
3. Test that the firmware compiles cleanly in Arduino IDE 2.x with the ESP32 board package
4. If adding new config parameters, document them in `config.h` comments and in `docs/04-software/requirements.md`
5. Submit a pull request with a clear description of the change and what scenario it addresses

---

## Pull request process

1. Fork the repository
2. Create a branch named descriptively (`fix/ring-height-docs`, `feat/wifi-mqtt`, etc.)
3. Make your changes
4. Ensure all documentation stays consistent — if you change a dimension in `params.scad`, update the matching value in the design docs
5. Open a pull request with a summary of what changed and why
6. A maintainer will review and may request changes

---

## Consistency rules

This project maintains consistency between:

- `hardware/3d-models/source/params.scad` — the ground truth for all dimensions
- `docs/02-design/enclosure-design.md` — must match params.scad
- `docs/03-build/assembly-instructions.md` — part names must match BOM
- `bom/bill-of-materials.csv` — component IDs (E01, E02 …) must be consistent with assembly instructions
- `hardware/schematics/wiring-schematic.md` — must match relay wiring and GPIO assignments in `config.h`

If you change one, check all others. The `PROJECT_DECISIONS.md` log should record any significant design change.

---

## What we are looking for

Prioritised areas for contribution:

| Area | What's needed |
|------|--------------|
| Yield validation | Actual harvest weights from prototype builds |
| LED PPFD measurement | PAR meter reading at 10cm above tray with specified LED strips |
| Pump calibration data | Flow rate (mL/s) vs. reservoir head height |
| Alternative power configs | 5V USB-C input option; mains 12V adapter recommendations |
| Scaled-up version | 4-tray ring configuration documentation |
| Web UI | Optional WiFi + MQTT or web dashboard firmware extension |
| PCB design | Replace stripboard with a proper PCB layout |
| Translated docs | Documentation in languages other than English |

---

## Code of conduct

Be kind and constructive. This is a personal health-focused project — contributors come from a wide range of backgrounds. Assume good faith.

---

## Questions

Open a GitHub Discussion or an issue with the `question` label.
