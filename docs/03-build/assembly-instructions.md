# Assembly Instructions

**Phase:** 03 Build
**Status:** Complete
**Last Updated:** 2026-02-18

---

## About This Guide

This guide explains how to build the Microgreen Box from scratch. No previous electronics or growing experience is required. Every technical term is explained the first time it appears. Read each step fully before doing it.

**What you will build:** A self-contained growing device that automatically grows broccoli microgreens. It controls its own lights and watering schedule. You press a button once to start a grow, and a buzzer and LED tell you when the harvest is ready.

**Before starting this guide, confirm you have:**
- All electrical components (ordered per `bom/bill-of-materials.csv`)
- All consumables (seeds, coir pucks — ordered per `docs/03-build/parts-list-consumables.md`)
- All 3D-printed parts (see Section A below)
- All tools listed in Section B

**Estimated assembly time:** 6–8 hours, split across 3 days to allow waterproofing to cure.

> **Renders:** See `hardware/3d-models/renders/` for visual diagrams of each assembly stage.

---

## Section A: Getting the 3D-Printed Parts

The enclosure, trays, and brackets are all 3D-printed in PETG plastic. You can either print them yourself or order them from an online print service.

### What is PETG?

PETG (polyethylene terephthalate glycol) is a food-safe, moisture-resistant plastic commonly used for 3D printing. It is much more durable and heat-tolerant than PLA (the most common home 3D printing material). **All parts in this device must be printed in PETG — never PLA.** PLA softens in a warm vehicle and absorbs moisture over time, causing parts to warp.

### Option 1: Order from an Online Print Service

If you do not have a 3D printer, or you want higher quality parts, use an online service. Upload the STL files and they will print and ship the parts to you.

**Recommended services:**
- **Craftcloud** (craftcloud3d.com) — compares prices across many printers worldwide
- **Treatstock** (treatstock.com) — finds local print services near you
- **JLCPCB 3D Print** (jlcpcb.com) — very low cost; ships worldwide; 2–4 week delivery
- **PCBWay** (pcbway.com) — good quality; ships worldwide
- Local makerspaces — search "[your city] makerspace 3D printing"

**What to tell the service:**

| Setting | Value | Why |
|---------|-------|-----|
| Material | **PETG** | Required — water resistant, food safe, vehicle safe |
| Layer height | 0.2 mm | Balance of quality and print time |
| Wall count / perimeters | **4 walls** | Structural strength and water tightness |
| Top/bottom layers | **6 layers** | Minimises porosity on water-contact surfaces |
| Infill | **40%** for structural parts; **80%** for sub-trays and reservoir body | Higher infill = less water seepage |
| Supports | **None required** | All parts designed support-free |

**STL files:** Generate from source by running `make all` in `hardware/3d-models/`. Requires OpenSCAD 2021.01 or later (`sudo apt install openscad`).

**Parts to order:**

| File | Qty | Notes |
|------|-----|-------|
| `base_front.stl` | 1 | Base unit — front half |
| `base_rear.stl` | 1 | Base unit — rear half (reservoir + waste chamber) |
| `reservoir_lid.stl` | 1 | Reservoir lid (float switch gland pre-formed) |
| `waste_lid.stl` | 1 | Waste chamber snap-fit lid |
| `electronics_cover.stl` | 1 | Electronics bay cover |
| `pump_mount.stl` | 1 | Pump bracket |
| `ring_FL.stl` | 3 | Tray ring front-left quarter (×3 rings = 3 parts) |
| `ring_FR.stl` | 3 | Tray ring front-right quarter |
| `ring_RL.stl` | 3 | Tray ring rear-left quarter |
| `ring_RR.stl` | 3 | Tray ring rear-right quarter |
| `growing_tray.stl` | 3 | Growing tray (holds coir and seeds) |
| `sub_tray.stl` | 3 | Sub-tray (sealed water-retention tray, high infill) |
| `led_bracket.stl` | 3 | Adjustable LED grow strip holder |
| `tray_door.stl` | 3 | Front access door per tray level |
| `top_cap.stl` | 1 | Top cap with seed storage and handle |
| `seed_box_lid.stl` | 1 | Lid for seed storage compartment |
| `led_panel.stl` | 1 | Status LED panel insert |
| `manifold_3way.stl` | 1 | Water tube 1-to-3 splitter |
| `drip_emitter.stl` | 3 | Drip nozzle, one per tray (2 mm orifice) |
| `tube_clip.stl` | 12 | Tubing saddle clips |

**Approximate total material:** ~2.4 kg PETG
**Estimated cost from a print service:** $80–200 USD depending on service and delivery region.

### Option 2: Print Yourself

If you have a printer with at least a 200×200 mm print bed, all parts fit. The growing tray and sub-tray are larger (250×256 mm) and may need to be split further for smaller beds — see `docs/03-build/printing-instructions.md` for settings, part order, and bed-size handling. Total print time: approximately 65 hours.

---

## Section B: Tools and Hardware

**Tools required:**

| Tool | Purpose |
|------|---------|
| Screwdriver — Phillips #2 | Standard M3 screws |
| Screwdriver — small flat-blade | Relay screw terminals; buck converter adjustment screw |
| 2 mm hex key | M3 socket-head bolts |
| Pliers | Holding nuts; pressing magnets |
| Wire strippers | Stripping insulation from wire ends |
| Wire cutters | Cutting wire and silicone tubing |
| Soldering iron + solder | Attaching wires to components |
| Multimeter | Checking voltage and continuity before power-on |
| Helping hands (optional) | Holding small parts while soldering |
| Silicone applicator or old toothbrush | Spreading RTV sealant |
| 3 mm drill bit + hand drill | Clearing hinge holes if tight |
| Scissors | Cutting foam weatherstrip |
| Measuring tape or ruler | Setting LED height above tray |

**Additional hardware (not included in BOM):**

| Item | Qty | Purpose |
|------|-----|---------|
| M3×20 mm button-head bolt | 36 | Joining rings and base flanges (6 per joint × 6 joints) |
| M3×10 mm bolt | 20 | LED brackets, misc |
| M3×6 mm bolt | 12 | LED panel attachment |
| M3 hex nut | 40 | Captured nut sockets in flanges |
| M3×30 mm bolt | 9 | Door hinge pins (3 per door × 3 doors) |
| M5 heat-set insert | 4 | Vehicle mounting corners in base |
| 3 mm closed-cell foam weatherstrip | 2 m | Light-sealing ring flanges |
| 4×2 mm foam weatherstrip | 1 m | Door perimeter light seals |
| RTV silicone sealant | 1 tube | Waterproofing seams; ring assembly |
| O-ring, Ø40 mm × 2 mm cross-section | 1 | Reservoir lid water seal |
| Ø8×3.5 mm neodymium disc magnets | 6 | Door catches (2 per door) |
| CA glue (super glue) | 1 small bottle | Bonding door catch magnets |
| CR2032 coin cell battery | 1 | RTC (clock) module time backup |

---

## Section C: Waterproofing — Do This First (2 Days Before Assembly)

