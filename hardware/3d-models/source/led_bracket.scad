// ============================================================
// LED Bracket  (led_bracket.stl)
// ============================================================
// Mounts on the LED rail on the rear inner wall of each tray ring.
// Holds a 100×100mm LED panel above the growing tray.
// Vertical adjustment slot allows ±15mm from nominal position
// (nominal LED height: 100mm above tray surface).
//
// Print orientation: flat (largest face down).
//   Footprint: ~120×140mm.  Fits on 200×200mm bed.
//
// Assembly:
//   1. Slide bracket onto ring's rear LED rail.
//   2. Set LED panel into the panel pocket.
//   3. Secure with 2× M3×12mm bolts through adjustment slot.
//   4. Route LED cable through ring's front wall pass-through.
//
// Material: PETG, 30% infill.
// ============================================================

include <params.scad>

module led_bracket() {

    // Wall-mount flange (attaches to ring rear inner wall rail)
    // Width: led_panel_w + 2*brkt_flange_w = 124mm
    // Depth: 16mm (fits over 8mm rail, 8mm clearance)
    flange_total_w = led_panel_w + 2*brkt_flange_w;
    flange_depth   = enc_wall + 8;   // Rail thickness + clearance

    // Overall bracket arm length (from wall to LED panel face)
    arm_len = led_nom_h - grow_ledge_z - tray_h + 20;

    difference() {
        union() {

            // --- Wall-mount flange ---
            cube([flange_total_w, flange_depth, brkt_arm_t]);

            // --- Vertical adjustment arms (left and right) ---
            // Connect flange to LED panel pocket
            // Left arm
            translate([0, 0, 0])
                cube([brkt_arm_t, flange_depth, arm_len]);
            // Right arm
            translate([flange_total_w - brkt_arm_t, 0, 0])
                cube([brkt_arm_t, flange_depth, arm_len]);

            // --- LED panel pocket (at top of arms) ---
            // Pocket: led_panel_w + 2mm clearance wide, 4mm deep
            translate([brkt_flange_w - 1, 0, arm_len - led_panel_t - 2])
                cube([led_panel_w + 2, flange_depth, led_panel_t + 2]);

            // --- LED panel retainer lip (prevents panel sliding forward) ---
            translate([brkt_flange_w - 1, flange_depth - 2, arm_len])
                cube([led_panel_w + 2, 2, 4]);

        } // end union

        // --- Vertical adjustment slot (centred on left arm) ---
        // Allows M3 bolt to slide ±15mm from nominal position
        translate([brkt_arm_t/2,
                   flange_depth/2,
                   arm_len/2 - brkt_slot_l/2])
            union() {
                // Slot body
                translate([0, 0, brkt_slot_w/2])
                    cube([brkt_slot_w, flange_depth + 2*eps, brkt_slot_l - brkt_slot_w],
                         center=true);
                // Round ends
                translate([0, 0, brkt_slot_l/2])
                    rotate([90, 0, 0])
                        cylinder(d=brkt_slot_w, h=flange_depth + 2*eps, center=true);
                translate([0, 0, -brkt_slot_l/2 + brkt_slot_w])
                    rotate([90, 0, 0])
                        cylinder(d=brkt_slot_w, h=flange_depth + 2*eps, center=true);
            }

        // --- Same slot on right arm ---
        translate([flange_total_w - brkt_arm_t/2,
                   flange_depth/2,
                   arm_len/2 - brkt_slot_l/2])
            union() {
                translate([0, 0, brkt_slot_w/2])
                    cube([brkt_slot_w, flange_depth + 2*eps, brkt_slot_l - brkt_slot_w],
                         center=true);
                translate([0, 0, brkt_slot_l/2])
                    rotate([90, 0, 0])
                        cylinder(d=brkt_slot_w, h=flange_depth + 2*eps, center=true);
                translate([0, 0, -brkt_slot_l/2 + brkt_slot_w])
                    rotate([90, 0, 0])
                        cylinder(d=brkt_slot_w, h=flange_depth + 2*eps, center=true);
            }

        // --- Rail clip slot (underside of flange, grips ring LED rail) ---
        // T-slot: 8mm wide, 5mm deep — snaps onto ring's rear wall rail
        translate([brkt_flange_w + 2, -eps, -eps])
            cube([led_panel_w - 4, 5, brkt_arm_t + 2*eps]);

        // --- LED panel LED holes (2× M3 for panel retention, optional) ---
        for (hx = [brkt_flange_w + led_panel_w * 0.25,
                   brkt_flange_w + led_panel_w * 0.75])
            translate([hx, flange_depth/2, arm_len - led_panel_t - 2 - eps])
                cylinder(d=m3_clr, h=led_panel_t + 4);

    } // end difference
}

led_bracket();
