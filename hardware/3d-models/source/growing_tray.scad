// ============================================================
// Growing Tray  (growing_tray.stl)
// ============================================================
// Outer: 250×250×50mm  (25×25cm = 625cm² growing area)
// Interior: 244×244×40mm
// 4× Ø8mm drain holes in 2×2 grid, 50mm from tray centre
// Retention lip (5mm high, 4mm wide) on outer base perimeter
//   slides into the growing tray ledge in the ring.
//
// Print orientation: upside-down (open face on bed).
//   Footprint: 250×250mm.  Requires 250mm bed in both axes.
//   NOTE: A 200mm bed is insufficient; 250mm minimum required.
//   Alternative: split into 2 halves at X=125mm (150mm bed OK).
//
// Material: PETG.  No supports needed.
// Post-process: none required (not a sealed water chamber).
// ============================================================

include <params.scad>

module growing_tray() {
    difference() {

        // --- Outer tray body ---
        cube([tray_w, tray_d, tray_h]);

        // --- Interior void (open top) ---
        translate([tray_wall, tray_wall, tray_floor])
            cube([tray_w - 2*tray_wall,
                  tray_d - 2*tray_wall,
                  tray_h - tray_floor + eps]);

        // --- 4× drain holes (2×2 grid in tray floor) ---
        // Holes at (125±50, 125±50) = (75,75), (75,175), (175,75), (175,175)
        cx = tray_w / 2;
        cy = tray_d / 2;
        for (dx = [-drain_inset, drain_inset])
            for (dy = [-drain_inset, drain_inset])
                translate([cx + dx, cy + dy, -eps])
                    cylinder(d=drain_d, h=tray_floor + 2*eps);

    } // end difference

    // --- Retention lip (outside of tray base perimeter) ---
    // This lip slides under the growing-tray ledge rails inside the ring,
    // holding the tray against ejection during vehicle motion.
    translate([0, 0, -tray_lip_h])
        difference() {
            cube([tray_w + 2*tray_lip_w,
                  tray_d + 2*tray_lip_w,
                  tray_lip_h]);
            translate([tray_lip_w, tray_lip_w, -eps])
                cube([tray_w, tray_d, tray_lip_h + 2*eps]);
        }
}

growing_tray();