Some 3D-printed parts hold water inside the device. Even high-infill PETG can seep slowly through the layer seams. Parts that contain water must be coated inside with a waterproofing sealant before assembly.

### Which parts need waterproofing?

- **Inside the reservoir cavity** (the large chamber in `base_rear.stl`)
- **Inside the waste chamber** (the smaller chamber in `base_rear.stl`)
- **All three `sub_tray.stl` parts** (the sealed water-retention trays that sit below each growing tray)

### Which parts do NOT need waterproofing?

Growing trays (water drains through them intentionally), tray rings, doors, top cap, electronics bay, LED brackets.

### What you need for waterproofing

**XTC-3D epoxy coating** (by Smooth-On) is the recommended sealant. It is a two-part liquid epoxy that you mix and paint onto the inside of a print. It flows into the layer seams, seals the surface, and cures to a hard, food-safe coating. Available from Smooth-On distributors, Amazon, or 3D printing supply shops. **Alternatively:** Rust-Oleum Crystal Clear Enamel spray works on less critical surfaces.

- Mixing cups (small disposable cups)
- Disposable brushes (foam brushes work well)
- Nitrile gloves
- Well-ventilated area (the uncured epoxy fumes are unpleasant)

### Waterproofing procedure

**Step W1.** Put on gloves. Mix XTC-3D Part A and Part B at a **2:1 ratio by volume** (the label has measurements). Stir continuously for 60 seconds. You have about 10 minutes to apply before the mixture becomes too thick to brush.

**Step W2.** Using a brush, paint a thin, even coat over all interior surfaces of the reservoir cavity, waste chamber, and the interiors of all three sub-trays. The coat should be thin — XTC-3D self-levels. Thick coats form runs and drips.

**Step W3.** Leave each part horizontal. Do not move for at least 4 hours. The resin cures to handling strength in 4 hours and fully in 24 hours.

**Step W4.** After full cure (24 hours), apply a **second coat** exactly as above. Two thin coats are better than one thick coat.

**Step W5 — Water test:** After the second coat cures (another 24 hours), place each coated part on dry paper towels and fill with water. Leave for 24 hours. Check the paper towels — if completely dry, the seal is good. If damp anywhere, dry for 24 hours, apply a third coat to that area, cure again, and re-test before proceeding.

> **Common mistake:** Skipping the water test. A slow seep that is invisible after 1 hour becomes a visible drip after 12 hours. Always water-test before assembling electronics nearby.

---

## Step-by-Step Assembly

Steps are numbered sequentially throughout the guide.

---

### Step 1 — Set the Buck Converter to 5.0 V

**What is a buck converter?** A buck converter (also called a step-down converter) is a small circuit board that converts a higher voltage to a lower voltage. In this device it converts the 12 V power input down to 5 V, which the ESP32 microcontroller requires.

**What is an ESP32?** The ESP32 is the small computer that controls the entire device. It runs the firmware (the software that manages lights, watering, alarms, and schedules). It connects to everything via its GPIO (General Purpose Input/Output) pins — the rows of metal pins along its sides.

> **Critical warning:** If the voltage is higher than 5.1 V when you connect the ESP32, you may permanently damage it. Set the voltage before connecting anything to the output.

1. Identify the **buck converter** — a small green or blue circuit board approximately 22×17 mm, with a small brass adjustment screw on top and four pads or screw terminals (IN+, IN−, OUT+, OUT−).

2. Connect a 12 V power supply temporarily to the **input** of the buck converter only:
   - Red wire to IN+ (positive input)
   - Black wire to IN− (ground input)
   - Do not connect anything to the output yet.

3. Set your multimeter to **DC Voltage, 20 V range**. Touch the red probe to OUT+ and the black probe to OUT−.

4. While watching the multimeter reading, turn the small brass adjustment screw:
   - Clockwise = voltage increases
   - Counter-clockwise = voltage decreases
   - Adjust until the reading is exactly **5.0 V** (±0.05 V is acceptable).

5. Disconnect the 12 V supply. The buck converter is now set and ready to install.

---

### Step 2 — Remove the Relay Module JD-VCC Jumper

**What is a relay?** A relay is an electrically controlled switch. The ESP32 operates at 3.3 V with very little current — not enough to power grow lights or a pump directly. A relay uses a small electromagnetic coil to switch a much higher-power circuit on and off. When the ESP32 sends a signal to the relay, the coil pulls a metal contact arm, completing the power circuit to the load (LED strip or pump).

**What is the JD-VCC jumper and why remove it?** The relay module has two separate power rails on board:
- The **logic side** (receives control signals from the ESP32) — powered at 3.3 V
- The **coil side** (powers the electromagnetic coils that actually switch) — powered at 5 V

A small plastic jumper cap bridges these two rails together by default. With this jumper in place, the relay coils draw their power from the same rail as the ESP32. When multiple relays fire at once, the coil current (70–100 mA per relay) can cause the ESP32's voltage to dip, causing it to reset or malfunction.

> **Critical step:** Remove this jumper before installing the relay module. Once removed, the two sides are isolated by the opto-couplers on the board (opto-couplers are optical isolators that pass signals as light beams, preventing electrical interference between sides).

1. Locate the relay module — a blue board with 4 large black relay boxes and a row of 6 input pins on one side (labelled VCC, GND, IN1, IN2, IN3, IN4) and a separate pair of pins nearby labelled **JD-VCC** and **VCC**.

2. Find the **jumper cap** — a small plastic rectangle bridging the two adjacent pins labelled JD-VCC and VCC. It may be blue, yellow, or black.

3. Grip the jumper cap with your fingernails or pliers and **pull it straight off**. Keep it in case you need to identify it later, or discard it.

4. Confirm the two pins are now bare (no cap connecting them). This is correct.

> **Common mistake:** Forgetting this step. The device will appear to work but will randomly reset when multiple relays activate. Always remove the jumper first.

---

### Step 3 — Join the Base Unit Halves

**What is the base unit?** The base is the bottom section of the device. It contains the water reservoir (the tank that stores water for watering), the waste chamber (a sealed compartment that collects any overflow water), and the electronics bay (a dry compartment for the circuit boards).

**Parts:** `base_front.stl`, `base_rear.stl`
**Hardware:** 6× M3×20 mm bolts, 6× M3 hex nuts, RTV silicone sealant, soldering iron, 4× M5 heat-set inserts

1. Lay both halves on a flat surface with the flat split faces facing up.

2. Examine the **rear half**: you will see the large reservoir cavity and smaller waste chamber cavity — both already waterproofed and water-tested in Section C.

3. Apply a continuous bead of **RTV silicone** along the flat split face of the rear half, specifically along the entire edge of the reservoir and waste chamber cavities where they cross the split line. Use the applicator to press the bead into the joint face.

4. Press the two halves together, aligning all bolt holes.

5. Insert **6× M3 hex nuts** into the rectangular nut pockets on the rear half (visible along the joint face).

