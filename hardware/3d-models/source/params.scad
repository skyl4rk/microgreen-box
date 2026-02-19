// ============================================================
// Microgreen Box — Master Parameters
// ============================================================
// Source of truth for all 3D model dimensions.
// All values derived from:
//   PROJECT_DECISIONS.md
//   docs/02-design/enclosure-design.md
//   docs/02-design/watering-system.md
//   docs/02-design/growing-system.md
//   docs/02-design/lighting-system.md
//
// DECISION-012: PETG mandatory for all structural and water-contact parts.
// DECISION-007: Coir growing medium (NOT compost).
// DECISION-011: Fully sealed water paths, peristaltic pump.
// DECISION-009: 12V DC primary power.
//
// Key design constraints (from PROJECT_DECISIONS.md §Constraints):
//   C-006: Enclosure footprint ≤35×35cm
//   C-007: Reservoir ≥1.5L (2L chosen)
//   C-012: All parts print on ≤200×200mm bed
//
// Total height: base_h + 3*ring_h + cap_h = 200+3*190+80 = 850mm ✓
// ============================================================

// ---- Render quality ----------------------------------------
// Increase $fn for production STLs (slower render, better circles)
$fn = 48;

// ---- Global tolerances & fit types -------------------------
tol        = 0.20;   // Clearance fit (moving parts) [mm]
press_tol  = 0.05;   // Press fit (permanent joints) [mm]
eps        = 0.01;   // Anti-z-fight epsilon [mm]

// ---- Wall & structure --------------------------------------
enc_wall   = 4.0;    // Outer wall thickness [mm]
floor_t    = 6.0;    // Floor / ceiling thickness [mm]
flange_h   = 8.0;    // Stack-join flange height [mm]
seal_lip   = 2.0;    // Light-seal inward lip depth [mm]

// ---- Fasteners: M3 (ring stacking, panel assembly) ---------
m3_clr     = 3.4;    // M3 clearance hole diameter [mm]
m3_head_d  = 6.5;    // M3 pan-head OD [mm]
m3_head_h  = 3.0;    // M3 pan-head height [mm]
m3_nut_w   = 6.1;    // M3 hex nut across-flats [mm]
m3_nut_h   = 2.5;    // M3 hex nut height [mm]
m3_boss_d  = 7.0;    // Boss OD around M3 hole [mm]

// ---- Fasteners: M5 heat-set inserts (vehicle mounting) -----
// DECISION-012: 4× M5 inserts in base corners for strap/bracket attachment
m5_ins_od  = 7.0;    // M5 heat-set insert outer diameter [mm]
m5_ins_h   = 8.0;    // M5 heat-set insert depth [mm]
m5_corner  = 18.0;   // Insert centre distance from outer corner [mm]

// ============================================================
// ENCLOSURE GLOBAL FOOTPRINT (enclosure-design.md)
// ============================================================
enc_w      = 300.0;  // Outer width  (X) [mm]
enc_d      = 300.0;  // Outer depth  (Y) [mm]

enc_int_w  = enc_w - 2*enc_wall;  // Interior clear width  = 292mm
enc_int_d  = enc_d - 2*enc_wall;  // Interior clear depth  = 292mm

// ============================================================
// BASE UNIT  (enclosure-design.md §Base Unit)
// Outer: 300×300×200mm
// Split front/rear at Y=150 for printing.
// Print halves standing on the 150×200mm (YZ) face.
// Minimum bed: 200mm wide (X) × 150mm deep (Y), part 200mm tall (Z).
// ============================================================
base_h      = 200.0;   // Base unit outer height [mm]
base_split  = 150.0;   // Front/rear split Y position [mm]

// Chamber interior height (floor_t=6 → floor_t+ch_h=90mm → ceiling at 90mm)
ch_h        = 84.0;    // Interior height of sealed chambers [mm]

// --- Reservoir (rear-left, DECISION-011) --------------------
// Interior: X=4..208, Y=154..296, Z=6..90
// Volume: 204 × 142 × 84 ≈ 2.43L  ✓  (≥2L spec)
res_x1      = enc_wall;        // Inner left edge  [mm]
res_x2      = 208.0;           // Inner right edge [mm]  (204mm wide)
res_y1      = base_split + enc_wall;  // Inner front edge [mm]
res_y2      = enc_d - enc_wall;       // Inner rear edge  [mm]  (296mm)

// --- Waste chamber (rear-right, adjacent to reservoir) -------
// Interior: X=212..296, Y=154..296, Z=6..90
// Volume: 84 × 142 × 84 ≈ 1.00L  ✓  (≥500mL spec)
waste_x1    = res_x2 + enc_wall;        // Inner left edge  [mm]
waste_x2    = enc_d - enc_wall;         // Inner right edge [mm]

