// ============================================================
// Base Unit
// ============================================================
// Outer: 300×300×200mm
// Contains:
//   - Water reservoir (~2.43L, rear-left)
//   - Waste chamber (~1.0L, rear-right)
//   - Electronics bay (~1.2L, front-left)
//   - Pump/wiring space (front-right, open top)
//
// PART variable selects what to render:
//   "full"      — complete assembled base (reference model)
//   "front"     — front half (Y=0..150) for printing
//   "rear"      — rear half (Y=150..300) for printing
//   "lid_res"   — reservoir screw-cap lid
//   "lid_waste" — waste chamber lid
//   "elec_cov"  — electronics bay cover panel
//   "pump_mnt"  — peristaltic pump mount bracket
//
// Print orientation (base halves):
//   Stand on the 150×200mm (Y×Z) face.
//   Footprint on bed: 300mm (X) × 150mm (Y).
//   Build height: 200mm (Z).
//   Minimum bed: 300mm wide × 150mm deep.
//   NOTE: A 300mm bed dimension is required; the 200×200mm
//   minimum stated in printing-instructions.md is insufficient
//   for base halves unless parts are split further into quarters.
//
// Assembly:
//   6× M3×20mm bolts + nuts at split face (Y=150).
//   RTV silicone bead on water-zone seam before bolting.
//   PETG solvent weld (MEK) on electronics bay seam (optional).
// ============================================================

include <params.scad>

PART = "full";   // Override with: openscad -D 'PART="front"' ...

// ------------------------------------------------------------
// MODULE: complete base unit geometry
// ------------------------------------------------------------
module base_unit_geo() {
    difference() {

        // --- Outer shell ---
        cube([enc_w, enc_d, base_h]);

        // --- Main interior void ---
        // Keeps 4mm walls, 6mm floor, 4mm top shelf
        translate([enc_wall, enc_wall, floor_t])
            cube([enc_int_w, enc_int_d, base_h - floor_t - enc_wall + eps]);

        // --- Reservoir cavity (rear-left) ---
        // Interior: 204mm × 142mm × 84mm ≈ 2.43L
        translate([res_x1, res_y1, floor_t])
            cube([res_x2 - res_x1, res_y2 - res_y1, ch_h + eps]);

        // --- Waste chamber cavity (rear-right) ---
        // Interior: 84mm × 142mm × 84mm ≈ 1.00L
        translate([waste_x1, res_y1, floor_t])
            cube([waste_x2 - waste_x1, res_y2 - res_y1, ch_h + eps]);

        // --- Electronics bay cavity (front-left) ---
        // Interior: 100mm × 142mm × 84mm ≈ 1.19L
        translate([elec_x1, elec_y1, floor_t])
            cube([elec_x2 - elec_x1, elec_y2 - elec_y1, ch_h + eps]);

        // --- Power jack aperture (left outer wall, X=0 face) ---
        // 5.5/2.1mm barrel jack, positive-centre, DECISION-009
        translate([-eps, jack_y, jack_z])
            rotate([0, 90, 0])
                cylinder(d=jack_hole_d, h=enc_wall + 2*eps);

        // --- Reservoir fill port (through top surface) ---
        translate([fill_x, fill_y, base_h - enc_wall - eps])
            cylinder(d=fill_d, h=enc_wall + fill_boss_h + 2*eps);

        // --- Stack bolt holes: 6× M3 through top face ---
        // For attaching tray ring 1 to base top
        for (bx = ring_bolt_xs) {
            translate([bx, ring_bolt_y1, base_h - enc_wall - eps])
                cylinder(d=m3_clr, h=enc_wall + 2*eps);
            translate([bx, ring_bolt_y2, base_h - enc_wall - eps])
                cylinder(d=m3_clr, h=enc_wall + 2*eps);
        }

        // --- M5 heat-set insert recesses (base underside, 4 corners) ---
        // Vehicle mounting points, DECISION-012
        for (cx = [m5_corner, enc_w - m5_corner])
            for (cy = [m5_corner, enc_d - m5_corner])
                translate([cx, cy, -eps])
                    cylinder(d=m5_ins_od, h=m5_ins_h + eps);

        // --- Pump tubing outlet holes (top, 3× for tray supply lines) ---
        // Positioned above pump/wiring space (front-right quadrant)
        for (i = [0:2])
            translate([120 + i * 60, base_split/2, base_h - enc_wall - eps])
                cylinder(d=7.0, h=enc_wall + 2*eps);

        // --- Waste overflow port (rear wall, connects to external drain) ---
        // Ø8.5mm for 6mm OD tubing + silicone sealant
        translate([enc_w - enc_wall - eps,
                   (res_y1 + res_y2)/2,
                   waste_port_z])
            rotate([0, 90, 0])
                cylinder(d=waste_port_d, h=enc_wall + 2*eps);

        // --- Split face bolt holes: 3× M3 at Y=base_split ---
        // Through the full base height at the split plane
        // Bolts go in Y-direction; heads at Y=0 (front face)
        for (bx = [50, 150, 250]) {
            translate([bx, -eps, 40])
                rotate([-90, 0, 0])
                    cylinder(d=m3_clr, h=base_d_half() + 2*eps);
            translate([bx, -eps, 100])
                rotate([-90, 0, 0])
                    cylinder(d=m3_clr, h=base_d_half() + 2*eps);
            translate([bx, -eps, 160])
                rotate([-90, 0, 0])
                    cylinder(d=m3_clr, h=base_d_half() + 2*eps);
        }

        // --- Water level sensor flat spot (left outer wall) ---
        // XKC-Y25-V capacitive sensor mounts on exterior of reservoir wall
        // Flatten area: X=0..0.5mm, Y=res_y1..res_y1+40, Z=floor_t..floor_t+40
        translate([-eps, res_y1 + 20, floor_t + 10])
            cube([enc_wall * 0.4, 40, 40]);

    } // end difference