6. Thread **6× M3×20 mm bolts** through the front half and into the hex nuts in the rear half. Tighten firmly — snug, but do not strip the plastic.

7. Wipe away excess RTV from the exterior with a damp cloth.

8. **Wait at least 2 hours** before moving the base. RTV silicone needs 24 hours to fully cure — do not fill with water for 24 hours.

#### Sub-step: Install vehicle mounting inserts

9. Locate the four recessed circular pockets on the underside of the base (one at each corner). These accept M5 heat-set inserts for bolting the device to a vehicle surface.

10. Heat your **soldering iron to approximately 200°C** (a medium setting). Place one **M5 heat-set insert** (a small brass threaded cylinder) flat on top of a pocket. Press the soldering iron tip gently onto the insert. The surrounding plastic will melt and the insert will sink in. Stop when the insert top sits flush with the surface.

11. Remove the iron. Wait 1 minute for the plastic to re-solidify before moving to the next corner. Repeat for all 4 corners.

---

### Step 4 — Install the Float Switch in the Reservoir Lid

**What is a float switch?** A float switch is a water level sensor. The ZP2508 is a small cylinder about 25 mm long containing a magnetic reed switch and a small ball that floats on water. When the water level drops, the ball drops with it, which causes the switch contacts to change state, signalling the device that the reservoir needs refilling.

**What does NC mean?** NC stands for Normally Closed. A normally-closed switch has its two contacts touching (allowing electricity to flow) when the switch is in its natural resting position — in this case, when the float ball is at the bottom (low water). When water rises and lifts the float, the contacts separate (open), stopping the flow of electricity. This means: **low water = contacts closed = ESP32 reads LOW = alarm triggered.**

**Component:** ZP2508 NC float switch
**Part:** `reservoir_lid.stl`
**Hardware:** O-ring Ø40 mm × 2 mm, cable gland nut (part of ZP2508)

1. Thread the **float switch body** down through the 6 mm gland hole in the reservoir lid from the top. A gland is a fitting that allows a component to pass through a wall and seals around it to prevent leaks.

2. Tighten the **gland nut** from below the lid until it is snug — the rubber inside the gland compresses around the switch body and creates a water-tight seal.

3. The float ball should hang freely below the lid, pointing downward into the reservoir when the lid is fitted.

4. Seat the **O-ring** into the groove on the underside of the reservoir lid.

5. Thread the **reservoir lid** onto the fill-port boss (the threaded collar on the top of the base rear) until snug. The O-ring compresses and seals the lid to the base.

6. Route the **two float switch wires** through the cable pass-through slot in the base down into the electronics bay. You will connect them to the ESP32 in Step 9.

---

### Step 5 — Build the Electronics Board

**What is a stripboard?** A stripboard (also called Veroboard) is a small circuit board with rows of copper tracks printed on it. You solder components to it to build circuits. Where you need to break the copper track (to prevent connections you do not want), you use a small drill or tool to cut through the track.

**Components:** Buck converter (MP1584EN), inline 5 A fuse holder + 5 A fuse, reverse polarity protection (AO3401 P-channel MOSFET, or simpler: 1N5400 diode), 5.5/2.1 mm DC barrel jack

1. Mount the **stripboard** in the electronics bay using M3×8 mm standoff bolts or double-sided foam tape. The electronics bay is the compartment in the front-left section of the base.

2. **Reverse polarity protection:** If someone connects the 12 V supply backwards, this component prevents damage to the electronics.
   - If using the **1N5400 diode** (recommended for beginners): solder it in series on the +12 V input line with the stripe (cathode, the end marked with a line or band) pointing toward the rest of the circuit. Current flows in the correct direction; if reversed, the diode blocks it.
   - If using the **AO3401 MOSFET**: see `hardware/schematics/wiring-schematic.md` for pin orientation.

3. Solder the **5 A inline fuse holder** in series on the +12 V line, downstream of the polarity protection component. Insert a 5 A blade fuse into the holder.

4. Solder the **buck converter** input pads to the 12 V bus: red (positive) to the + track, black (negative/ground) to the − track. The buck converter output (5.0 V, set in Step 1) will power the ESP32 and relay coils.

5. Install the **DC barrel jack** in the pre-printed hole on the left outer wall of the base. Thread the panel-mount nut onto the exterior of the jack and tighten with pliers. Solder 20 AWG (the thicker) red and black leads from the jack to the stripboard input.

> **Polarity on barrel jacks:** The centre pin of a standard 5.5/2.1 mm barrel jack is **positive (+12 V)**. The outer sleeve is negative (ground). Verify with your multimeter before connecting anything downstream.

---

### Step 6 — Mount the ESP32 and RTC Module

**What is the RTC module?** RTC stands for Real-Time Clock. The DS3231 module is a dedicated clock chip that keeps the current time even when the main power is off, using a small CR2032 coin cell battery (the same type used in watches and key fobs). The device uses this clock to turn lights on at 06:00 and off at 20:00, and to run the watering schedule at 07:00 and 19:00 each day.

**What is I2C?** I2C (pronounced "I-squared-C") is a communication protocol that lets multiple devices share just two wires — SDA (data) and SCL (clock). Both the RTC module and the optional OLED display use I2C, connected to the same two ESP32 pins.

**Components:** ESP32-WROOM-32 dev board, DS3231 RTC module, CR2032 coin cell

1. Press a **CR2032 coin cell** into the holder on the DS3231 RTC module. The flat positive (+) side faces up.

2. Mount the **ESP32 dev board** on the stripboard using the provided male pin headers (the rows of metal pins). The ESP32 should sit elevated above the stripboard on the pin headers, with all pins accessible.

3. Connect the **DS3231 RTC module** to the ESP32 using 24 AWG (thinner signal) wire:

   | DS3231 pin | Connects to | Note |
   |-----------|-------------|------|
   | VCC | ESP32 3.3V pin | 3.3V only — not 5V |
   | GND | GND | Common ground |
   | SDA | ESP32 GPIO 21 | I2C data line |
   | SCL | ESP32 GPIO 22 | I2C clock line |

4. Leave enough wire slack to comfortably close the electronics cover later. Tuck wires along the bay walls.

---

### Step 7 — Mount and Wire the Relay Module

**Components:** 4-channel relay module (jumper already removed in Step 2)

1. Mount the **relay module** in the front-right area of the base using M3×8 mm bolts through its mounting holes.

2. Connect **power** to the relay module:

   | Relay module pin | Wire to | Why |
   |-----------------|---------|-----|
   | VCC | ESP32 3.3V | Logic power — signals only |
   | GND | GND (common ground) | Shared ground |
   | JD-VCC | 5V from buck converter output | Coil power — isolated from logic |

   > These must be two separate connections. VCC goes to 3.3V; JD-VCC goes to 5V. Do not connect both to the same voltage. This is what the removed jumper was doing — you are now making this connection explicitly with separate wires.

