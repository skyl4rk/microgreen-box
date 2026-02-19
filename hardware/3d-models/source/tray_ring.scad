// ============================================================
// Tray Ring (one level)
// ============================================================
// Outer: 300×300×190mm
// Contains one grow level: sub-tray pocket, grow tray shelf,
// LED bracket mounting rail, front door, drip inlet port.
//
// PART selects what to render:
//   "full"  — complete assembled ring (reference)
//   "FL"    — front-left corner quarter  (print on 150×150mm face)
//   "FR"    — front-right corner quarter
//   "RL"    — rear-left corner quarter
//   "RR"    — rear-right corner quarter
//
// The ring is split into 4 corner-quarter (L-shaped) sections.
// Each quarter fits on a 200×200mm bed when printed standing up:
//   footprint 150×150mm, height = ring_h = 190mm (≤200mm build height).
// Quarters join at vertical seams at X=150mm and Y=150mm.
// Seams sealed with RTV silicone; bolted with 2× M3 per seam.
//
// Stack join: M3 bolts through top/bottom flanges connect rings
// to each other and to the base unit below.
// Light-seal: 2mm inward lip at top and bottom of each ring.
// ============================================================

include <params.scad>

PART = "full";  // Override: openscad -D 'PART="FL"' ...

// Quarter split boundaries
qx = ring_split_x;   // = 150mm
qy = ring_split_y;   // = 150mm

// ------------------------------------------------------------
// MODULE: complete tray ring geometry (assembled)
// ------------------------------------------------------------
module tray_ring_geo() {
    difference() {

        // --- Outer shell ---
        cube([enc_w, enc_d, ring_h]);

        // --- Main interior void ---
        translate([enc_wall, enc_wall, flange_h])
            cube([enc_int_w, enc_int_d, ring_h - 2*flange_h + eps]);

        // --- Front door aperture ---
        // Width: door_w=150mm, centred at X=150
        // Height: door_h_open = ring_h - 2*flange_h, Z=flange_h
        translate([door_x0, -eps, door_z0])
            cube([door_w, enc_wall + 2*eps, door_h_open]);

        // --- Drip inlet port (rear wall, centred) ---
        translate([drip_port_x, enc_d - enc_wall - eps, drip_port_z])
            rotate([90, 0, 0])  // horizontal hole through rear wall
                cylinder(d=drip_port_d, h=enc_wall + 2*eps);

        // --- LED wire pass-through slot (front wall, above door) ---
        translate([led_wire_x - led_wire_w/2,
                   -eps,
                   led_wire_z - led_wire_h/2])
            cube([led_wire_w, enc_wall + 2*eps, led_wire_h]);

        // --- Stack bolt holes: bottom flange (6× M3) ---
        for (bx = ring_bolt_xs) {
            translate([bx, ring_bolt_y1, -eps])
                cylinder(d=m3_clr, h=flange_h + 2*eps);
            translate([bx, ring_bolt_y2, -eps])
                cylinder(d=m3_clr, h=flange_h + 2*eps);
        }

        // --- Stack bolt holes: top flange (6× M3) ---
        for (bx = ring_bolt_xs) {
            translate([bx, ring_bolt_y1, ring_h - flange_h - eps])
                cylinder(d=m3_clr, h=flange_h + 2*eps);
            translate([bx, ring_bolt_y2, ring_h - flange_h - eps])
                cylinder(d=m3_clr, h=flange_h + 2*eps);
        }

        // --- Ventilation slot covers (open for passive convection) ---
        // Two 25mm-wide slots at top of ring (front and rear walls)
        // Slide covers in STL are separate small printed caps
        translate([enc_w/2 - 12.5, -eps, ring_h - flange_h - 12])
            cube([25, enc_wall + 2*eps, 8]);
        translate([enc_w/2 - 12.5, enc_d - enc_wall - eps, ring_h - flange_h - 12])
            cube([25, enc_wall + 2*eps, 8]);

    } // end difference

    // --- Sub-tray ledge rails (left and right inner walls) ---
    // Protrude ledge_w=6mm inward at Z=sub_ledge_z, thickness=ledge_t=4mm
    // Only on left (X=enc_wall face) and right (X=enc_w-enc_wall face) walls
    // Left ledge
    translate([enc_wall, enc_wall, sub_ledge_z + flange_h])
        cube([ledge_w, enc_int_d, ledge_t]);
    // Right ledge
    translate([enc_w - enc_wall - ledge_w, enc_wall, sub_ledge_z + flange_h])
        cube([ledge_w, enc_int_d, ledge_t]);

    // --- Growing tray ledge rails ---
    // Z=grow_ledge_z above ring floor (inside flange)
    translate([enc_wall, enc_wall, grow_ledge_z + flange_h])
        cube([ledge_w, enc_int_d, ledge_t]);
    translate([enc_w - enc_wall - ledge_w, enc_wall, grow_ledge_z + flange_h])
        cube([ledge_w, enc_int_d, ledge_t]);

