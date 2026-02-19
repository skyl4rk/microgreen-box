// ============================================================
// Top Cap
// ============================================================
// Outer: 300×300×80mm
// Contains:
//   - Seed storage box (60×60×50mm sealed, with slide lid)
//   - Bag/marker tray (80×80×30mm open)
//   - OLED display window (28×14mm cutout with clear PETG lens)
//   - 4× Status LED holes (Ø3.5mm)
//   - Integral handle (arch, 80mm span)
//   - Stack bolt holes (M3, mates with top tray ring)
//
// PART variable:
//   "body"       — main top cap body
//   "seed_lid"   — sliding lid for seed storage box
//
// Print orientation: flat (bottom face on bed).
//   Footprint: 300×300mm. Requires 300mm bed.
//   Alternative: split front/rear at Y=150 (each 300×150×80mm;
//   print standing on 150×80mm face, needs 300mm of bed width).
//
// Material: PETG, 25% infill.
// ============================================================

include <params.scad>

PART = "body";   // Override: openscad -D 'PART="seed_lid"' ...

// Convenient internal dims
cw = enc_w;   // = 300mm
cd = enc_d;   // = 300mm
ch = cap_h;   // = 80mm

// ---- Layout positions (all relative to cap origin at bottom-left-front) -----
// Seed box: rear-left quadrant
seed_x = enc_wall + 10;
seed_y = enc_d - enc_wall - seed_d - 10;

// Bag/marker tray: rear-right quadrant
bag_x  = enc_w - enc_wall - bag_w - 10;
bag_y  = enc_d - enc_wall - bag_d - 10;

// OLED window: front face (Y=0 outer wall), centred
oled_x = (enc_w - oled_cw) / 2;
oled_z = ch * 0.4;   // ~32mm from bottom

// Status LED strip: front face, above OLED
status_strip_x = (enc_w - (status_n - 1) * led_spacing * 2) / 2;
status_z       = oled_z + oled_ch + 10;

// Handle: centred top surface
handle_x = (enc_w - handle_span) / 2;
handle_y = (enc_d - handle_t) / 2;

// ============================================================
// MODULE: top cap body
// ============================================================
module top_cap_body() {
    difference() {
        union() {

            // --- Outer shell ---
            cube([cw, cd, ch]);

            // --- Handle arch (integral, top surface) ---
            translate([handle_x, handle_y, ch])
                handle_arch();

            // --- Fan mount pad (top surface, rear area — DECISION-024) ---
            // The interior is hollow at the top (only perimeter walls remain).
            // This solid pad provides material for the fan exhaust hole, body recess,
            // and M3 mounting bolts. Centred on fan_x/fan_y from params.scad.
            translate([fan_x - (fan_recess_d + 10) / 2,
                       fan_y - (fan_recess_d + 10) / 2,
                       ch - enc_wall])
                cube([fan_recess_d + 10, fan_recess_d + 10, enc_wall]);

        } // end union

        // --- Main interior void ---
        translate([enc_wall, enc_wall, enc_wall])
            cube([cw - 2*enc_wall, cd - 2*enc_wall, ch]);

        // --- Seed storage box cavity (rear-left) ---
        translate([seed_x, seed_y, enc_wall])
            cube([seed_w, seed_d, seed_h]);

        // --- Bag/marker tray cavity (rear-right) ---
        translate([bag_x, bag_y, enc_wall])
            cube([bag_w, bag_d, bag_h]);

        // --- OLED display window (front outer wall, Y=0 face) ---
        translate([oled_x, -eps, oled_z])
            cube([oled_cw, enc_wall + 2*eps, oled_ch]);

        // --- 4× Status LED holes (front outer wall, above OLED) ---
        for (i = [0:status_n-1])
            translate([status_strip_x + i * led_spacing * 2,
                       -eps,
                       status_z])
                rotate([-90, 0, 0])
                    cylinder(d=status_d, h=enc_wall + 2*eps);

        // --- Stack bolt holes: bottom face (6× M3 for top ring attachment) ---
        for (bx = ring_bolt_xs) {
            translate([bx, ring_bolt_y1, -eps])
                cylinder(d=m3_clr, h=enc_wall + 2*eps);
            translate([bx, ring_bolt_y2, -eps])
                cylinder(d=m3_clr, h=enc_wall + 2*eps);
        }

        // --- Seed box lid slot (top face, at seed box location) ---
        // Slide-in lid track: 2mm groove on each long side of seed box opening
        translate([seed_x - 1, seed_y, ch - enc_wall - eps])
            cube([seed_w + 2, seed_d, enc_wall + 2*eps]);

        // --- Wire entry from ring below (centre, bottom face) ---
        // ESP32 status wire, sensor wires up through cap
        translate([cw/2 - 4, cd/2 - 4, -eps])
            cube([8, 8, enc_wall + 2*eps]);

        // --- Ventilation fan exhaust hole (top surface — DECISION-024) ---
        // 40mm brushless fan exhausts upward. Fan label/inlet side faces INTO cap.
        // fan_x=150 (centred); fan_y=220 (rear half, clear of handle arch at Y≈145).
        translate([fan_x, fan_y, ch - enc_wall - eps])
            cylinder(d=fan_hole_d, h=enc_wall + 2*eps);

        // --- Fan body recess (fan body sits flush with top surface) ---
        // 2mm deep, fan_recess_d=42mm OD seats the 40mm fan body.
        translate([fan_x, fan_y, ch - fan_recess_t])
            cylinder(d=fan_recess_d, h=fan_recess_t + eps);

        // --- 4× M3 fan mounting holes (standard 40mm fan bolt pattern) ---
        // fan_bolt_ctc = 32mm; bolts at corners of 32×32mm square centred on fan.
        for (dx = [-fan_bolt_ctc/2, fan_bolt_ctc/2])
            for (dy = [-fan_bolt_ctc/2, fan_bolt_ctc/2])
                translate([fan_x + dx, fan_y + dy, ch - enc_wall - eps])
                    cylinder(d=m3_clr, h=enc_wall + 2*eps);

        // --- Toggle switch panel-cut hole (front face, right side — DECISION-024) ---
        // SPST toggle switch: 12V_bus → switch → fan+  (no relay, no firmware).
        // switch_x=255 (right of status LEDs at X≈120–180); switch_z=50 (between
        // OLED window top at Z≈46 and status LED strip bottom at Z≈54).
        translate([switch_x, -eps, switch_z])
            rotate([-90, 0, 0])
                cylinder(d=switch_hole_d, h=enc_wall + 2*eps);

    } // end difference