3. Connect the **control inputs** (IN1–IN4) to the ESP32 GPIO pins:

   | Relay pin | ESP32 GPIO | What it controls |
   |----------|-----------|-----------------|
   | IN1 | GPIO 26 | LED grow strip — Tray A (bottom ring) |
   | IN2 | GPIO 27 | LED grow strip — Tray B (middle ring) |
   | IN3 | **GPIO 25** | LED grow strip — Tray C (top ring) |
   | IN4 | **GPIO 13** | Peristaltic pump |

   > **Important:** GPIO 25 (not GPIO 14) controls Tray C. GPIO 13 (not GPIO 12) controls the pump. GPIOs 14 and 12 are reserved for the ESP32's internal boot process and must not be used for relay control.

4. Wire the **relay output contacts** (the high-power switching side). For each channel, use 20 AWG red and black wire:
   - +12 V bus → relay **COM** (common) contact of that channel
   - Relay **NO** (Normally Open) contact → positive (+) wire of the LED strip or pump
   - Negative (−) wire of the LED strip or pump → GND directly

   > **What is NO?** Normally Open means the contact is open (no connection) when the relay is off. When the relay activates, the contact closes and allows current to flow. This means loads are OFF when the ESP32 is not signalling — correct and safe behaviour.

   > **Active-LOW:** This relay module activates when the control pin is pulled LOW (0V by the ESP32). ESP32 pin LOW → relay ON → load switches ON. The firmware is written to match this.

---

### Step 8 — Install Status Indicators

**Components:** 4× 3 mm LEDs (1 green, 1 yellow, 2 red), 4× 330Ω resistors (orange-orange-brown stripes), optional active buzzer, 1× 100Ω resistor (brown-black-brown stripes)

**What is a current-limiting resistor?** LEDs burn out if too much current flows through them. A resistor limits the current to a safe amount. The 330Ω resistors used here limit current to about 10 mA from a 3.3V GPIO pin — bright enough to see clearly without damaging the LED.

1. For each LED, solder a **330Ω resistor** to the longer leg (the positive leg, called the anode). Cover the solder joint with a small piece of heat-shrink tubing and shrink it with the soldering iron. The shorter leg (cathode, negative) connects to GND.

2. Connect each LED to the ESP32:

   | LED colour | ESP32 GPIO | Meaning when lit |
   |-----------|-----------|-----------------|
   | Green | GPIO 18 | System OK (blinks slowly as heartbeat) |
   | Yellow | GPIO 19 | Reservoir water level is low — refill needed |
   | Red (first) | GPIO 5 | Tray A is ready to harvest |
   | Red (second) | GPIO 17 | Tray B or Tray C is ready to harvest |

3. Run the LED wires up through the ring cable channels. They will connect to the status LED panel in the top cap in Step 15.

4. **Buzzer (optional):** Connect the positive pin of the active buzzer to ESP32 GPIO 16 through a 100Ω resistor. Connect the negative pin to GND. An active buzzer contains its own oscillator — it makes a tone when powered and needs no extra signal.

---

### Step 9 — Wire the Float Switch

1. Locate the two wires from the **ZP2508 float switch** routed into the electronics bay in Step 4. The wires are identical — either can connect to either terminal.

2. Connect one wire to **ESP32 GPIO 33**.

3. Connect the other wire to **GND**.

4. The firmware configures GPIO 33 as INPUT_PULLUP (the ESP32 internally connects a weak resistor pulling this pin to 3.3V):
   - **Normal (water present):** Float ball lifted → NC contacts open → GPIO 33 = 3.3V (HIGH) → no alarm
   - **Water low:** Float ball drops → NC contacts close → GPIO 33 connected to GND → LOW → alarm triggers

> **Fail-safe behaviour:** If the float switch wire breaks or disconnects, GPIO 33 is no longer pulled to GND, so it reads HIGH — no false alarm. The alarm only activates when water is genuinely low.

---

### Step 10 — Install Moisture Sensors

**What is a capacitive moisture sensor?** Each growing tray has a sensor that measures how moist the coir is. It works by detecting the electrical capacitance of the material around its probe — wet coir has a different capacitance than dry coir. The sensor outputs a voltage that the ESP32 converts to a moisture percentage.

**Why capacitive, not resistive?** Older resistive moisture sensors pass a small current through the growing medium, which causes the sensor to corrode over months. Capacitive sensors have no exposed metal contacts in the growing medium and last much longer.

**Components:** 3× Capacitive Soil Moisture Sensor V1.2 (a small circuit board with a long flat probe, approximately 90×20 mm)

1. Connect each sensor to the ESP32 using 24 AWG wire:

   | Sensor | Sensor pin | ESP32 / board connection |
   |--------|-----------|--------------------------|
   | Tray A sensor | VCC | 3.3V (not 5V) |
   | Tray A sensor | GND | GND |
   | Tray A sensor | AOUT | **GPIO 34** |
   | Tray B sensor | VCC | 3.3V |
   | Tray B sensor | GND | GND |
   | Tray B sensor | AOUT | **GPIO 35** |
   | Tray C sensor | VCC | 3.3V |
   | Tray C sensor | GND | GND |
   | Tray C sensor | AOUT | **GPIO 32** |

   > **Note on GPIO 34 and 35:** These are input-only pins on the ESP32. They can only read voltages — they cannot output signals or drive LEDs. This is ideal for sensors.

   > **Use 3.3V, not 5V:** These sensors work at 3.3V. Connecting to 5V may damage them.

2. Route each sensor cable up through the ring cable channels to the corresponding tray level. Leave 15 cm of slack at the tray end so the sensor can be positioned in the coir.

3. The sensors will be inserted into the coir when trays are seeded. For now, clip the sensor cables along the ring walls with `tube_clip.stl` and leave the probe ends coiled and stored.

> **Calibration required:** After assembly and before trusting the moisture readings, calibrate the sensors per `docs/04-software/installation-guide.md` Step 10. The default values are approximate.

---

### Step 11 — Mount the Pump and Route Tubing

**What is a peristaltic pump?** A peristaltic pump moves liquid by squeezing a flexible tube with rollers. The liquid never touches the pump mechanism — only the inside of the tube. This design means the pump works in any orientation (including tilted in a vehicle), can be run dry without damage, and can pump food-grade liquids safely.

**Parts:** `pump_mount.stl`, `manifold_3way.stl`, 3× `drip_emitter.stl`, 12× `tube_clip.stl`
**Component:** 12V DC peristaltic pump, silicone tubing

1. Bolt the **peristaltic pump** to the `pump_mount.stl` bracket using the pump's built-in M3 mounting holes.

2. Bolt the **pump bracket** to the floor of the front-right area of the base using 4× M3×10 mm bolts.

3. Connect the **pump power leads** to relay module Channel 4 load contacts:
   - Pump + lead (red) → relay CH4 NO contact
   - Pump − lead (black) → GND

4. Cut a piece of silicone tubing (~150 mm long) and push one end onto the **reservoir outlet barb** on the base (a small tube fitting near the reservoir base). Push the other end onto the **pump inlet**.

5. Push the **3-way manifold** (`manifold_3way.stl`) onto the pump outlet barb with a short piece of tubing.

