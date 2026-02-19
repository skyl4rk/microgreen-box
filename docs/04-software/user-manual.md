# User Manual

**Phase:** 04 Software
**Status:** Complete
**Last Updated:** 2026-02-18
**Applies to:** Microgreen Box v1.0

---

## Overview

The Microgreen Box grows broccoli microgreens automatically. It controls its own lighting schedule, waters the plants twice a day, monitors soil moisture, and tells you when a tray is ready to harvest. Your job is simple: press a button when you seed a tray, refill the water reservoir when prompted, and harvest when the red LED lights up.

This manual covers everything you need to operate the device. No electronics knowledge is required.

**What you need each week:**
- Approximately 15 minutes per tray to clean, sow, and reseed (every 3 days)
- 5 minutes to harvest
- Water top-up approximately once every 10–14 days

---

## Understanding the Controls

### The BOOT Button

The BOOT button (labelled "BOOT" or "IO0" on the ESP32 board, typically near the USB port) is the only control you use during normal operation. A single press seeds the next available tray.

- **Three slow green flashes** = tray seeded successfully
- **Five rapid red flashes** = all three trays are currently growing; no tray is available to seed

### The Status LEDs

Four LEDs on the top cap show system status at a glance:

| LED colour | Normal behaviour | Meaning when lit or changed |
|-----------|-----------------|----------------------------|
| Green | Blinks once per second | System is running normally |
| Green | Blinks rapidly (5× per second) | An alarm is active — check yellow or red LEDs |
| Yellow | Off when OK | Water reservoir is low — refill now |
| Red (Tray A) | Off during growing | Tray A is ready to harvest |
| Red (Tray B/C) | Off during growing | Tray B or Tray C (or both) is ready to harvest |

### The Buzzer (if installed)

- **Two short beeps** when the device first detects low water — then silent until refilled
- **One short beep** when a tray first reaches harvest day — then silent until harvested and reseeded

### The OLED Display (if installed)

The 0.96" display shows six lines of status information:

```
14:32  OK
Water: FULL
A: D08 HARVEST!
B: D05 growing
C: D02 germinate
Pump: 07:00 done
```

- Line 1: current time and overall system status
- Line 2: reservoir status (FULL / LOW)
- Lines 3–5: tray A, B, C — day number and current stage
- Line 6: next scheduled pump event and whether today's events have fired

**Tray stages shown:**
- `D00 germinating` — Days 0–2, lights off, seeds sprouting in darkness
- `D03 growing` — Lights on, seedlings growing
- `D08 HARVEST!` — Harvest day reached, red LED lit
- `---` — Tray is empty (not yet seeded)

### Serial Monitor (for setup and diagnostics)

Connect the device to a computer via USB and open the Serial Monitor at **115200 baud**. Two commands are available:

| Command | Example | Effect |
|---------|---------|--------|
| `T<epoch>` | `T1739836800` | Set the clock to the given Unix timestamp |
| `S` | `S` | Print a full status dump: time, tray states, moisture readings, pump log, alarm flags |