    // --- Light-seal lip: bottom flange (2mm inward step) ---
    translate([enc_wall + seal_lip, enc_wall + seal_lip, 0])
        difference() {
            cube([enc_int_w - 2*seal_lip, enc_int_d - 2*seal_lip, flange_h]);
            translate([enc_wall, enc_wall, -eps])
                cube([enc_int_w - 2*(enc_wall + seal_lip),
                      enc_int_d - 2*(enc_wall + seal_lip),
                      flange_h + 2*eps]);
        }

    // --- Light-seal lip: top flange ---
    translate([enc_wall + seal_lip, enc_wall + seal_lip, ring_h - flange_h])
        difference() {
            cube([enc_int_w - 2*seal_lip, enc_int_d - 2*seal_lip, flange_h]);
            translate([enc_wall, enc_wall, -eps])
                cube([enc_int_w - 2*(enc_wall + seal_lip),
                      enc_int_d - 2*(enc_wall + seal_lip),
                      flange_h + 2*eps]);
        }

    // --- Door hinge bosses (left edge of door aperture, front wall) ---
    // 3 knuckle bosses evenly spaced along door height
    hinge_spacing = door_h_open / (hinge_count + 1);
    for (i = [1:hinge_count]) {
        translate([door_x0, 0, door_z0 + i * hinge_spacing])
            difference() {
                cylinder(d=hinge_boss, h=enc_wall + 4);
                translate([0, 0, -eps])
                    cylinder(d=hinge_d, h=enc_wall + 5);
            }
    }

    // --- Door catch magnet pocket (right edge of door aperture, front wall) ---
    translate([door_x0 + door_w, 0, door_z0 + door_h_open/2]) {
        difference() {
            cube([6, enc_wall + 6, 12], center=true);
            translate([0, 0, 0])
                cylinder(d=magnet_d, h=magnet_dep + 1, center=true);
        }
    }

    // --- LED bracket mounting rail (rear inner wall) ---
    // A vertical T-slot or flat boss for LED bracket attachment
    // Centred on rear wall, runs full height between flanges
    translate([enc_w/2 - led_panel_w/2 - 6,
               enc_d - enc_wall - 8,
               flange_h])
        cube([led_panel_w + 12, 8, ring_h - 2*flange_h]);

    // --- Quarter seam bolt bosses (at X=150 and Y=150 seams) ---
    // 2× M3 bolt holes per seam, on each quarter piece
    seam_bolt_zs = [ring_h * 0.3, ring_h * 0.7];
    // X=150 seam bosses (front and rear walls)
    for (sz = seam_bolt_zs) {
        translate([qx - m3_boss_d/2, 0, sz - m3_boss_d/2])
            difference() {
                cube([m3_boss_d, enc_wall + 4, m3_boss_d]);
                translate([m3_boss_d/2, -eps, m3_boss_d/2])
                    rotate([-90, 0, 0])
                        cylinder(d=m3_clr, h=enc_wall + 5);
            }
        translate([qx - m3_boss_d/2, enc_d - enc_wall - 4, sz - m3_boss_d/2])
            difference() {
                cube([m3_boss_d, enc_wall + 4, m3_boss_d]);
                translate([m3_boss_d/2, -eps, m3_boss_d/2])
                    rotate([-90, 0, 0])
                        cylinder(d=m3_clr, h=enc_wall + 5);
            }
    }

} // end tray_ring_geo

// ------------------------------------------------------------
// Helper: render one corner quarter by intersection + translate
// cx, cy = corner multipliers: 0=low side, 1=high side
// ------------------------------------------------------------
module ring_quarter(cx, cy) {
    // Reposition so the quarter sits at origin for printing
    translate([-cx*qx, -cy*qy, 0])
        intersection() {
            tray_ring_geo();
            translate([cx*qx, cy*qy, 0])
                cube([qx + eps, qy + eps, ring_h]);
        }
}

// ------------------------------------------------------------
// RENDER SELECTION
// ------------------------------------------------------------
if (PART == "full") {
    tray_ring_geo();

} else if (PART == "FL") {
    // Front-left quarter (X=0..150, Y=0..150)
    ring_quarter(0, 0);

} else if (PART == "FR") {
    // Front-right quarter (X=150..300, Y=0..150)
    ring_quarter(1, 0);

} else if (PART == "RL") {
    // Rear-left quarter (X=0..150, Y=150..300)
    ring_quarter(0, 1);

} else if (PART == "RR") {
    // Rear-right quarter (X=150..300, Y=150..300)
    ring_quarter(1, 1);

} else {
    tray_ring_geo();
}