6. Cut three supply tube runs — long enough to reach from the manifold to each tray level. Route each tube:
   - Up through the Ø7 mm hole in the base top face
   - Up through the ring interior along the rear wall
   - To the drip port hole at the rear of the corresponding tray level

7. Secure the tubing every 50 mm with `tube_clip.stl` saddle clips fixed with 2.5 mm self-tap screws.

8. Push a **drip emitter** (`drip_emitter.stl`) onto the end of each supply tube at the tray-level drip port. The 2 mm orifice in the emitter limits flow to approximately 25 mL per pump event per tray.

9. **Waste drain tubing:** Cut three waste tube runs and connect from each sub-tray's rear drain fitting down through the ring interiors to the waste chamber inlet port on the base top. Secure with clips as above.

> **Tubing tip:** Silicone tubing is stiff when cold. Briefly dipping the end in boiling water for 5 seconds softens it and makes it much easier to push onto barbs.

---

### Step 12 — Assemble and Stack Tray Rings

Each tray level is a ring built from four L-shaped quarter-section pieces. This section assembles all three rings and stacks them.

**Parts (per ring):** `ring_FL.stl`, `ring_FR.stl`, `ring_RL.stl`, `ring_RR.stl`
**Hardware (per ring):** RTV silicone, 8× M3×20 mm bolts, 3 mm foam weatherstrip

#### Assemble each of the three rings (repeat × 3):

1. Lay the four quarter-sections (FL=front-left, FR=front-right, RL=rear-left, RR=rear-right) on a flat surface arranged in their correct positions, flanges facing down.

2. Apply a thin bead of **RTV silicone** along each of the four vertical seam faces where the quarters join.

3. Push the four quarters together. Thread **2× M3×20 mm bolts** through each seam boss (there are 4 seam locations, 2 bolts each = 8 bolts per ring). Tighten uniformly.

4. Apply **3 mm closed-cell foam weatherstrip** to the inner face of both the top flange and bottom flange of the assembled ring. This foam compresses between levels when stacked, creating a light seal that prevents light from one ring leaking into the ring below and disrupting the germination blackout period.

   > **Passive ventilation slots and insect screens:** Each assembled ring has two **25×8mm vent slots** near the top of the front and rear walls, each fitted with a removable slide cover. Before stacking the rings, fit an insect screen patch over each slot opening:
   >
   > **Vent slot insect screen installation (do this before stacking):**
   > 1. Cut 6 patches of fiberglass insect screen mesh (E34) to **27×10mm** each (slightly wider and taller than the slot so the edges are captured).
   > 2. Apply a thin bead of **RTV silicone** around the perimeter of each vent slot opening on the **interior** wall face.
   > 3. Press one mesh patch over each slot opening and hold flat for 60 seconds. The mesh overlaps the slot edges by ~1mm all round.
   > 4. Allow RTV to cure for 30 minutes before stacking. The screen is now permanent — it stays in place whether the slide cover is in or out.
   >
   > **Operation:** Leave slide covers in place for normal operation — they maintain the light seal. Remove slide covers on one or more rings when ventilation is needed; the mesh provides continuous insect protection even with covers removed. The mesh pore size (~1.2mm) blocks fungus gnats, shore flies, and other common microgreen pests while allowing full airflow.

5. Wait 30 minutes for RTV to set before stacking.

6. Check the interior: you should see two pairs of horizontal ledge rails on the inner walls:
   - **Lower ledge rails** at 20 mm from the ring floor — these support the sub-tray
   - **Upper ledge rails** at 64 mm from the ring floor — these support the growing tray

#### Stack the rings:

7. Place **ring 1** (Tray A, bottom) on the base top face. Align the 6× bolt holes in the ring bottom flange with the holes in the base top face.

8. Thread **6× M3×20 mm bolts** through the ring flange holes into captured hex nuts in the base top face. Tighten uniformly.

9. Stack **ring 2** (Tray B, middle) on top of ring 1. Use 6× M3×20 mm bolts through the ring flange joint.

10. Stack **ring 3** (Tray C, top) on ring 2. Use 6× M3×20 mm bolts.

11. After each joint, confirm the foam weatherstrip is compressed slightly between flanges — if the foam is not compressing, the rings may not be fully seated. Press down firmly while tightening.

---

### Step 13 — Install Sub-Trays and Growing Trays

**What is the sub-tray?** The sub-tray is a sealed water-retention tray that sits below the growing tray in each ring level. Water drains through the growing tray's drain holes into the sub-tray, keeping the coir moist from below. An overflow port on the sub-tray rear wall connects to the waste drain tube, preventing overflow.

**What is the growing tray?** The growing tray holds the coir and seeds. Four 8 mm drain holes in its base allow water to drip through into the sub-tray below. The growing tray sits elevated above the sub-tray on ledge rails, allowing airflow underneath.

**Parts:** `sub_tray.stl` (×3), `growing_tray.stl` (×3)

> Pre-requisite: Sub-trays must have been waterproofed and water-tested per Section C.

1. Slide each **sub-tray** into its ring level from the front door aperture, onto the lower ledge rails (20 mm from floor). It slides horizontally like a drawer.

2. Connect the **waste drain tube** to the rear drain fitting of each sub-tray (push-fit Ø8.5 mm barb). Route the tube as established in Step 11.

3. Slide each **growing tray** into its ring level onto the upper ledge rails (64 mm from floor). The growing tray sits above and separated from the sub-tray.

4. Verify that the growing tray's 4× drain holes sit above the interior of the sub-tray below — not above the ledge rails. Water must drip into the sub-tray interior.

> The moisture sensors will be inserted into the coir when you seed each tray for the first time. Leave the sensor probes coiled in each ring level for now.

---

### Step 14 — Install LED Grow Strips

**What is a full-spectrum grow strip?** A grow strip is an LED strip light with the correct wavelengths for plant growth — it includes blue, red, and green wavelengths similar to sunlight. "Full spectrum" means it mimics natural daylight, which is more effective for plant growth than a single-colour light.

**Parts:** `led_bracket.stl` (×3)
**Components:** 3× sections of 12 V full-spectrum LED grow strip, each cut to 250 mm

1. Mount one **LED bracket** on the rear inner wall mounting rail of each ring using 2× M3×10 mm bolts through the bracket's slotted holes (the slot allows height adjustment).

2. Set each bracket height so the **LED strip will be approximately 100 mm above the growing tray surface** when installed. Measure from the tray surface (with the growing tray in place) up to where the LED strip will sit.

3. Cut the LED grow strip into three **250 mm sections** at the cut marks printed on the strip (usually every 25–50 mm between LEDs). Use scissors or a sharp knife. Always cut exactly on the marked cut line — cutting through an LED ruins that section.

   > **Polarity:** LED strips only light up in one direction. Look for a + and − marking near the cut end. The + wire connects to the relay NO contact; the − wire connects to GND.

4. Press each **LED strip** into the bracket channel and secure with 2× M3×6 mm bolts.