    // --- Fill port boss (raised collar above top face) ---
    difference() {
        union() {
            translate([fill_x, fill_y, base_h - enc_wall])
                cylinder(d=fill_boss_d, h=fill_boss_h);
            // Hex flat for wrench grip (optional — comment out if not needed)
            translate([fill_x, fill_y, base_h - enc_wall + fill_boss_h - 6])
                cylinder(d=fill_boss_d + 2, h=6, $fn=6);
        }
        // Bore through boss
        translate([fill_x, fill_y, base_h - enc_wall - eps])
            cylinder(d=fill_d, h=fill_boss_h + 2*eps);
        // O-ring groove (2mm wide × 2mm deep, at mid-boss height)
        translate([fill_x, fill_y, base_h - enc_wall + 5])
            difference() {
                cylinder(d=fill_d + 4*fill_oring, h=fill_oring + 1);
                cylinder(d=fill_d,                h=fill_oring + 2);
            }
    }

    // --- Electronics bay cover ledge / lip ---
    // A 4mm-wide shelf inside the electronics bay top edge
    // electronics_cover.stl rests on this lip
    translate([elec_x1, elec_y1, floor_t + ch_h])
        difference() {
            cube([elec_x2 - elec_x1, elec_y2 - elec_y1, enc_wall]);
            translate([enc_wall, enc_wall, -eps])
                cube([elec_x2 - elec_x1 - 2*enc_wall,
                      elec_y2 - elec_y1 - 2*enc_wall,
                      enc_wall + 2*eps]);
        }

} // end base_unit_geo

// Helper: half-depth for bolt hole through-length
function base_d_half() = enc_d;   // bolts span full depth; nut captures at other half

// ------------------------------------------------------------
// MODULE: reservoir screw-cap lid (reservoir_lid.stl)
// ------------------------------------------------------------
module reservoir_lid() {
    difference() {
        union() {
            // Outer cap body
            cylinder(d=lid_od, h=lid_h);
            // Grip flange at top
            translate([0, 0, lid_h - 3])
                cylinder(d=lid_od + 6, h=3, $fn=6);
        }
        // Bore (interior)
        translate([0, 0, -eps])
            cylinder(d=fill_d - 0.5, h=lid_skirt_h + eps);
        // Thread groove (simplified: single helical groove modelled as rings)
        // For actual threading, use a threading library or tap after print
        for (i = [0:3])
            translate([0, 0, 2 + i*lid_thread_pitch])
                difference() {
                    cylinder(d=fill_d + 1.5, h=0.8);
                    cylinder(d=fill_d - 2,   h=0.8);
                }
        // O-ring seat at cap top interior
        translate([0, 0, lid_skirt_h - 2])
            difference() {
                cylinder(d=fill_d - 0.5,    h=2.5);
                cylinder(d=fill_d - 5,      h=2.5);
            }
    }
}