    // --- Seed storage box walls (raised above cap floor) ---
    translate([seed_x - enc_wall, seed_y - enc_wall, enc_wall])
        difference() {
            cube([seed_w + 2*enc_wall, seed_d + 2*enc_wall, seed_h + enc_wall]);
            translate([enc_wall, enc_wall, -eps])
                cube([seed_w, seed_d, seed_h + enc_wall + eps]);
            // Lid track groove (top, both long sides)
            for (gx = [0, seed_w + enc_wall]) {
                translate([gx, enc_wall/2, seed_h + enc_wall - 3])
                    cube([enc_wall, seed_d + enc_wall, 3 + eps]);
            }
        }

} // end top_cap_body

// ------------------------------------------------------------
// MODULE: handle arch
// ------------------------------------------------------------
module handle_arch() {
    // Arch: two vertical pillars + horizontal top bar
    // Outer span: handle_span = 80mm, height: handle_rise = 25mm
    post_w = handle_t;
    post_d = handle_t;
    bar_h  = handle_t;

    // Left post
    cube([post_w, post_d, handle_rise]);
    // Right post
    translate([handle_span - post_w, 0, 0])
        cube([post_w, post_d, handle_rise]);
    // Top bar
    translate([0, 0, handle_rise - bar_h])
        cube([handle_span, post_d, bar_h]);
}

// ------------------------------------------------------------
// MODULE: seed storage box sliding lid (seed_box_lid.stl)
// ------------------------------------------------------------
module seed_lid() {
    lid_w    = seed_w - 0.5;   // slight clearance
    lid_d    = seed_d + enc_wall * 2 - 0.5;
    lid_t    = enc_wall;

    difference() {
        cube([lid_w, lid_d, lid_t]);
        // Track rails on underside (grip the lid slot)
        for (gx = [0, lid_w - enc_wall]) {
            translate([gx, 0, -eps])
                cube([enc_wall, lid_d, lid_t/2]);
        }
        // Finger pull slot (front edge, centre)
        translate([lid_w/2 - 10, -eps, -eps])
            cube([20, enc_wall + 2*eps, lid_t + 2*eps]);
    }
    // Tab pull at front
    translate([lid_w/2 - 8, -6, 0])
        cube([16, 6, lid_t]);
}

// ------------------------------------------------------------
// RENDER SELECTION
// ------------------------------------------------------------
if (PART == "body") {
    top_cap_body();
} else if (PART == "seed_lid") {
    seed_lid();
} else {
    top_cap_body();
}