5. Connect LED leads via the JST-XH 2-pin connector (or solder if connectors are not supplied):
   - Tray A strip (bottom ring) + → relay CH1 NO contact
   - Tray A strip − → GND
   - Tray B strip (middle ring) + → relay CH2 NO contact
   - Tray C strip (top ring) + → relay CH3 NO contact

6. Route LED wires through the wire pass-through slot at the front of each ring wall, running down to the relay module.

---

### Step 15 — Install Front Doors

**Parts:** `tray_door.stl` (×3), 6× Ø8×3.5 mm neodymium disc magnets, CA glue

1. Press **4×2 mm foam weatherstrip** into the groove running around the perimeter of the inside of each door. The foam should sit proud of the door face by about 1 mm — it will compress when the door is shut.

2. **Hang each door** by aligning the door's hinge knuckles (the semi-circular loops along the door's left edge) with the matching knuckles on the ring aperture.

3. Insert **hinge pins:** push an M3×30 mm bolt down through all the stacked knuckles (door and ring alternated). Thread an M3 nut on the bottom and tighten to retain the pin.

4. Test the door: it should swing open approximately 90° without binding. If it binds, enlarge the hinge hole slightly with a 3 mm drill bit and try again.

5. **Install door catch magnets:**
   - Press one magnet into the pocket on the ring aperture edge
   - Press the second magnet into the matching pocket on the door edge
   - Before gluing, close the door and verify the magnets attract each other. If they repel, flip one magnet over.
   - Once orientation is confirmed, apply a small drop of CA glue around the rim of each magnet to retain it.

6. Close the door. The magnets should hold it shut, and the foam weatherstrip should compress slightly around the perimeter.

---

### Step 16 — Install the Top Cap

**Parts:** `top_cap.stl`, `led_panel.stl`, `seed_box_lid.stl`
**Components:** SSD1306 OLED display (optional but recommended), 4× status LEDs with pre-attached resistors, buzzer (optional)

**What is the OLED display?** OLED stands for Organic Light-Emitting Diode. The SSD1306 is a small 0.96" screen (about 25×13 mm) that the device uses to show the current time, tray day numbers, water status, and moisture readings. It connects via I2C and is optional — the device functions fully without it, with status information available through the indicator LEDs.

1. Snap the **LED panel** (`led_panel.stl`) into the status panel recess in the top cap face.

2. Press the 4× indicator **LEDs** into the Ø3.5 mm holes in the LED panel:
   - Hole 1: Green LED (GPIO 18 via 330Ω) — heartbeat / system OK
   - Hole 2: Yellow LED (GPIO 19 via 330Ω) — water low
   - Hole 3: Red LED (GPIO 5 via 330Ω) — Tray A harvest ready
   - Hole 4: Red LED (GPIO 17 via 330Ω) — Tray B or Tray C harvest ready

   Route each wire down through the ring cable channels to the ESP32.

3. **OLED display (optional):** Seat the SSD1306 module into the OLED window recess. Connect via a 4-wire JST-XH cable to the ESP32:

   | OLED pin | Connects to |
   |---------|-------------|
   | VCC | 3.3V |
   | GND | GND |
   | SDA | ESP32 GPIO 21 (shared I2C bus with RTC) |
   | SCL | ESP32 GPIO 22 (shared I2C bus with RTC) |

   > Both the RTC module and OLED share the same I2C bus on GPIO 21 and 22. This is normal — I2C is designed for multiple devices on one bus, each with a unique address.

4. Install the optional **buzzer** in the top cap buzzer pocket. Connect + to GPIO 16 via 100Ω resistor; − to GND.

5. Route all wires from the top cap components down through the ring cable channels to the ESP32 in the base.

6. **Stack the top cap** on ring 3: align the 6× flange bolt holes and use 6× M3×20 mm bolts.

7. Install the seed storage box and its lid in the top cap seed compartment.

---

### Step 16a — Install Ventilation Fan and Switch (Optional but Recommended)

**What this step does:** Adds a 40mm exhaust fan to the top cap top surface and a toggle switch on the top cap front face. The fan exhausts humid air upward out of the growing column, reducing mold risk. It is completely manual — no relay, no firmware — just a toggle switch in series with the fan.

**Components:** 40mm 12V brushless fan (E30), SPST mini toggle switch (E31), 40mm fan guard/grill (E32), 40mm PC fan dust filter (E33)
**Hardware:** 4× M3×12mm bolts, 4× M3 hex nuts
**Wire:** 30cm 20AWG red wire, 30cm 20AWG black wire

> **Skip this step** if you are building without the fan. The top cap functions fully without it — the pre-printed exhaust hole will simply remain open (or you can cover it with a small PETG cap printed from a short cylinder).

#### Fan installation:

1. Orient the **40mm fan** with the **label side** (which shows the model number and rotation arrow) facing **downward into the cap** — this is the **inlet** side. The smooth side with the hub faces up and exhausts upward.

2. Align the fan's four corner bolt holes with the **4× M3 mounting holes** in the top cap top surface (at the corners of a 32×32mm square centred on the exhaust hole).

3. Lower the fan into the **2mm recess** in the top cap top surface. The fan body should sit flush or slightly recessed.

4. Insert **4× M3×12mm bolts** through the fan corner holes from above, into the M3 hex nuts below. Tighten with a screwdriver until snug — do not overtighten (PETG will crack if the bolt is overtightened).

5. Place the **40mm foam dust filter** (E33) over the fan's top (exhaust) face, centred on the fan frame. Then snap the **fan guard/grill** (E32) over it, sandwiching the filter against the fan. The guard retains the filter and prevents blade contact; the filter blocks insects (including fungus gnats) from entering the column through the fan hole when the fan is not running.

#### Switch installation:

6. Insert the **toggle switch body** into the **6.5mm panel-cut hole** on the top cap front face (right side of the front face, approximately 25mm from the right edge).

7. From inside the cap, thread the **toggle switch retaining nut** onto the switch body and tighten until the switch flange presses against the outer face.

8. The switch should toggle cleanly between ON and OFF positions with a positive click.

#### Wiring:

9. Connect the fan circuit with 20AWG wire:

   ```
   12V bus (stripboard) ──► 20 AWG red ──► SW2 input terminal
   SW2 output terminal ──► 20 AWG red ──► Fan red (+) wire
   Fan black (−) wire ──► 20 AWG black ──► GND bus (stripboard)
   ```

   > The toggle switch is wired in the positive (red) lead. When the switch is ON, 12V reaches the fan and it spins. When OFF, the fan is completely unpowered.

10. Route the wiring down through the ring cable channels to the stripboard in the electronics bay. Secure with tube clip saddles or cable ties every 100mm.

11. **Test:** With the device powered (12V connected), flip the toggle switch to ON. The fan should spin immediately and you should feel airflow from the top. Flip to OFF — fan stops. If the fan does not spin, check polarity and the switch wiring.

---

### Step 17 — Pre-Power Electrical Check

Complete all of the following before connecting any 12 V power supply.

1. **Fuse check:** Confirm the 5 A blade fuse is installed in the inline fuse holder.