// --- Electronics bay (front-left, DECISION-008) --------------
// Interior: X=4..104, Y=4..146, Z=6..90
elec_x1     = enc_wall;          // Inner left edge  [mm]
elec_x2     = 104.0;             // Inner right edge [mm]
elec_y1     = enc_wall;          // Inner front edge [mm]
elec_y2     = base_split - enc_wall;    // Inner rear edge  [mm]

// --- Pump / wiring space (front-right, open top) ------------
// X=108..296, Y=4..146 — accessible from top; no lid required

// --- Fill port (top-access screw cap over reservoir) --------
fill_d      = 40.0;   // Fill port inner diameter (O-ring groove) [mm]
fill_boss_d = fill_d + 8.0;  // Boss outer diameter [mm]
fill_boss_h = 14.0;   // Boss height above top face [mm]
fill_oring  = 2.0;    // O-ring groove depth [mm]
// Fill port centre position
fill_x      = (res_x1 + res_x2) / 2;   // = 106mm
fill_y      = (res_y1 + res_y2) / 2;   // = 225mm

// --- Power jack aperture (left wall, side-mount) ------------
// 5.5/2.1mm barrel jack, DECISION-009
jack_hole_d = 12.0;   // Panel cutout diameter [mm]
jack_y      = 60.0;   // Jack centre, Y from front [mm]
jack_z      = 130.0;  // Jack centre, Z from base bottom [mm]

// --- Stack bolt holes (top face → ring attaches here) -------
// 6× M3 holes: 2 rows of 3 at X=30/150/270, Y=20 and Y=280
ring_bolt_xs = [30, 150, 270];   // X positions [mm]
ring_bolt_y1 = 20.0;             // Front bolt row Y [mm]
ring_bolt_y2 = enc_d - 20.0;    // Rear bolt row Y  [mm]

// --- Waste overflow port (rear wall, tubing exit) -----------
waste_port_d = 8.5;   // Hole diameter (fits 6mm OD tube + sealant) [mm]
waste_port_z = 20.0;  // Z height from base bottom [mm]

// ============================================================
// TRAY RING  (enclosure-design.md §Tray Level Ring)
// Outer: 300×300×190mm per level  (×3 required)
// NOTE: Design doc states 260mm; 190mm used here so
//       total = 200 + 3×190 + 80 = 850mm ≤ 900mm NFR.
//       Override ring_h=260 for extra LED headroom (total 1060mm).
//
// Split into 4 corner-quarter sections for 200×200mm beds:
//   FL (front-left), FR (front-right), RL (rear-left), RR (rear-right)
// Each quarter ≈150×150×ring_h — fits on 200×200mm bed,
// printed standing up (ring_h in Z, ~190mm ≤ 200mm build height).
// ============================================================
ring_h      = 190.0;  // Ring outer height per level [mm]
ring_split_x = enc_w / 2;   // Corner-quarter split X = 150mm
ring_split_y = enc_d / 2;   // Corner-quarter split Y = 150mm

// --- Tray ledge rails (left+right inner walls only) ---------
ledge_w     = 6.0;   // Ledge width (protrusion from inner wall) [mm]
ledge_t     = 4.0;   // Ledge thickness (Z) [mm]
sub_ledge_z = 12.0;  // Sub-tray ledge Z above ring floor [mm]
grow_ledge_z = sub_ledge_z + 40.0 + ledge_t;  // Growing tray ledge Z [mm]
                     // = 12 + 40 + 4 = 56mm

// --- Drip inlet port (rear wall) ----------------------------
drip_port_d = 8.0;   // Drip tube port hole OD [mm]
drip_port_x = enc_w / 2;   // Centred horizontally [mm]
drip_port_z = grow_ledge_z + 60.0;  // Above tray surface [mm]

// --- Front door aperture ------------------------------------
// DECISION-012: hinged PETG door with magnetic catch
door_w      = 150.0;  // Door opening width [mm]
door_x0     = (enc_w - door_w) / 2;  // Aperture left edge X = 75mm
door_h_open = ring_h - 2*flange_h;   // Aperture height [mm]
door_z0     = flange_h;               // Aperture bottom Z [mm]

// Door hinge (left edge of aperture)
hinge_d     = 3.5;   // Hinge pin hole diameter [mm]
hinge_boss  = 8.0;   // Hinge boss OD [mm]
hinge_count = 3;     // Number of hinge knuckles

// Door catch magnet (right edge of aperture, mid-height)
magnet_d    = 8.0;   // Magnet OD [mm]
magnet_dep  = 3.5;   // Magnet pocket depth [mm]

// --- LED wire pass-through (front wall, above door) ---------
led_wire_w  = 8.0;   // Wire slot width [mm]
led_wire_h  = 6.0;   // Wire slot height [mm]
led_wire_x  = enc_w - 30.0;  // Slot centre X [mm]
led_wire_z  = ring_h - flange_h - 15.0;  // Slot centre Z [mm]

