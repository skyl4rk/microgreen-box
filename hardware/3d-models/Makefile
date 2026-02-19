# ============================================================
# Microgreen Box — OpenSCAD STL Export Makefile
# ============================================================
# Usage:
#   make all          — build all STL files
#   make clean        — remove all generated STLs
#   make stl/<part>   — build a specific STL
#
# Requirements:
#   openscad >= 2021.01  (install: sudo apt install openscad
#                         or download from https://openscad.org)
#
# STL export format: binary STL (smaller files)
# Quality: $fn=64 for production (overrides params.scad default of 48)
# ============================================================

OPENSCAD  = openscad
SRC       = source
STLDIR    = stl
FN        = 64
SCAD_FLAGS = --export-format binstl -D '$$fn=$(FN)'

# All STL targets
STLS = \
  $(STLDIR)/base_front.stl \
  $(STLDIR)/base_rear.stl \
  $(STLDIR)/reservoir_lid.stl \
  $(STLDIR)/waste_lid.stl \
  $(STLDIR)/electronics_cover.stl \
  $(STLDIR)/pump_mount.stl \
  $(STLDIR)/ring_FL.stl \
  $(STLDIR)/ring_FR.stl \
  $(STLDIR)/ring_RL.stl \
  $(STLDIR)/ring_RR.stl \
  $(STLDIR)/growing_tray.stl \
  $(STLDIR)/sub_tray.stl \
  $(STLDIR)/led_bracket.stl \
  $(STLDIR)/tray_door.stl \
  $(STLDIR)/top_cap.stl \
  $(STLDIR)/seed_box_lid.stl \
  $(STLDIR)/tube_clip.stl \
  $(STLDIR)/manifold_3way.stl \
  $(STLDIR)/drip_emitter.stl \
  $(STLDIR)/led_panel.stl

.PHONY: all clean preview

all: $(STLDIR) $(STLS)
	@echo "All STLs generated in $(STLDIR)/"
	@echo "Print quantities: see docs/03-build/printing-instructions.md"

$(STLDIR):
	mkdir -p $(STLDIR)

# ---- Base unit parts ----------------------------------------
$(STLDIR)/base_front.stl: $(SRC)/base_unit.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="front"' -o $@ $<

$(STLDIR)/base_rear.stl: $(SRC)/base_unit.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="rear"' -o $@ $<

$(STLDIR)/reservoir_lid.stl: $(SRC)/base_unit.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="lid_res"' -o $@ $<

$(STLDIR)/waste_lid.stl: $(SRC)/base_unit.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="lid_waste"' -o $@ $<

$(STLDIR)/electronics_cover.stl: $(SRC)/base_unit.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="elec_cov"' -o $@ $<

$(STLDIR)/pump_mount.stl: $(SRC)/base_unit.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="pump_mnt"' -o $@ $<

# ---- Tray ring quarters (×3 sets — print 3 of each) --------
$(STLDIR)/ring_FL.stl: $(SRC)/tray_ring.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="FL"' -o $@ $<

$(STLDIR)/ring_FR.stl: $(SRC)/tray_ring.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="FR"' -o $@ $<

$(STLDIR)/ring_RL.stl: $(SRC)/tray_ring.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="RL"' -o $@ $<

$(STLDIR)/ring_RR.stl: $(SRC)/tray_ring.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="RR"' -o $@ $<

# ---- Growing tray and sub-tray (×3 each) --------------------
$(STLDIR)/growing_tray.stl: $(SRC)/growing_tray.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -o $@ $<

$(STLDIR)/sub_tray.stl: $(SRC)/sub_tray.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -o $@ $<

# ---- LED bracket and door (×3 each) -------------------------
$(STLDIR)/led_bracket.stl: $(SRC)/led_bracket.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -o $@ $<

$(STLDIR)/tray_door.stl: $(SRC)/tray_door.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -o $@ $<

# ---- Top cap ------------------------------------------------
$(STLDIR)/top_cap.stl: $(SRC)/top_cap.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="body"' -o $@ $<

$(STLDIR)/seed_box_lid.stl: $(SRC)/top_cap.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="seed_lid"' -o $@ $<

# ---- Miscellaneous small parts ------------------------------
$(STLDIR)/tube_clip.stl: $(SRC)/misc_parts.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="tube_clip"' -o $@ $<

$(STLDIR)/manifold_3way.stl: $(SRC)/misc_parts.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="manifold"' -o $@ $<

$(STLDIR)/drip_emitter.stl: $(SRC)/misc_parts.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="drip_emit"' -o $@ $<

$(STLDIR)/led_panel.stl: $(SRC)/misc_parts.scad $(SRC)/params.scad
	$(OPENSCAD) $(SCAD_FLAGS) -D 'PART="led_panel"' -o $@ $<

# ---- Preview (render all as PNG for visual check) -----------
preview:
	@echo "Rendering preview images..."
	for stl in $(STLS); do \
	  png=$${stl%.stl}.png; \
	  $(OPENSCAD) --render --imgsize 800,600 -o $$png $${stl%.stl}.scad 2>/dev/null || true; \
	done

clean:
	rm -f $(STLDIR)/*.stl $(STLDIR)/*.png
	@echo "Cleaned $(STLDIR)/"

# ---- Print quantity reference --------------------------------
# See docs/03-build/printing-instructions.md for full details.
# Quick reference (quantities to print per complete build):
#   base_front.stl      ×1
#   base_rear.stl       ×1
#   reservoir_lid.stl   ×1
#   waste_lid.stl       ×1
#   electronics_cover.stl ×1
#   pump_mount.stl      ×1
#   ring_FL/FR/RL/RR    ×3 each (12 total ring quarters)
#   growing_tray.stl    ×3
#   sub_tray.stl        ×3
#   led_bracket.stl     ×3
#   tray_door.stl       ×3
#   top_cap.stl         ×1
#   seed_box_lid.stl    ×1
#   tube_clip.stl       ×12
#   manifold_3way.stl   ×1
#   drip_emitter.stl    ×3
#   led_panel.stl       ×1