2. **Buck converter voltage:** With a multimeter set to DC Voltage, confirm the buck converter output reads 5.0 V before the ESP32 is connected. If needed, reconnect the 12 V supply temporarily and re-adjust.

3. **Relay module check:**
   - VCC pin connected to 3.3V (not 5V)
   - JD-VCC pin connected to 5V from the buck converter
   - GND connected to common ground
   - JD-VCC jumper is absent (removed in Step 2)

4. **GPIO wiring check:** Trace each signal wire from the ESP32 GPIO pin to confirm:
   - IN1 → GPIO 26 (LED Tray A)
   - IN2 → GPIO 27 (LED Tray B)
   - IN3 → GPIO 25 (LED Tray C) — not GPIO 14
   - IN4 → GPIO 13 (Pump) — not GPIO 12
   - Float switch: one wire to GPIO 33, one wire to GND
   - Moisture sensor A: AOUT to GPIO 34, VCC to 3.3V
   - Moisture sensor B: AOUT to GPIO 35, VCC to 3.3V
   - Moisture sensor C: AOUT to GPIO 32, VCC to 3.3V
   - Green LED: GPIO 18 via 330Ω
   - Yellow LED: GPIO 19 via 330Ω
   - Red LED A: GPIO 5 via 330Ω
   - Red LED B/C: GPIO 17 via 330Ω
   - Buzzer: GPIO 16 via 100Ω
   - RTC SDA: GPIO 21; RTC SCL: GPIO 22
   - OLED SDA: GPIO 21 (shared); OLED SCL: GPIO 22 (shared)

5. **Continuity check:** Set multimeter to continuity mode (beeps when touching). Check that there is no short circuit between the +12V bus and GND. This catches wiring errors before they blow the fuse or damage components.

6. **Polarity check:** Trace every red wire to confirm it connects to a positive terminal. Trace every black wire to confirm it connects to ground.

7. If all checks pass, connect the 12 V power supply. The green LED should illuminate. The OLED (if installed) should show startup text within 2 seconds.

---

### Step 18 — Flash Firmware and Set the Clock

See `docs/04-software/installation-guide.md` for the full step-by-step guide.

**Summary:**

