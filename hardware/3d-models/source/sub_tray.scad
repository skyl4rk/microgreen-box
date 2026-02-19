// ============================================================
// Sub-Tray  (sub_tray.stl)
// ============================================================
// Outer: 256×256×40mm  (sits below growing tray, catches drain water)
// Sealed base with:
//   - Overflow port: Ø8mm on right wall (X=sub_w), Z=25mm — routes to waste
//   - Drain fitting: Ø8.5mm on rear wall (Y=sub_d), Z=10mm — waste tube
//
// Print orientation: upside-down (open top on bed).
//   Footprint: 256×256mm. Minimum bed: 256mm in both axes.
//   NOTE: 200mm bed insufficient; 256mm minimum required.
//   Alternative: print in 2 halves at X=128mm.
//
// CRITICAL post-process: coat all interior surfaces with XTC-3D
//   epoxy (2 coats) or 3–4 coats Rustoleum Crystal Clear.
//   Test: fill with water, leave 24h, check for weeping. (Q-008)
//
// Material: PETG, 40% infill, 4 perimeters, 6 top/bottom layers.
// ============================================================

include <params.scad>

module sub_tray() {
    difference() {

        // --- Outer sealed body ---
        cube([sub_w, sub_d, sub_h]);

        // --- Interior void (open top) ---
        translate([sub_wall, sub_wall, sub_floor])
            cube([sub_w - 2*sub_wall,
                  sub_d - 2*sub_wall,
                  sub_h - sub_floor + eps]);

        // --- Overflow port: right wall (X=sub_w face) ---
        // At Z=overflow_z (25mm above sub floor interior = sub_floor + 25mm)
        translate([sub_w - sub_wall - eps,
                   sub_w / 2,
                   sub_floor + overflow_z])
            rotate([0, 90, 0])
                cylinder(d=overflow_d, h=sub_wall + 2*eps);

        // --- Drain fitting port: rear wall (Y=sub_d face) ---
        // At Z=10mm (above floor), for push-fit 6mm OD waste tube
        translate([sub_w / 2,
                   sub_d - sub_wall - eps,
                   sub_floor + 10])
            rotate([90, 0, 0])
                cylinder(d=drain_fit_d, h=sub_wall + 2*eps);

    } // end difference

    // --- Drain fitting barb (inside wall, push-fit collar) ---
    // Retains the silicone waste tube on the inside face
    translate([sub_w / 2,
               sub_d - sub_wall - 4,
               sub_floor + 10])
        rotate([90, 0, 0])
            difference() {
                cylinder(d=drain_fit_d + 4, h=4);
                cylinder(d=drain_fit_d,     h=4 + eps);
            }

    // --- Overflow port barb (outside face, for waste tube) ---
    translate([sub_w,
               sub_w / 2,
               sub_floor + overflow_z])
        rotate([0, 90, 0])
            difference() {
                cylinder(d=overflow_d + 4, h=6);
                cylinder(d=overflow_d,     h=6 + eps);
            }
}

sub_tray();
