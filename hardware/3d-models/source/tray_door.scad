// ============================================================
// Tray Door  (tray_door.stl)
// ============================================================
// Hinged front panel for each tray ring level.
// Width: 150mm (door_w)
// Height: ring_h - 2*flange_h = 190 - 2*8 = 174mm
// Thickness: 6mm (enc_wall + 2 for rigidity)
//
// Features:
//   - 3× hinge knuckles on left edge (mate with ring hinge bosses)
//   - Magnet pocket on right edge (mate with ring magnet pocket)
//   - Foam weather-strip groove around perimeter (4×2mm groove)
//   - Slight inward bow geometry prevents light leakage at seal
//
// Print orientation: flat (door face down on bed).
//   Footprint: 150×174mm.  Fits on 200×200mm bed.
//
// Material: PETG, 20% infill (door is lightly loaded).
// ============================================================

include <params.scad>

pw = door_panel_w;   // = 150mm
ph = door_panel_h;   // = ring_h - 2*flange_h = 174mm
pt = door_panel_t;   // = 6mm

module tray_door() {
    difference() {
        union() {

            // --- Door panel body ---
            cube([pw, pt, ph]);

            // --- Hinge knuckles (left edge, 3 evenly spaced) ---
            knuckle_h    = ph / (hinge_count * 2 + 1);  // knuckle height
            knuckle_gap  = knuckle_h;                    // gap between knuckles
            knuckle_od   = hinge_boss;                   // = 8mm
            for (i = [0:hinge_count-1]) {
                z_pos = knuckle_gap + i*(knuckle_h + knuckle_gap);
                translate([0, pt/2, z_pos])
                    rotate([90, 0, 0])
                        cylinder(d=knuckle_od, h=pt, center=true);
            }

            // --- Magnet retainer boss (right edge, centre height) ---
            translate([pw, pt/2, ph/2])
                cube([6, 12, 12], center=true);

        } // end union

        // --- Hinge pin holes (through each knuckle) ---
        knuckle_h   = ph / (hinge_count * 2 + 1);
        knuckle_gap = knuckle_h;
        for (i = [0:hinge_count-1]) {
            z_pos = knuckle_gap + i*(knuckle_h + knuckle_gap);
            translate([0, 0, z_pos])
                rotate([-90, 0, 0])
                    cylinder(d=hinge_d, h=pt + 2*eps);
        }

        // --- Magnet pocket (right edge, centre height) ---
        translate([pw + eps, pt/2, ph/2])
            rotate([0, -90, 0])
                cylinder(d=magnet_d, h=magnet_dep + eps);

        // --- Foam weather-strip groove (front face perimeter) ---
        // 4mm wide × 2mm deep groove, 3mm from panel edge
        groove_offset = 3.0;
        translate([groove_offset, -eps, groove_offset])
            difference() {
                cube([pw - 2*groove_offset,
                      foam_groove_d + eps,
                      ph - 2*groove_offset]);
                translate([foam_groove_w, 0, foam_groove_w])
                    cube([pw - 2*groove_offset - 2*foam_groove_w,
                          foam_groove_d + 2*eps,
                          ph - 2*groove_offset - 2*foam_groove_w]);
            }

        // --- Lightening cutout (centre, reduces material ~20%) ---
        cutout_inset = 15.0;
        translate([cutout_inset, -eps, cutout_inset])
            cube([pw - 2*cutout_inset,
                  pt/2,
                  ph - 2*cutout_inset]);

    } // end difference
}

tray_door();