// ------------------------------------------------------------
// MODULE: waste chamber lid (waste_lid.stl)
// Removable snap-fit lid for waste chamber top opening
// ------------------------------------------------------------
module waste_lid() {
    wl_w = waste_x2 - waste_x1 + 2*enc_wall;  // Outer width to cover opening
    wl_d = res_y2 - res_y1 + 2*enc_wall;       // Outer depth
    difference() {
        // Lid body
        cube([wl_w, wl_d, floor_t]);
        // Lightening pockets (reduce material, keep rigidity)
        translate([enc_wall + 5, enc_wall + 5, 2])
            cube([wl_w - 2*(enc_wall+5), wl_d - 2*(enc_wall+5), floor_t]);
    }
    // Snap-fit retention lip (inner perimeter of lid underside)
    translate([enc_wall, enc_wall, -3])
        difference() {
            cube([wl_w - 2*enc_wall, wl_d - 2*enc_wall, 3 + eps]);
            translate([2, 2, -eps])
                cube([wl_w - 2*enc_wall - 4, wl_d - 2*enc_wall - 4, 5]);
        }
}

// ------------------------------------------------------------
// MODULE: electronics bay cover (electronics_cover.stl)
// Sits in the electronics bay cover ledge, screws into bosses
// ------------------------------------------------------------
module electronics_cover() {
    ec_w = elec_x2 - elec_x1;
    ec_d = elec_y2 - elec_y1;
    difference() {
        cube([ec_w, ec_d, floor_t]);
        // 4× M3 countersunk mounting holes at corners
        for (cx = [8, ec_w - 8])
            for (cy = [8, ec_d - 8]) {
                translate([cx, cy, -eps])
                    cylinder(d=m3_clr, h=floor_t + 2*eps);
                translate([cx, cy, floor_t - m3_head_h])
                    cylinder(d=m3_head_d, h=m3_head_h + eps);
            }
        // Cable pass-through slot (centre, for ESP32 wiring)
        translate([ec_w/2 - 8, ec_d/2 - 4, -eps])
            cube([16, 8, floor_t + 2*eps]);
    }
}

// ------------------------------------------------------------
// MODULE: peristaltic pump mount bracket (pump_mount.stl)
// ------------------------------------------------------------
module pump_mount() {
    plate_t = 4.0;
    wall    = 4.0;
    // Base plate
    difference() {
        cube([pump_w + 2*wall, pump_d + 2*wall, plate_t]);
        // 4× M3 holes for pump feet
        for (cx = [(pump_w + 2*wall)/2 - pump_bolt_cx/2,
                   (pump_w + 2*wall)/2 + pump_bolt_cx/2])
            for (cy = [(pump_d + 2*wall)/2 - pump_bolt_cy/2,
                       (pump_d + 2*wall)/2 + pump_bolt_cy/2])
                translate([cx, cy, -eps])
                    cylinder(d=pump_bolt_d, h=plate_t + 2*eps);
        // 4× M3 holes for mounting to base floor
        for (cx = [6, pump_w + 2*wall - 6])
            for (cy = [6, pump_d + 2*wall - 6])
                translate([cx, cy, -eps])
                    cylinder(d=m3_clr, h=plate_t + 2*eps);
    }
    // Side retention walls (hold pump against vibration)
    translate([0, 0, plate_t])
        difference() {
            cube([pump_w + 2*wall, wall, pump_h_dim/2]);
            translate([wall, -eps, wall])
                cube([pump_w, wall + 2*eps, pump_h_dim/2]);
        }
    translate([0, pump_d + wall, plate_t])
        difference() {
            cube([pump_w + 2*wall, wall, pump_h_dim/2]);
            translate([wall, -eps, wall])
                cube([pump_w, wall + 2*eps, pump_h_dim/2]);
        }
}

// ------------------------------------------------------------
// RENDER SELECTION
// ------------------------------------------------------------
if (PART == "full") {
    base_unit_geo();

} else if (PART == "front") {
    // Front half: Y = 0 to base_split
    intersection() {
        base_unit_geo();
        cube([enc_w, base_split, base_h]);
    }

} else if (PART == "rear") {
    // Rear half: Y = base_split to enc_d
    // Translate so rear half sits at Y=0 for printing
    translate([0, -base_split, 0])
        intersection() {
            base_unit_geo();
            translate([0, base_split, 0])
                cube([enc_w, enc_d - base_split, base_h]);
        }

} else if (PART == "lid_res") {
    reservoir_lid();

} else if (PART == "lid_waste") {
    waste_lid();

} else if (PART == "elec_cov") {
    electronics_cover();

} else if (PART == "pump_mnt") {
    pump_mount();

} else {
    // Default: full base
    base_unit_geo();
}