// --- Ring stack bolt holes (M3, top and bottom flanges) -----
// Same X positions as base unit: ring_bolt_xs = [30, 150, 270]
// Y positions: front row at 20, rear row at 280

// ============================================================
// GROWING TRAY  (growing-system.md, DECISION-005)
// Outer: 250×250×50mm  (25×25cm = 625cm² growing area)
// 4× Ø8mm drain holes in a 2×2 grid
// 5mm retention lip on outside base edge (stops tray sliding)
// ============================================================
tray_w      = 250.0;  // Outer width  [mm]
tray_d      = 250.0;  // Outer depth  [mm]
tray_h      = 50.0;   // Outer height [mm]
tray_wall   = 3.0;    // Wall thickness [mm]
tray_floor  = 4.0;    // Floor thickness [mm]
tray_lip_h  = 6.0;    // Retention lip height (below floor) [mm]
tray_lip_w  = 4.0;    // Retention lip width (outward) [mm]
drain_d     = 8.0;    // Drain hole diameter [mm]
drain_grid  = 2;      // Drain holes per axis (2×2 = 4 holes)
drain_inset = 50.0;   // Drain hole inset from tray centre [mm]
             // holes at X=±50, Y=±50 relative to tray centre

// ============================================================
// SUB-TRAY  (watering-system.md, DECISION-011)
// Outer: 256×256×40mm — slightly larger than growing tray
// Sealed with Ø8mm overflow port at 25mm height
// Drain fitting on side wall routes to waste chamber
// ============================================================
sub_w       = 256.0;  // Outer width  [mm]
sub_d       = 256.0;  // Outer depth  [mm]
sub_h       = 40.0;   // Outer height [mm]
sub_wall    = 3.0;    // Wall thickness [mm]
sub_floor   = 4.0;    // Floor thickness [mm]
overflow_z  = 25.0;   // Overflow port centre Z above sub floor [mm]
overflow_d  = 8.0;    // Overflow port hole diameter [mm]
             // Overflow on RIGHT side wall (X=sub_w face)
drain_fit_d = 8.5;    // Waste drain fitting OD (push-fit) [mm]
             // Drain fitting on REAR wall (Y=sub_d face), Z=10mm

// ============================================================
// LED BRACKET  (lighting-system.md, DECISION-010)
// Mounts to ring inner rear wall; holds 100×100mm LED panel
// Vertical adjustment slot: ±15mm (total 30mm travel)
// Nominal LED height above tray: 100mm
// ============================================================
led_panel_w  = 100.0;  // LED panel footprint width [mm]
led_panel_d  = 100.0;  // LED panel footprint depth [mm]
led_panel_t  = 4.0;    // LED panel thickness [mm]
led_nom_h    = 100.0;  // Nominal LED height above tray surface [mm]
led_adj_range = 30.0;  // Total adjustment travel [mm]
brkt_arm_t   = 5.0;    // Bracket arm thickness [mm]
brkt_slot_w  = 4.5;    // Adjustment slot width (M4 clearance) [mm]
brkt_slot_l  = led_adj_range;  // Slot length [mm] = 30mm
brkt_flange_w = 12.0;  // Wall-mount flange width [mm]
brkt_screw_d  = 3.4;   // M3 clearance for wall-mount screws [mm]

// ============================================================
// FRONT DOOR  (enclosure-design.md §Front door)
// Hinged PETG panel, magnetic catch, foam weather-strip channel
// ============================================================
door_panel_w = door_w;           // Panel width = 150mm
door_panel_h = door_h_open;      // Panel height = ring_h - 2×flange_h
door_panel_t = enc_wall + 2.0;   // Panel thickness (6mm) for rigidity
foam_groove_w = 4.0;  // Foam weather-strip groove width [mm]
foam_groove_d = 2.0;  // Foam weather-strip groove depth [mm]

// ============================================================
// TOP CAP  (enclosure-design.md §Top Cap)
// Outer: 300×300×80mm
// Contains: seed box, bag tray, OLED window, handle, status LEDs
// ============================================================
cap_h       = 80.0;    // Top cap outer height [mm]
seed_w      = 60.0;    // Seed storage box interior width [mm]
seed_d      = 60.0;    // Seed storage box interior depth [mm]
seed_h      = 50.0;    // Seed storage box interior height [mm]
bag_w       = 80.0;    // Bag/marker tray interior width [mm]
bag_d       = 80.0;    // Bag/marker tray interior depth [mm]
bag_h       = 30.0;    // Bag/marker tray interior height [mm]
oled_cw     = 28.0;    // OLED window cutout width  [mm]  (SSD1306 128×64)
oled_ch     = 14.0;    // OLED window cutout height [mm]
status_d    = 3.5;     // Status LED hole diameter [mm]  (3mm LED + 0.5 clr)
status_n    = 4;       // Number of status LED holes
handle_span = 80.0;    // Handle outer span (X) [mm]
handle_rise = 25.0;    // Handle arch height [mm]
handle_t    = 8.0;     // Handle wall thickness [mm]

