// ============================================================
// Miscellaneous Small Parts
// ============================================================
// PART variable selects which part to render:
//
//   "tube_clip"   — silicone tubing saddle clip (×12 per build)
//   "manifold"    — 3-way water manifold (1-to-3 drip splitter)
//   "drip_emit"   — drip emitter cap (×3 per build)
//   "led_panel"   — status LED mounting panel (×1, for top cap)
//   "pump_mnt"    — peristaltic pump base bracket
//   "all"         — render all parts exploded (for preview only)
//
// All parts fit on a 200×200mm print bed.
// Material: PETG.  Infill: 50–60% (functional load-bearing parts).
// ============================================================

include <params.scad>

PART = "tube_clip";  // Override: openscad -D 'PART="manifold"' ...

// ============================================================
// MODULE: tube saddle clip (tube_clip.stl)
// ============================================================
// Clips around 6mm OD silicone tubing, screws to enclosure wall.
// Used every ~50mm along tubing runs inside the column.
// Print orientation: flat (base on bed). ~20×20mm footprint.
// ============================================================
module tube_clip() {
    body_h = tube_od + clip_body_t * 2;   // Total height around tube
    body_d = clip_body_t + tube_od/2;     // Depth (half-pipe clip)

    difference() {
        union() {
            // Clip body (U-channel around tube)
            translate([-clip_body_w/2, 0, 0])
                cube([clip_body_w, body_d, body_h]);

            // Mounting tab (flat tab with screw hole)
            translate([-clip_tab_w/2, -clip_tab_h, 0])
                cube([clip_tab_w, clip_tab_h + body_d, body_h]);
        }

        // Tube bore (half-round channel)
        translate([0, clip_body_t + tube_od/2, body_h/2])
            rotate([90, 0, 0])
                cylinder(d=tube_od + tol, h=body_d + eps);

        // Clip opening slot at top (allows tube to snap in)
        translate([-tube_od/2 - tol, clip_body_t, body_h - tube_od/2 - tol])
            cube([tube_od + 2*tol, body_d + eps, tube_od/2 + tol + eps]);

        // Mounting screw hole (self-tap M2.5)
        translate([0, -clip_tab_h/2, body_h/2])
            rotate([-90, 0, 0])
                cylinder(d=clip_screw_d, h=clip_tab_h + body_d + eps);
    }
}

// ============================================================
// MODULE: 3-way water manifold (manifold_3way.stl)
// ============================================================
// 1 inlet (for 6mm ID pump tubing) → 3 outlets (for 4mm ID drip tubing).
// Press-fit barbed connections; 60% infill for pressure resistance.
// Print orientation: flat. Footprint ~60×30mm.
// Post-process: test with water pressure before installation.
// ============================================================
module manifold_3way() {
    olap      = 2.0;        // overlap of barbs into body to ensure solid union
    inlet_len = mani_barb_l + 6;

    // Centre body
    cylinder(d=mani_body_d, h=mani_body_d);

    // Inlet barb — starts olap mm INSIDE the body top so union is solid
    translate([0, 0, mani_body_d - olap]) {
        cylinder(d=mani_in_d, h=inlet_len + olap);
        // Retention ridge (positioned relative to external start)
        translate([0, 0, olap + inlet_len - 6])
            cylinder(d1=mani_in_d, d2=mani_in_d + 2*mani_barb_step, h=3);
        translate([0, 0, olap + inlet_len - 3])
            cylinder(d1=mani_in_d + 2*mani_barb_step, d2=mani_in_d, h=3);
    }

    // 3 outlet barbs — start olap mm INSIDE the body surface so union is solid
    for (a = [0, 120, 240]) {
        rotate([0, 0, a])
            translate([mani_body_d/2 - olap, 0, mani_body_d/2])
                rotate([0, 90, 0]) {
                    cylinder(d=mani_out_d, h=mani_barb_l + olap);
                    // Retention ridge (positioned relative to external start)
                    translate([0, 0, olap + mani_barb_l - 5])
                        cylinder(d1=mani_out_d,
                                 d2=mani_out_d + 2*mani_barb_step, h=2.5);
                    translate([0, 0, olap + mani_barb_l - 2.5])
                        cylinder(d1=mani_out_d + 2*mani_barb_step,
                                 d2=mani_out_d, h=2.5);
                }
    }

}