1. On your computer, install **Arduino IDE 2.x**.
2. Add ESP32 board support (paste the Espressif URL into Arduino IDE Preferences → Additional Board URLs).
3. Install three libraries: **RTClib**, **Adafruit GFX Library**, **Adafruit SSD1306**.
4. Open `software/firmware/microgreen_controller/microgreen_controller.ino`.
5. Select Board: **ESP32 Dev Module**; select the correct USB port.
6. Click **Upload**. The firmware compiles and flashes to the ESP32.
7. Open **Serial Monitor** at **115200 baud**.
8. Find the current Unix timestamp at [https://www.unixtimestamp.com](https://www.unixtimestamp.com). Type `T` followed immediately by the number (e.g., `T1739836800`) and press Enter. The device confirms the time is set.
9. Type `S` and press Enter to read the status dump. Confirm the time is correct.

> **What is a Unix timestamp?** It is a number representing the number of seconds since 1 January 1970. It is a universal way to communicate time precisely. The device converts this to a human-readable date and time internally.

---

### Step 19 — Water Fill and Leak Test

1. Remove the **reservoir lid** by unscrewing it. Pour **2 litres of clean tap water** into the reservoir. Replace and tighten the lid.

2. Set the device on dry paper towels. Leave for **24 hours** undisturbed.

3. Inspect the paper towels. If completely dry, all reservoir seals are good — proceed.

4. If the paper towels are damp anywhere:
   - Drain the reservoir (unscrew the lid and carefully tilt the base over a sink)
   - Leave to dry for 24 hours
   - Apply another coat of XTC-3D to the suspect seam inside the reservoir
   - Cure for 24 hours
   - Refill and re-test

5. **Manual pump test:** With the reservoir filled, the device powered, and the serial monitor open, temporarily add `run_pump(true);` to the top of `loop()` in `microgreen_controller.ino`, re-flash, and observe whether water is delivered from all three drip emitters into each tray level. Confirm all three drip emitters flow. Then remove the test line and re-flash the final firmware.

> See `docs/04-software/installation-guide.md` Step 11 for the full pump calibration procedure.

---

### Step 20 — Seed Your First Tray

You will only seed Tray A (bottom ring) today. Trays B and C are seeded 3 and 6 days later, creating a staggered rotation so you harvest one tray every 3 days instead of three trays all at once.

1. Expand one **compressed coir puck**: place it in a bowl and pour 300–400 mL of water over it. Wait 5 minutes. It will expand from a compressed disc to about 8× its original volume. Break it apart with your fingers until it is loose and fluffy. It should feel like slightly damp compost, not soggy.

2. Spread the **expanded coir** across the bottom of the Tray A growing tray to approximately **2 cm depth**. Spread it evenly — thin spots will dry out faster.

3. **Soak the seeds:** Measure 12–15 g of broccoli microgreen seeds (about 1.5 tablespoons). Place in a small glass, cover with 50 mL of cool water, and leave for **4–8 hours** (soak overnight if convenient). The seeds absorb water and become slightly sticky and swollen — this is correct.

4. After soaking, drain the seeds through a fine-mesh strainer. Spread them **evenly** over the coir surface in a single layer. Every part of the coir surface should have seeds, but they should not pile up or clump.

5. Slide the **growing tray** into Tray A's ring level and push the ring door closed.

6. Push the **moisture sensor probe** for Tray A gently into the coir at one corner of the tray, about 2 cm deep. Do not bend the probe — it will crack.

7. **Press the BOOT button** on the ESP32 once. This is the button labelled "BOOT" or "IO0" on the ESP32 board — typically the button nearest the USB connector.
   - **Three slow green LED flashes** = Tray A seeded successfully ✓
   - **Five rapid red flashes** = all trays are already active (unexpected on first use — check tray states via serial `S` command)
   - The OLED will display: `A: D00 germinating`

8. **Days 0–2:** The lights for Tray A will remain **off** automatically. This is the germination blackout — broccoli seeds germinate best in darkness. Leave the door closed.

9. **Day 3:** Lights will turn on automatically at 06:00. You should see the grow strip glow through the door.

10. **Days 3 and 6:** Seed Trays B and C by repeating Steps 20.1–20.7 for each tray (press BOOT once per tray, in order B then C).

11. **Day 8 (from Tray A seeding):** The red LED for Tray A illuminates and the buzzer sounds once. Tray A is ready to harvest. See `docs/04-software/user-manual.md` for harvesting and cleaning instructions.

---

## Completion Checklist

Before declaring the device ready for operation, confirm every item:

**Waterproofing and sealing:**
- [ ] Reservoir interior — XTC-3D coated, two coats, 24h water test passed
- [ ] Waste chamber interior — XTC-3D coated
- [ ] All three sub-trays — XTC-3D coated, two coats, 24h water test passed
- [ ] Base unit halves joined with M3 bolts and RTV silicone on water-zone seam
- [ ] M5 heat-set inserts installed at 4 base corners

**Reservoir:**
- [ ] O-ring seated in reservoir lid groove
- [ ] ZP2508 float switch body threaded through lid gland, gland nut tightened
- [ ] Reservoir lid fitted and snug on fill-port boss
- [ ] Float switch wires routed to electronics bay

**Power management:**
- [ ] Buck converter output confirmed at 5.0V before ESP32 connection
- [ ] DC barrel jack installed in left outer wall
- [ ] 5A fuse installed in inline fuse holder
- [ ] Reverse polarity protection installed

**Electronics:**
- [ ] ESP32 mounted on stripboard
- [ ] CR2032 coin cell installed in DS3231 RTC module
- [ ] RTC SDA → GPIO 21; SCL → GPIO 22; VCC → 3.3V
- [ ] JD-VCC jumper REMOVED from relay module (Critical)
- [ ] Relay VCC → 3.3V; JD-VCC → 5V; GND → GND
- [ ] Relay IN1 → GPIO 26 (LED Tray A)
- [ ] Relay IN2 → GPIO 27 (LED Tray B)
- [ ] Relay IN3 → GPIO 25 (LED Tray C — not GPIO 14)
- [ ] Relay IN4 → GPIO 13 (Pump — not GPIO 12)
- [ ] Float switch: one wire GPIO 33, one wire GND
- [ ] Moisture sensor A: AOUT → GPIO 34; VCC → 3.3V
- [ ] Moisture sensor B: AOUT → GPIO 35; VCC → 3.3V
- [ ] Moisture sensor C: AOUT → GPIO 32; VCC → 3.3V
- [ ] Green LED GPIO 18 via 330Ω
- [ ] Yellow LED GPIO 19 via 330Ω
- [ ] Red LED A GPIO 5 via 330Ω
- [ ] Red LED B/C GPIO 17 via 330Ω
- [ ] Buzzer GPIO 16 via 100Ω (optional)
- [ ] OLED SDA → GPIO 21; SCL → GPIO 22 (optional)

**Mechanical:**
- [ ] All 3 rings assembled from quarter-sections with RTV at seams
- [ ] Foam weatherstrip on all ring flange faces (top and bottom of each ring)
- [ ] All 3 rings stacked and bolted to base and to each other (6× M3×20mm per joint)
- [ ] All 3 sub-trays waterproofed and inserted on lower ledge rails
- [ ] All 3 growing trays inserted on upper ledge rails
- [ ] Waste drain tubes connected to all 3 sub-tray drain fittings
- [ ] LED brackets installed at ~100mm above tray surface in each ring
- [ ] LED strips wired to relay CH1/CH2/CH3 with correct polarity
- [ ] Moisture sensor cables routed through ring cable channels
- [ ] All 3 doors hinged with weatherstrip and magnet catches
- [ ] Top cap installed with status LEDs, OLED (optional), and seed storage

**Pump and tubing:**
- [ ] Pump mounted and wired to relay CH4
- [ ] 3-way manifold installed on pump outlet
- [ ] 3 supply tubes routed from manifold to tray drip ports, secured with clips
- [ ] 3 drip emitters installed at tray drip ports
- [ ] 3 waste tubes routed from sub-tray drain fittings to waste chamber

**Ventilation (if installed):**
- [ ] 40mm fan seated in top cap recess, label/inlet side facing INTO cap
- [ ] Fan secured with 4× M3×12mm bolts into M3 hex nuts
- [ ] Foam dust filter (E33) placed on exhaust (top) face of fan
- [ ] Fan guard (E32) snapped over filter on exhaust face — filter sandwiched between fan and guard
- [ ] Toggle switch mounted in 6.5mm panel-cut hole on top cap front face (right side)
- [ ] Fan wiring: 12V bus → switch input → switch output → fan red (+) → fan black (−) → GND
- [ ] Fan test: switch ON → fan spins; switch OFF → fan stops

**Insect protection:**
- [ ] 6× fiberglass mesh patches (E34, 27×10mm) cut from sheet
- [ ] One mesh patch adhered with RTV silicone over interior of each ring vent slot (2 slots × 3 rings = 6 patches)
- [ ] RTV cured before stacking rings
- [ ] Foam dust filter fitted under fan guard (see Ventilation above)

**Firmware and testing:**
- [ ] Firmware flashed via Arduino IDE
- [ ] RTC clock set via `T<epoch>` serial command
- [ ] Serial `S` status dump shows correct time and tray states
- [ ] Manual pump test: water reaches all 3 drip emitters
- [ ] Reservoir 24h leak test passed
- [ ] Tray A seeded; BOOT button pressed; three green flashes confirmed

---

## Troubleshooting

| Symptom | Likely cause | Action |
|---------|-------------|--------|
| Green LED does not light after power-on | Blown fuse, wrong supply polarity, buck converter voltage wrong | Check fuse; verify 12V supply polarity; re-check buck converter |
| ESP32 resets every few seconds | Relay JD-VCC jumper not removed; buck converter out of spec | Confirm jumper removed; re-check buck converter output at 5.0V |
| Yellow LED always on immediately | Float switch wiring error, or reservoir empty | Check float switch wires at GPIO 33 and GND; fill reservoir |
| Relay clicks but LED strip does not light | LED strip polarity reversed, or wired to COM not NO | Check strip + wire connects to relay NO; check strip polarity marking |
| Relay fires but pump does not run | Pump wired to COM not NO, or pump faulty | Move pump + wire to relay CH4 NO contact |
| OLED shows nothing | I2C address mismatch (try 0x3D) or wiring error | Check SDA/SCL wiring; try `#define OLED_I2C_ADDR 0x3D` in config.h and re-flash |
| Moisture sensor reads 0% always | Sensor VCC not connected, or wrong ADC pin | Check VCC → 3.3V and correct GPIO |
| Moisture sensor reads 100% in dry air | MOISTURE_DRY_RAW value too low | Calibrate per installation-guide.md Step 10 |
| Reservoir seeps at base seam | RTV seal insufficient or not cured before water contact | Drain, dry 24h, re-apply RTV to seam, cure 24h, re-test |
| Sub-tray overflows to ring floor | Pump run time too long, or waste drain tube blocked | Reduce PUMP_RUN_SECONDS in config.h; check waste tube is not kinked |
| Door does not close flush | Hinge pin binding, or magnet polarity reversed | Ream hinge hole with 3mm bit; flip one magnet to correct polarity |
| No text in Serial Monitor | Wrong baud rate (must be 115200) or charge-only USB cable | Set baud to 115200; use a data-capable USB cable |
| Clock shows 2000-01-01 after power-on | RTC was never set, or CR2032 is dead | Set clock via `T<epoch>` serial command; replace CR2032 coin cell |
| Five red LED flashes on button press | All three trays already have active grow cycles | Wait until a tray reaches day 10+ before pressing the BOOT button again |
| Water not reaching all three trays | Tubing kinked, drip emitter blocked | Straighten tubing; clear 2mm drip emitter orifice with a pin |