Get the current Unix timestamp at [https://www.unixtimestamp.com](https://www.unixtimestamp.com).

---

## Initial Setup

These steps are done once when you first assemble the device, and again after any extended power-off period where the clock might lose its time.

### Step 1 — Set the Clock

The device keeps time using a DS3231 real-time clock module with a CR2032 battery backup. Once set, the clock runs even if the main power is disconnected. You only need to set it again if the coin cell runs flat (typically after 2–5 years).

1. Connect the ESP32 to your computer via the USB cable.
2. Open the Arduino IDE Serial Monitor (or any serial terminal) at **115200 baud**.
3. Open [https://www.unixtimestamp.com](https://www.unixtimestamp.com) in a browser — note the current Unix timestamp (a large number, e.g., 1739836800).
4. In the serial monitor, type `T` immediately followed by the timestamp number (no space or gap), e.g.:
   ```
   T1739836800
   ```
5. Press Enter. The device responds: `RTC set to 1739836800`
6. Type `S` and press Enter. Confirm the time shown in the status dump is correct.

> Once set, the device does not need a computer connection to operate. Disconnect the USB cable after setup is complete.

### Step 2 — Calibrate Moisture Sensors

The three capacitive moisture sensors each have slightly different electrical characteristics from the factory. Calibration ensures the moisture percentage readings are accurate for your specific sensors.

See `docs/04-software/installation-guide.md` Step 10 for the full calibration procedure. In brief:

1. Hold each sensor in dry air; note the raw ADC value shown in the serial monitor.
2. Submerge the sensing tip in clean water; note the raw ADC value.
3. Update `MOISTURE_DRY_RAW` and `MOISTURE_WET_RAW` in `config.h` and re-flash.

Default values (3200 dry, 1200 wet) are reasonable approximations for the Capacitive V1.2 sensors and will work without calibration, but calibrated values give more accurate skip/top-up behaviour.

### Step 3 — Calibrate the Pump

The pump delivers approximately 75 mL total per watering event (25 mL per tray). The exact run time needed depends on your pump's flow rate, tubing length, and reservoir height.

See `docs/04-software/installation-guide.md` Step 11 for the calibration procedure. The default `PUMP_RUN_SECONDS = 90` targets a pump flow rate of about 50 mL/min. If your pump is faster, reduce this value; if slower, increase it.

---

## Starting a Grow Cycle

### How the rotation works

The device supports three growing trays labelled A (bottom ring), B (middle ring), and C (top ring). Trays are seeded on different days so you always have one tray ready to harvest approximately every 3 days:

| Day | Event |
|-----|-------|
| Day 0 | Seed Tray A — press BOOT once |
| Day 3 | Seed Tray B — press BOOT once |
| Day 6 | Seed Tray C — press BOOT once |
| Day 8 | Tray A signals harvest ready (red LED + one buzzer beep) |
| Day 10 | Harvest Tray A. Clean tray. Seed again — press BOOT once. Tray A is now the new Day 0. |
| Day 11 | Tray B signals harvest ready |
| Day 13 | Harvest Tray B. Clean. Seed again. |
| Day 16 | Tray C signals harvest ready |
| Day 19 | Harvest Tray C. Clean. Seed again. |
| (repeat) | From this point, harvest one tray every ~3 days indefinitely |

> It takes about 3 weeks to establish the full rotation. After that, the device runs indefinitely on its own schedule.

### Seeding a tray

**Prepare the coir:**

1. Take one compressed coir puck (50 g, coconut-fibre growing medium).
2. Place it in a bowl and pour **300–400 mL of water** over it.
3. Wait 5 minutes — the puck expands to about 8× its original size. It will crumble apart as it absorbs water.
4. Break it apart with your fingers until it is loose and fluffy, like slightly damp potting compost.
5. Spread it evenly in the clean growing tray to approximately **2 cm depth**. Even depth prevents dry spots.

**Soak and sow the seeds:**

6. Measure **12–15 g of broccoli microgreen seeds** (roughly 1.5 tablespoons). Use seeds labelled "untreated", "organic", or "food grade" — avoid seeds coated with fungicide (common in garden-centre vegetable seeds).
7. Place seeds in a small glass, cover with water, and soak for **4–8 hours**. Overnight is convenient.
8. After soaking, pour through a fine-mesh strainer and shake out excess water. The seeds will be swollen and slightly sticky — this is correct.
9. Spread seeds **evenly over the coir surface** in a single layer. Cover the entire surface — every part of the coir should have seeds, but they should not pile up in clumps.
10. Slide the growing tray into the ring level and push the door closed.
11. Push the moisture sensor probe gently into the coir at one corner, about 2 cm deep. Do not bend the probe — it is fragile.

**Register the tray with the device:**

12. Press the **BOOT button** once.
    - Three slow green LED flashes = tray registered successfully
    - The device records the current timestamp as "Day 0" for this tray
    - OLED shows the tray at `D00 germinating`

> **Tip:** The device always seeds the next available tray in order A → B → C. If Tray A is empty, pressing BOOT registers Tray A. If A is active but B is empty, pressing BOOT registers Tray B. You do not need to select a specific tray.

---

## Daily Operation

The device runs automatically. You do not need to do anything each day unless an alarm activates.

### What the device does automatically

**Lighting:**
- Grow lights turn **ON at 06:00** and **OFF at 20:00** for each tray that has passed the germination period.
- For Days 0–2 after seeding, the lights for that tray remain **OFF** — this is the germination blackout. Darkness encourages faster, more even germination in broccoli. No physical cover is needed.
- Each tray's light is controlled independently. Tray A at day 5 can have its lights on while Tray C at day 1 keeps its lights off.

**Watering:**
- The pump runs at **07:00 and 19:00** each day.
- Before running, the device reads the moisture sensor of each active tray:
  - If all active trays read **above 70% moisture**: watering is **skipped** — the coir is still moist enough from the previous event.
  - Otherwise: the pump runs for 90 seconds, delivering approximately 25 mL to each tray.
- After 30 seconds settling time, moisture is re-read. If any tray reads **below 25%**: a short top-up run is triggered (30 seconds additional pump time).
- This feedback system prevents both over-watering (which causes mould) and under-watering (which wilts plants), even as water demand changes across the grow cycle.

**Alarms:**
- **Low water (yellow LED + two buzzer beeps):** The float switch in the reservoir detected low water. The alarm sounds once on first detection, then goes silent. Refill as soon as convenient.
- **Harvest ready (red LED + one buzzer beep):** A tray has reached Day 8. The buzzer sounds once. The red LED stays on until you harvest and reseed the tray, pressing BOOT to register the new cycle.

### Things to check occasionally

- **Water level:** Check the reservoir every 10–14 days. The 2.4 L reservoir provides approximately 13–16 days of watering at normal use (150 mL/day). The yellow LED tells you when it needs refilling.
- **Moisture readings:** Type `S` in the serial monitor to see current moisture percentages for all active trays. Readings should typically be in the 40–80% range during an active grow.
- **Waste chamber:** The waste chamber collects any overflow water from the sub-trays. Check and empty it approximately once per month (remove the waste chamber lid, which snap-fits and is hand-removable).

---

## Mold and Bacteria Prevention

The growing environment — warm, humid, enclosed — is also ideal for mold (*Pythium*, *Botrytis*) and bacterial biofilm. These are the primary causes of crop failure in microgreens. This section covers prevention procedures for each component of the system.

### Why mold happens

The two most common causes:

1. **Over-watering during germination.** Seeds are soaked for 4–8 hours before sowing, and the coir is already saturated on Day 0. Running the pump heavily on a freshly-seeded tray pushes the coir into anaerobic (oxygen-free) conditions at the root zone — the primary trigger for *Pythium* damping-off. The firmware addresses this: germinating trays (Days 0–2) are excluded from pump-trigger decisions. They still receive water when established trays need it, but they cannot trigger extra pump runs on their own.

2. **Poor airflow.** Stagnant humid air sitting on the coir surface allows mold spores to germinate. The ventilation fan and ring vent slots address this.

### Routine prevention — every grow cycle

**Coir preparation:**
- Rinse the dry coir puck briefly under a tap before expansion. This washes off surface dust and any salt residue from the compression process.
- Expand with clean water only. Do not use warm or stagnant water.
- Do not compress the expanded coir into the tray — spread it loosely to allow air in the gaps.

**Seed sanitation:**
- Before the 4–8 hour soaking soak, briefly rinse seeds in a **3% hydrogen peroxide solution** for 30 seconds (available from pharmacies, labelled as 3% H₂O₂). Pour into a fine-mesh strainer and rinse thoroughly under clean water.
- This step reduces surface mold spores and bacteria on the seed coat without harming germination. Broccoli seeds tolerate H₂O₂ rinses well.
- After the H₂O₂ rinse, proceed with the normal 4–8 hour clean water soak.

**Seeding density:**
- Spread seeds in a single even layer with no clumps. Dense seed piles block airflow at the surface and create mold focus points. Every seed should have contact with the coir surface.

### Reservoir maintenance — every 2–3 refills (~monthly)

1. Drain the reservoir completely (unscrew the lid, tilt the base over a sink).
2. Wipe the interior with a cloth dampened with a dilute cleaning solution: **1 teaspoon 3% H₂O₂ per 500 mL water**, or **1 teaspoon white vinegar per 500 mL water**.
3. Rinse the interior twice with clean water before refilling.
4. **Optional ongoing additive:** Add 1–2 mL of **3% food-grade hydrogen peroxide per litre** of reservoir water. This provides a mild antimicrobial effect in the water supply without harming the plants at this dilution. It breaks down to water and oxygen within hours.

### Tubing and manifold — monthly

1. Mix 500 mL of **1% H₂O₂ solution** (dilute 3% H₂O₂ with 2× water).
2. Pour into the reservoir and run the pump manually (via serial command or by temporarily increasing pump runtime) until the solution flows through all three drip emitters.
3. Follow with 500 mL of clean water to flush the H₂O₂ from the tubing.
4. Check the 2mm drip emitter orifices. If any emitter drips slowly or unevenly, clear the orifice with a thin pin. The 2mm hole is small enough to partially block with mineral deposits over time.

### Ventilation fan — when to use

The toggle switch on the top cap front face controls the 40mm exhaust fan. It exhausts warm humid air upward out of the column.

**Turn the fan ON if you observe:**
- White or grey fuzzy growth on coir surface (mold colonies)
- Persistent condensation on the ring interior walls
- A sour or musty smell from the growing chamber (distinct from the normal sulphur smell of broccoli)
- Ambient temperature above 28°C (vehicle in direct sun, summer operation)

**Normal operation:** Fan OFF. The passive ring vent slots (slide-cover slots on each ring's front and rear walls) provide sufficient airflow for normal conditions.

**Insect protection:** The fan hole is covered by a foam dust filter (under the fan guard) that blocks insects — including fungus gnats (~2mm), the primary microgreen pest — when the fan is not running. The ring vent slots are each covered by a permanent fiberglass mesh screen (adhered during assembly), which blocks insects regardless of whether the slide cover is in or out. You can safely leave the slide covers removed for ventilation without risk of insect entry.

**Outbreak response:** Remove the slide covers from the ring vent slots AND run the fan continuously until the mold resolves (usually 2–4 days). Reduce `PUMP_RUN_SECONDS` in config.h by 30% for the affected tray cycle.

**After an outbreak:** Clean the affected tray, sub-tray, and moisture sensor probe with the dilute H₂O₂ solution before reseeding.

### If mold is severe or recurring

- Check pump calibration. Type `S` in the serial monitor — if moisture readings are above 80% before a scheduled watering event, reduce `PUMP_RUN_SECONDS` in config.h.
- Check seed source. Mold-treated garden seeds (coated with fungicide or thiram) can transfer harmful chemistry to the growing medium. Use only untreated, organic, or food-grade microgreen seeds.
- Consider replacing the coir puck for the affected tray with a fresh one — spent coir from a mold outbreak retains spores.

---

## Temperature and Environment

The device has two separate temperature concerns: what the plants need, and what the hardware can tolerate. They have different limits.

### Plant temperature

| Ambient temperature | Effect on the grow |
|--------------------|--------------------|
| 20–22°C | Optimal. Best germination, even growth, full yield. |
| 18–24°C | Normal operating band — no impact on yield or timing. |
| 15–18°C | Acceptable. Germination may take 3–4 days instead of 2. Grow cycle may extend 1–2 days. |
| 25–27°C | Tolerated. Growth is slightly faster. Harvest on Day 8 rather than waiting to Day 10. |
| Below 12°C | Germination stalls. Seeds may sit for several days without sprouting. Growth becomes uneven. |
| Above 28°C sustained | Heat stress. Seedlings wilt between watering events; mold risk increases sharply. Open the ring vent slots and run the ventilation fan. |
| Above 32°C | Serious problem. Damping-off risk increases significantly; seedlings may fail to develop. |

> **Note:** The LED grow strips add approximately 2–4°C inside the growing chamber above the ambient temperature during the light period. If the room is already 26°C, the chamber interior during lights-on can be 28–30°C.

### Hardware temperature limits

#### High temperatures

The main risk at the high end is the PETG plastic, not the electronics. The ESP32 and relay module are rated to 85°C. PETG's glass transition temperature is 80°C, but under the sustained mechanical load of the stacked rings and full water reservoir, the printed parts can begin to creep and deform at temperatures above **55–60°C**.

The critical scenario is a vehicle in direct sun with windows closed — the interior can reach 60–80°C. A dark enclosure in direct sun is particularly at risk.

| Situation | Status |
|-----------|--------|
| Ambient ≤35°C | Fully safe |
| Ambient 35–45°C, device in shade | Safe; monitor growing conditions |
| Vehicle, windows cracked, indirect sun | Typically 40–55°C — use the fan and open vent slots |
| Vehicle, direct sun, windows closed | 60–80°C possible — PETG deformation risk; move the device |

#### Low temperatures and freezing

The hard limit at the cold end is **0°C**. The electronics (ESP32, RTC) function down to −40°C and are not a concern. The water system is the risk.

| Situation | Risk |
|-----------|------|
| 5–15°C | Hardware fully safe; growing slows but continues |
| 0–5°C sustained | Pump, tubing, and manifold joints may partially freeze |
| Below 0°C | Water in the reservoir, tubing, and pump head can freeze and expand, cracking the PETG manifold or reservoir and damaging the pump head |

**If storing the device in a cold environment** (unheated garage, vehicle in winter): drain the reservoir and run the pump briefly to clear water from the tubing before temperatures drop below 0°C.

> If you use the optional LiFePO4 battery for off-grid power: the battery will not accept a charge below 0°C. Attempting to charge it in freezing conditions causes permanent damage to the cells. The battery can still *discharge* (power the device) down to around −20°C, but do not charge it until it has warmed above 0°C.

### Practical summary

| Ambient temperature | What to do |
|--------------------|------------|
| 18–24°C | Normal operation — nothing extra needed |
| 15–27°C | Fully operational; minor timing adjustments only |
| 28–35°C | Open ring vent slide covers + run ventilation fan; harvest on Day 8 |
| Above 35°C | Growing degrades; keep device out of direct sun |
| Above 55°C (enclosed vehicle, direct sun) | Move the device — PETG deformation risk |
| 0–5°C | Drain reservoir if temperature will be sustained; germination will fail |
| Below 0°C | Drain and store dry — do not leave water inside any component |

---

## Refilling the Reservoir

When the yellow LED illuminates or you notice the green LED is blinking fast (alarm active):

1. Unscrew the **reservoir lid** (on the top of the base unit, rear-left area).
2. Pour clean water into the reservoir — up to **2 litres** maximum.
3. Replace and tighten the lid.
4. The yellow LED turns off and the buzzer will not sound again until the next low-water event.

> **Optional — CalMag supplement:** From Day 3 of each tray's grow, you may add a small amount of liquid calcium-magnesium supplement (e.g., General Hydroponics CALiMAGic) to the reservoir water at a dose of 0.5 mL per litre. This partially compensates for the low mineral content of plain coconut coir. It is entirely optional — the device produces nutritious microgreens on plain water, and the primary health benefit (sulforaphane) is unaffected by mineral content.

---

## Harvesting

Broccoli microgreens are ready to harvest at **Day 8–10** from seeding. The device signals harvest at Day 8 with a red LED and one buzzer beep. You can harvest anytime between Day 8 and Day 10 — both flavour and nutritional content are optimal in this window.

### Signs of a ready tray

- The red harvest LED is lit
- Seedlings are 5–8 cm tall with two small leaves open (the cotyledons — the first leaves after germination, not the true broccoli leaves which appear later)
- Leaves have a healthy bright yellow-green colour under the grow strip

### Harvest procedure

1. Open the tray door and slide the **growing tray** out of the ring level.
2. Using **clean scissors or a sharp knife**, cut the microgreens just above the coir surface — approximately 5–10 mm from the base of the stems. Do not pull or uproot the plants.
3. You will harvest approximately **90–130 g** of greens from one tray (30 g per day for 3 days, or use all at once for freezing).
4. **Use immediately**, **refrigerate** (up to 7 days), or **freeze** (see the Consumption section below for details on each method).

> **Hygiene:** Wash hands before handling harvested greens. Do not wash the greens until you are ready to use them — surface moisture reduces refrigerator shelf life.

---

## Cleaning and Reseeding

### Clean the growing tray

1. Pull the spent coir and root mat out of the growing tray. The roots form a cohesive mat that usually lifts out in one piece.
2. Compost the spent coir and root mat — it is an excellent garden soil amendment.
3. Rinse the growing tray with clean water. Remove any remaining root fibres or seed husks.
4. If there is any visible mould or slime, wash with a dilute food-safe solution (1 tsp white vinegar in 500 mL water) and rinse thoroughly.
5. Allow to air dry for 10–15 minutes.

### Check and empty the sub-tray

1. Pull the sub-tray out of the ring level (it slides out from the front, same direction as the growing tray).
2. Check for accumulated water. A small amount of clear water is normal. Cloudy or smelly water may indicate over-watering — consider reducing `PUMP_RUN_SECONDS` in config.h.
3. Empty the sub-tray down a drain. Rinse briefly. Slide it back in and reconnect the waste drain tube (push-fit onto the rear drain barb).

### Clean the moisture sensor

Wipe the sensor probe gently with a damp cloth. Do not scrub the gold or black sensing pads near the tip. Allow to dry before reinserting into the new coir.

### Reseed the tray

Follow the seeding procedure in "Starting a Grow Cycle" above. After seeding and pressing BOOT once, the device immediately manages the new tray — lights off for days 0–2, then resuming the photoperiod schedule from day 3.

---

## Consuming Broccoli Microgreens for Maximum Health Benefit

### Why broccoli microgreens?

Broccoli microgreens contain exceptionally high concentrations of **glucoraphanin** (GRN), the stable precursor to **sulforaphane** (SFN). Sulforaphane is the key bioactive compound in broccoli — associated with cancer protection, anti-inflammatory activity, and activation of the body's cellular detoxification pathways (via the Nrf2 pathway). Broccoli microgreens contain 10–100 times more sulforaphane potential than mature broccoli.

**Target dose:** 30 g of fresh broccoli microgreens per day delivers approximately 190–220 µmol of sulforaphane — in the upper range of well-studied clinical doses (50–150 µmol/day is the evidence-based range).

### How sulforaphane is produced

Sulforaphane does not exist ready-made in the plant. It is produced by a chemical reaction when the plant is damaged:
- **GRN** (glucoraphanin) is stored stably in plant cells
- **Myrosinase** is an enzyme stored separately in the same cells
- When you **chew, chop, or blend** the greens, the cells rupture, GRN and myrosinase mix, and sulforaphane is produced within minutes

This means: **you must chew or blend the greens** — swallowing whole leaves produces very little sulforaphane. Chew each mouthful thoroughly (20–30 chews) if eating raw, or blend for 60 seconds if using a smoothie.

### Critical: heat destroys myrosinase

Myrosinase is destroyed by heat above **60–70°C**. Cooking, steaming, or adding microgreens to hot food eliminates most sulforaphane benefit. If you want to include microgreens in a cooked meal, add them after the dish has cooled below 60°C — or use the chop-and-wait technique: chop the greens, wait 40 minutes for sulforaphane to form, then add to food (the formed sulforaphane is heat-stable; only the myrosinase enzyme is heat-sensitive).

---

### Method 1: Morning Smoothie (Recommended)

The daily smoothie is the most practical and palatable method. Blending thoroughly ruptures all cells, maximising the GRN-to-SFN conversion. The flavour of broccoli microgreens (bitter, sulphurous) is **completely masked** by fruit in a well-made smoothie.

**Basic recipe (serves 1):**
- 30 g fresh or frozen broccoli microgreens (see frozen method below)
- 1 medium banana (frozen preferred — adds creaminess)
- 150 g frozen mixed berries (blueberry, blackberry, or dark berry mix work best)
- 200 mL water or oat milk

Blend on high for 60 seconds until completely smooth. Drink immediately.

**Flavour tips:**
- Dark berries (blueberry, blackberry) are most effective at masking the broccoli flavour.
- A tablespoon of peanut butter or almond butter adds richness and further suppresses any bitterness.
- A pinch of mustard seed powder (see below) can be added to boost sulforaphane production.
- The colour will be dark purple-green — this is normal.

> **Why smoothie rather than juice?** Juicing separates the juice from the plant fibres and cellular material, losing the myrosinase. Blending keeps everything, including all the enzymes. Smoothie = full benefit; cold-pressed juice = reduced benefit.

---

### Method 2: Eat Raw

If you prefer not to use a smoothie, eat the microgreens raw. Add to salads, grain bowls, sandwiches, or wraps at the end (not heated). Chew thoroughly — 20–30 chews per mouthful — to maximise cell disruption and sulforaphane production.

- The raw flavour is distinct but mild for broccoli — slightly spicy or mustard-like.
- An acidic dressing (lemon juice, white wine vinegar) pairs well and slightly enhances the reaction.
- Do not cook, blanch, or add to hot food.

---

### Method 3: Raw Freezing for Increased Sulforaphane

Freezing broccoli microgreens **raw and unblanched** at −20°C does not destroy sulforaphane — it actually **increases** myrosinase activity by 17–117% compared to fresh microgreens, resulting in up to **3.1× more sulforaphane** when blended.

> **Critical distinction from commercial frozen broccoli:** Commercial frozen broccoli is blanched (briefly boiled) before freezing to preserve colour and stop enzyme activity. This destroys myrosinase entirely. **Raw home freezing is completely different** — no heat is involved and the enzymes are preserved and enhanced by the freeze-thaw process.

**When to freeze:** Freeze surplus when a tray produces more than you can use in 7 days (90–130 g per tray). This allows you to bank several weeks of supply and consume on any schedule.

**Freezing procedure:**

1. Harvest the greens as normal.
2. Shake off any surface moisture. Do not wash before freezing (washing adds water that forms large ice crystals during freezing, damaging texture — this does not matter for blending, but avoid it regardless).
3. Divide into **30 g portions** and place each portion in a small zip-lock freezer bag.
4. Label each bag with the date and "raw broccoli microgreens". Write on the bag before adding the greens (the condensation from a cold bag makes it hard to write).
5. Seal and freeze at −20°C (standard home freezer). Freeze immediately — do not leave at room temperature or refrigerate first.

**Shelf life:** 3–6 months at −20°C. GRN content is fully preserved throughout storage. Myrosinase activity is maintained or enhanced.

**Consuming frozen microgreens:**

1. Take the bag directly from the freezer.
2. Break the frozen mass apart (hit the bag on the counter) and tip the frozen pieces into the blender.
3. Add other smoothie ingredients.
4. Blend immediately on high for 60 seconds — **do not thaw first.**

> **Why not thaw?** Thawing releases water rapidly, which dilutes the cell contents and allows the GRN-myrosinase reaction to begin in an uncontrolled way before blending properly mixes everything. Blending directly from frozen gives a more thorough cell disruption and better enzyme contact.

---

### Optional Enhancement: Mustard Seed Powder

Yellow mustard seeds contain very high concentrations of myrosinase. Adding a small amount to your smoothie provides "exogenous myrosinase" — enzyme from an outside source — which can supplement or substitute for the microgreens' own myrosinase if it has been reduced by storage.

- **Dose:** ¼ teaspoon (about 1 g) of ground yellow mustard seed — available as "dry mustard powder" or "mustard flour" in supermarkets or online
- **When to use:** Add to the blender with the other smoothie ingredients — especially useful when using older frozen microgreens (stored longer than 3 months) or if the greens were warmed before blending

---

### Consumption Summary Table

| Method | Daily effort | Palatability | SFN yield | Shelf life |
|--------|-------------|-------------|-----------|-----------|
| Fresh smoothie | 5 min | Excellent (masked) | High | Drink immediately |
| Fresh raw | 0 min extra | Mild bitter flavour | High | Eat immediately |
| Fresh refrigerated | — | As above | High | 5–7 days at 4°C |
| Frozen then blended | 1 min to freeze; 5 min to blend | Excellent | Up to 3.1× fresh | 3–6 months |
| Cooked (>60°C) | — | N/A | Near zero | Avoid |

---

## Troubleshooting

### Yellow LED is on / buzzer beeped twice

**Cause:** Reservoir water level is low.

**Action:** Refill the reservoir with up to 2 litres of clean water (unscrew the reservoir lid, fill, replace lid). The yellow LED turns off as soon as the float switch detects water at the correct level.

If the LED stays on after refilling:
- Confirm the reservoir lid is fully tightened
- The float switch ball may be stuck — open the reservoir lid and check that the float ball hangs freely and moves up and down smoothly with water level changes
- Check the float switch wire connections at GPIO 33 and GND (see assembly instructions Step 9)

---

### Red LED is on — tray is at harvest day

**Cause:** Normal — the device has detected that a tray reached Day 8.

**Action:** Harvest the tray when convenient (any time between Day 8 and Day 10). After harvesting, clean the tray and reseed it, then press BOOT once to register the new Day 0. The red LED turns off when the new seed epoch is recorded.

---

### Plants are not growing well

| Symptom | Likely cause | Action |
|---------|-------------|--------|
| Pale or yellow leaves throughout | Insufficient light | Confirm the LED relay activates (watch the LED during 06:00–20:00 after day 2); check relay wiring |
| Yellow leaves only days 0–2 | Normal — germination blackout period | No action; lights activate from day 3 automatically |
| Wilting, very dry coir | Under-watering | Check pump runs (listen for motor); check moisture readings via `S`; increase `PUMP_RUN_SECONDS` in config.h |
| Mould (white fuzzy growth), soggy coir | Over-watering | Reduce `PUMP_RUN_SECONDS`; confirm skip threshold (70%) is working; increase spacing between seeds |
| Tall, spindly seedlings leaning toward door | LED too far from tray | Re-adjust LED bracket to 100mm above tray surface |
| Uneven germination (bare patches) | Uneven seed distribution or coir depth | Spread seeds more evenly; ensure coir depth is a consistent 2cm |
| Strong sulphur smell | Normal for broccoli family, strongest days 4–8 | Expected — not a problem; smell indicates healthy glucosinolate content |

---

### Device appears to have lost its schedule

**Symptom:** OLED shows all trays as `---` (empty), or the clock shows 2000-01-01.

**Cause:** Either the RTC clock lost power (dead coin cell or power was off for extended time), or the EEPROM tray data was reset (e.g. by a firmware re-flash that initialised the magic byte).

**Action:**
1. Set the clock if needed: `T<epoch>` in serial monitor.
2. If tray data is lost, you will need to reseed each tray manually. The device cannot recover previous grow-day counts if EEPROM was cleared. Start fresh with new seeds and press BOOT for each tray.
3. After any firmware re-flash, re-press BOOT for each active tray to re-register the cycles (the grow-day count restarts from 0, so harvest timing resets).

---

### Serial monitor shows no output or garbled text

**Cause:** Wrong baud rate (most common) or a charge-only USB cable.

**Action:** Set serial monitor to exactly **115200 baud**. Ensure your USB cable is data-capable — many phone charging cables carry power only. Try a different cable.

---

### Pump runs but moisture readings do not improve

**Possible causes:**
- Drip emitter blocked — water not reaching the tray
- Tubing kinked between manifold and tray level
- Moisture sensor calibration off (MOISTURE_DRY_RAW or MOISTURE_WET_RAW needs adjustment)
- Moisture sensor probe not fully inserted into coir

**Action:** Open the door during a pump run and watch whether water drips from the emitter into the tray. If no flow, clear the 2mm drip emitter orifice with a pin and check for kinked tubing. If flow is correct but readings do not change, recalibrate sensors per installation-guide.md Step 10.

---

### Pump does not run at scheduled times

**Symptom:** Expected watering events at 07:00 or 19:00 are not occurring.

**Possible causes:**
- All active trays are above the skip threshold (70% moisture) — this is normal and correct behaviour
- Pump relay not wired correctly
- Pump event for today already fired and was logged

**Action:** Type `S` in the serial monitor. Read the pump log section — it shows whether today's events have fired and the current moisture readings. If moisture is genuinely above 70%, no watering is needed and the skip is correct. If moisture is low but the pump did not run, check relay CH4 wiring and pump power connections.

---

## Configuration Reference

To change growing parameters, edit `software/firmware/microgreen_controller/config.h` and re-flash via Arduino IDE. See `docs/04-software/requirements.md` for full documentation of every parameter.

**Most commonly adjusted parameters:**

| Parameter | Default | What it controls |
|-----------|---------|-----------------|
| `PHOTO_ON_HOUR` | 6 | Hour when grow lights turn on (06:00) |
| `PHOTO_OFF_HOUR` | 20 | Hour when grow lights turn off (20:00) |
| `BLACKOUT_DAYS` | 2 | Days after seeding during which lights stay off |
| `WATER_HOUR_1` | 7 | Morning watering time (07:00) |
| `WATER_HOUR_2` | 19 | Evening watering time (19:00) |
| `GROW_DAYS` | 10 | Days after which a tray is available for reseeding |
| `HARVEST_DAY` | 8 | Day when harvest alert (red LED + beep) activates |
| `PUMP_RUN_SECONDS` | 90 | Pump run duration per event — calibrate to your pump |
| `MOISTURE_SKIP_THRESHOLD` | 70 | Skip watering if all trays read above this % |
| `MOISTURE_TOPUP_THRESHOLD` | 25 | Run extra pump if any tray reads below this % after main event |

---

## Quick Reference Card

**Normal daily operation:** Nothing required — device runs automatically.

**Refill water:** Unscrew reservoir lid (rear-left of base top) → pour up to 2 L → replace lid.

**Seed a tray:** Expand coir puck + soak seeds (4–8h) → spread coir in tray → spread seeds evenly → slide tray in → insert moisture sensor probe → press BOOT once → confirm 3 green LED flashes.

**Harvest:** Open door → slide growing tray out → cut greens ~5–10 mm above coir with clean scissors → use fresh, refrigerate up to 7 days, or freeze in 30 g portions.

**Clean and reseed:** Remove coir mat → rinse tray → empty sub-tray → air dry → reseed as above → press BOOT.

**Set clock:** USB to computer → Serial Monitor at 115200 baud → `T<unix_timestamp>` → Enter.

**Check status:** USB to computer → Serial Monitor at 115200 baud → `S` → Enter.

**Change settings:** Edit `config.h` in Arduino IDE → change value → Upload (re-flash).