// ============================================================
// VENTILATION FAN  (DECISION-024: 40mm 12V brushless fan, manual switch)
// Fan exhausts upward through top cap top surface.
// Switch panel-cut on top cap front face (right side, clear of OLED/LEDs).
// Passive intake: existing ring vent slots (ring_vent_* params below).
// ============================================================
fan_hole_d    = 37.0;   // Fan exhaust hole diameter (40mm fan + clearance) [mm]
fan_bolt_ctc  = 32.0;   // Fan bolt circle centre-to-centre (standard 40mm fan) [mm]
fan_recess_d  = 42.0;   // Fan body recess OD (body sits flush with top surface) [mm]
fan_recess_t  =  2.0;   // Fan recess depth [mm]
fan_x         = 150.0;  // Fan centre X (centred in cap footprint) [mm]
fan_y         = 220.0;  // Fan centre Y (rear half, clear of handle arch) [mm]
switch_hole_d =  6.5;   // Toggle switch panel-cut diameter [mm]
switch_x      = 255.0;  // Switch centre X on front face (right side) [mm]
switch_z      =  50.0;  // Switch centre Z on front face [mm]

// Passive ring vent slots (already modelled in tray_ring.scad)
// These parameters document existing features — no model changes needed.
// Two slots per ring (front and rear walls), with removable slide covers.
ring_vent_w   = 25.0;   // Vent slot width [mm]
ring_vent_h   =  8.0;   // Vent slot height [mm]
ring_vent_z   = ring_h - flange_h - 12.0;  // Slot centre Z from ring floor [mm]

// ============================================================
// RESERVOIR LID  (printing-instructions.md: reservoir_lid.stl)
// Threaded screw cap with O-ring groove
// Fits fill_d (40mm) boss on base unit top
// ============================================================
lid_od      = fill_d + 8.0;   // Lid outer diameter [mm]
lid_h       = 12.0;           // Lid total height [mm]
lid_skirt_h = 8.0;            // Thread engagement depth [mm]
lid_thread_pitch = 2.0;       // Thread pitch [mm] (modelled as groove)

// ============================================================
// MISCELLANEOUS PARTS
// ============================================================

// Tube saddle clip (secures 6mm OD silicone tubing every 50mm)
tube_od     = 6.0;    // Silicone tubing OD [mm]
clip_body_w = 14.0;   // Clip body width [mm]
clip_body_t = 4.0;    // Clip body wall thickness [mm]
clip_tab_w  = 8.0;    // Mounting tab width [mm]
clip_tab_h  = 8.0;    // Mounting tab height [mm]
clip_screw_d = 2.5;   // Self-tap screw hole diameter [mm]

// 3-way water manifold (1-to-3 splitter for drip tubing)
mani_in_d   = 8.0;    // Inlet barb OD (for 6mm ID tubing) [mm]
mani_out_d  = 6.0;    // Outlet barb OD (for 4mm ID tubing) [mm]
mani_barb_l = 10.0;   // Barb length [mm]
mani_barb_step = 1.2; // Barb ridge height (retention) [mm]
mani_body_d = 14.0;   // Manifold body diameter [mm]

// Drip emitter cap (2mm orifice, press-fit onto 6mm OD tubing)
emit_od     = 8.0;    // Emitter body OD [mm]
emit_len    = 16.0;   // Emitter body length [mm]
emit_orifice = 2.0;   // Orifice diameter [mm]
emit_barb_d = 6.5;    // Barb OD press-fits into 6mm tube [mm]

// Pump mount bracket (holds peristaltic pump in base)
pump_w      = 46.0;   // Pump body width (X) [mm]
pump_d      = 66.0;   // Pump body depth (Y) [mm]
pump_h_dim  = 36.0;   // Pump body height (Z) [mm]
pump_bolt_d = 3.4;    // M3 clearance holes for pump feet [mm]
pump_bolt_cx = 36.0;  // Pump mounting bolt centre spacing X [mm]
pump_bolt_cy = 56.0;  // Pump mounting bolt centre spacing Y [mm]

// Status LED panel (4× 3mm LED mount in top cap)
led_pan_w   = 50.0;   // Panel width [mm]
led_pan_h   = 12.0;   // Panel height [mm]
led_pan_t   = 3.0;    // Panel thickness [mm]
led_spacing = 10.0;   // LED hole centre spacing [mm]