// Manifold with bores (final part)
module manifold_3way_final() {
    difference() {
        manifold_3way();

        // All internal channel voids joined before subtraction to avoid
        // CGAL non-manifold errors from overlapping cylinder booleans.
        union() {
            // Junction sphere at body centre — cleanly connects all four channels
            translate([0, 0, mani_body_d/2])
                sphere(r=mani_in_d/2);

            // Inlet bore (through inlet barb and full body height)
            translate([0, 0, -eps])
                cylinder(d=mani_in_d - 2.5,
                         h=mani_body_d + 6 + mani_barb_l + 2*eps);

            // Outlet bores — from centre sphere through each barb
            for (a = [0, 120, 240])
                rotate([0, 0, a])
                    translate([0, 0, mani_body_d/2])
                        rotate([0, 90, 0])
                            cylinder(d=mani_out_d - 2.5,
                                     h=mani_body_d/2 + mani_barb_l + 2 + 2*eps);
        }
    }
}

// ============================================================
// MODULE: drip emitter (drip_emitter.stl ×3)
// ============================================================
// Press-fits onto end of 6mm OD drip tubing.
// 2mm orifice delivers controlled drip flow onto coir surface.
// Print orientation: upright (Z = long axis). ~10×10mm footprint.
// ============================================================
module drip_emitter() {
    difference() {
        union() {
            // Body cylinder
            cylinder(d=emit_od, h=emit_len);
            // Barb for tubing retention (near open end)
            translate([0, 0, emit_len - 6])
                cylinder(d1=emit_od, d2=emit_od + 2, h=3);
            translate([0, 0, emit_len - 3])
                cylinder(d1=emit_od + 2, d2=emit_od, h=3);
        }

        // Internal bore (tapers to orifice)
        translate([0, 0, -eps])
            cylinder(d=emit_barb_d, h=4 + eps);         // open end (tube insert)
        translate([0, 0, 4])
            cylinder(d1=emit_barb_d, d2=emit_orifice,    // taper
                     h=emit_len - 4 - eps);
        translate([0, 0, emit_len - 2])
            cylinder(d=emit_orifice, h=2 + eps);         // orifice exit
    }
}

// ============================================================
// MODULE: status LED panel (led_panel.stl)
// ============================================================
// Thin panel with 4× 3mm LED holes, mounts in top cap front wall.
// Replaces manual hole-making for LED placement.
// Print orientation: flat. 50×12mm footprint.
// ============================================================
module led_panel_mount() {
    difference() {
        // Panel body
        cube([led_pan_w, led_pan_t, led_pan_h]);

        // 4× LED holes (centred vertically)
        for (i = [0:status_n-1])
            translate([led_pan_w/2 - (status_n-1)*led_spacing/2 + i*led_spacing,
                       -eps,
                       led_pan_h/2])
                rotate([-90, 0, 0])
                    cylinder(d=status_d, h=led_pan_t + 2*eps);

        // 2× M2 mounting holes at panel ends
        for (mx = [3, led_pan_w - 3])
            translate([mx, -eps, led_pan_h/2])
                rotate([-90, 0, 0])
                    cylinder(d=2.2, h=led_pan_t + 2*eps);
    }
}

// ============================================================
// RENDER SELECTION
// ============================================================
if (PART == "tube_clip") {
    tube_clip();

} else if (PART == "manifold") {
    manifold_3way_final();

} else if (PART == "drip_emit") {
    drip_emitter();

} else if (PART == "led_panel") {
    led_panel_mount();

} else if (PART == "all") {
    // Exploded preview of all misc parts
    tube_clip();
    translate([30, 0, 0]) manifold_3way_final();
    translate([80, 0, 0]) drip_emitter();
    translate([110, 0, 0]) led_panel_mount();

} else {
    tube_clip();
}
