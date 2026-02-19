"""
Microgreen Box — 3D Model Technical Renders
Generates PNG images of all major parts using matplotlib isometric projection.
Dimensions taken directly from params.scad.
Output: hardware/3d-models/renders/*.png
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyArrowPatch, Rectangle, FancyBboxPatch
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import os

OUT = os.path.join(os.path.dirname(__file__), "renders")
os.makedirs(OUT, exist_ok=True)

# ── Colour palette ──────────────────────────────────────────────────────────
C_PETG      = "#B0C4DE"   # light steel blue  – structural PETG
C_PETG_DARK = "#708090"   # slate grey        – wall faces
C_WATER     = "#ADD8E6"   # light blue        – water/reservoir
C_WASTE     = "#F0E68C"   # khaki             – waste chamber
C_ELEC      = "#90EE90"   # light green       – electronics bay
C_PUMP      = "#FFB347"   # orange            – pump space
C_LED       = "#FFFACD"   # lemon chiffon     – LED/lighting parts
C_COIR      = "#D2B48C"   # tan               – growing medium / tray
C_SOIL      = "#8B6914"   # dark brown        – sub-tray
C_DOOR      = "#E8E8E8"   # near white        – door panel
C_EDGE      = "#333333"   # near black        – edges

# ── Helpers ─────────────────────────────────────────────────────────────────

def box_faces(ox, oy, oz, w, d, h):
    """Return 6 faces of a cuboid as lists of 4 vertices each."""
    x0, x1 = ox, ox+w
    y0, y1 = oy, oy+d
    z0, z1 = oz, oz+h
    return [
        # bottom, top, front, back, left, right
        [[x0,y0,z0],[x1,y0,z0],[x1,y1,z0],[x0,y1,z0]],
        [[x0,y0,z1],[x1,y0,z1],[x1,y1,z1],[x0,y1,z1]],
        [[x0,y0,z0],[x1,y0,z0],[x1,y0,z1],[x0,y0,z1]],
        [[x0,y1,z0],[x1,y1,z0],[x1,y1,z1],[x0,y1,z1]],
        [[x0,y0,z0],[x0,y1,z0],[x0,y1,z1],[x0,y0,z1]],
        [[x1,y0,z0],[x1,y1,z0],[x1,y1,z1],[x1,y0,z1]],
    ]

def add_box(ax, ox, oy, oz, w, d, h,
            facecolor=C_PETG, edgecolor=C_EDGE,
            alpha=0.85, linewidth=0.5):
    faces = box_faces(ox, oy, oz, w, d, h)
    poly = Poly3DCollection(faces,
                            facecolor=facecolor,
                            edgecolor=edgecolor,
                            alpha=alpha,
                            linewidth=linewidth)
    ax.add_collection3d(poly)

def set_axes(ax, xlim, ylim, zlim, elev=22, azim=-55):
    ax.set_xlim(xlim); ax.set_ylim(ylim); ax.set_zlim(zlim)
    ax.set_box_aspect([xlim[1]-xlim[0],
                       ylim[1]-ylim[0],
                       zlim[1]-zlim[0]])
    ax.view_init(elev=elev, azim=azim)
    ax.set_xlabel("X (mm)", fontsize=7, labelpad=2)
    ax.set_ylabel("Y (mm)", fontsize=7, labelpad=2)
    ax.set_zlabel("Z (mm)", fontsize=7, labelpad=2)
    ax.tick_params(labelsize=6)

def dim_label(ax, text, x, y, z, color="#333333", fontsize=8):
    ax.text(x, y, z, text, fontsize=fontsize, color=color,
            ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.2', fc='white', ec='none', alpha=0.7))

def save(fig, name):
    path = os.path.join(OUT, name)
    fig.savefig(path, dpi=150, bbox_inches='tight',
                facecolor='white', edgecolor='none')
    plt.close(fig)
    print(f"  Saved: {path}")

# ════════════════════════════════════════════════════════════════════════════
# 1. FULL ASSEMBLY OVERVIEW
# ════════════════════════════════════════════════════════════════════════════
def render_overview():
    fig = plt.figure(figsize=(10, 14))
    ax = fig.add_subplot(111, projection='3d')
    fig.patch.set_facecolor('white')

    W, D = 300, 300
    base_h  = 200
    ring_h  = 190
    cap_h   = 80
    wall    = 4
    flange  = 8

    z = 0

    # Base unit
    add_box(ax, 0,0,z, W,D,base_h, facecolor=C_PETG, alpha=0.7)
    # Reservoir label
    dim_label(ax,"Reservoir\n2.4 L", W*0.35, D*0.75, z+base_h*0.5)
    # Electronics label
    dim_label(ax,"Electronics\nbay", W*0.17, D*0.25, z+base_h*0.5, color="#22550a")
    z += base_h

    # 3 tray rings
    ring_colors = [C_PETG, C_PETG, C_PETG]
    tray_labels = ["Tray A\n(harvest)", "Tray B\n(day 3–6)", "Tray C\n(day 0–3)"]
    for i, (rc, lbl) in enumerate(zip(ring_colors, tray_labels)):
        add_box(ax, 0,0,z, W,D,ring_h, facecolor=rc, alpha=0.65)
        # Door aperture (cutout on front face - just show a darker rectangle)
        door_x0 = 75; door_w = 150
        door_z0 = flange; door_h_open = ring_h - 2*flange
        add_box(ax, door_x0, -1, z+door_z0,
                door_w, 2, door_h_open,
                facecolor="#cccccc", alpha=0.5, linewidth=0.3)
        # Tray inside (schematic coir slab)
        sub_z = z + flange + 12
        add_box(ax, wall+6, wall+6, sub_z,
                W-2*wall-12, D-2*wall-12, 40,
                facecolor=C_SOIL, alpha=0.6)
        add_box(ax, wall+6, wall+6, sub_z+40,
                W-2*wall-12, D-2*wall-12, 50,
                facecolor=C_COIR, alpha=0.7)
        # LED panel
        led_y = D - wall - 8
        add_box(ax, (W-100)//2, led_y-4, z+ring_h-flange-20,
                100, 4, 4, facecolor=C_LED, alpha=0.95)
        dim_label(ax, lbl, W*0.5, D*0.45, z+ring_h*0.6, fontsize=7)
        z += ring_h

    # Top cap
    add_box(ax, 0,0,z, W,D,cap_h, facecolor=C_PETG, alpha=0.75)
    dim_label(ax,"Top cap\n(seed storage)", W*0.5, D*0.5, z+cap_h*0.5)

    set_axes(ax, [0,300],[0,300],[0, base_h+3*ring_h+cap_h],
             elev=18, azim=-50)
    ax.set_title("Microgreen Box — Full Assembly\n300×300×850 mm  |  3-tray rotating grow column",
                 fontsize=10, fontweight='bold', pad=12)

    # Legend
    legend_items = [
        mpatches.Patch(facecolor=C_PETG,  label="PETG structure"),
        mpatches.Patch(facecolor=C_WATER, label="Reservoir / water"),
        mpatches.Patch(facecolor=C_COIR,  label="Coir growing medium"),
        mpatches.Patch(facecolor=C_LED,   label="LED panel (3W, 5000–6500K)"),
    ]
    ax.legend(handles=legend_items, loc='upper left',
              fontsize=7, framealpha=0.9)

    save(fig, "01_assembly_overview.png")


# ════════════════════════════════════════════════════════════════════════════
# 2. BASE UNIT
# ════════════════════════════════════════════════════════════════════════════
def render_base_unit():
    fig = plt.figure(figsize=(14, 7))
    fig.patch.set_facecolor('white')
    fig.suptitle("Base Unit  —  300×300×200 mm", fontsize=11, fontweight='bold', y=1.0)

    # ── LEFT: isometric 3D view ──────────────────────────────────────────
    ax3 = fig.add_subplot(1, 2, 1, projection='3d')
    W, D, H = 300, 300, 200
    wall = 4; floor_t = 6

    # Outer shell (wireframe impression)
    add_box(ax3, 0,0,0, W,D,H, facecolor=C_PETG, alpha=0.25)

    # Reservoir (rear-left, blue)
    add_box(ax3, wall, 154, floor_t, 204, 142, 84, facecolor=C_WATER, alpha=0.80)
    # Waste chamber (rear-right, khaki)
    add_box(ax3, 212, 154, floor_t, 84, 142, 84, facecolor=C_WASTE, alpha=0.85)
    # Electronics bay (front-left, green)
    add_box(ax3, wall, wall, floor_t, 100, 142, 84, facecolor=C_ELEC, alpha=0.85)
    # Pump/wiring space (front-right, orange)
    add_box(ax3, 108, wall, floor_t, 188, 142, 84, facecolor=C_PUMP, alpha=0.60)

    # Fill port boss on top
    add_box(ax3, 98, 220, H, 16, 16, 14, facecolor=C_PETG_DARK, alpha=0.9)

    dim_label(ax3, "Reservoir\n204×142×84mm\n≈2.43 L", 100, 225, 60,
              color="#005580")
    dim_label(ax3, "Waste\n84×142×84mm\n≈1.00 L", 254, 225, 60,
              color="#7a6a00")
    dim_label(ax3, "Electronics\n100×142mm", 54, 73, 60, color="#1a6b1a")
    dim_label(ax3, "Pump\nspace", 200, 73, 60, color="#8b4500")

    set_axes(ax3, [0,300],[0,300],[0,220], elev=28, azim=-40)
    ax3.set_title("Isometric cutaway (top-open view)", fontsize=8, pad=6)

    # ── RIGHT: top-down floor plan ───────────────────────────────────────
    ax2 = fig.add_subplot(1, 2, 2)
    ax2.set_facecolor('#f8f8f8')
    ax2.set_aspect('equal')

    # Outer border
    ax2.add_patch(Rectangle((0,0),300,300, fc='none', ec='#333', lw=2))

    # Chambers
    ax2.add_patch(Rectangle((4,154), 204, 142, fc=C_WATER, ec='#005580', lw=1.2, label="Reservoir"))
    ax2.add_patch(Rectangle((212,154), 84, 142, fc=C_WASTE, ec='#7a6a00', lw=1.2, label="Waste"))
    ax2.add_patch(Rectangle((4,4), 100, 142, fc=C_ELEC, ec='#1a6b1a', lw=1.2, label="Electronics"))
    ax2.add_patch(Rectangle((108,4), 188, 142, fc=C_PUMP, ec='#8b4500', lw=1.2, alpha=0.6, label="Pump/wiring"))

    # Split line (front/rear)
    ax2.axhline(150, color='#888', lw=1, ls='--')
    ax2.text(10, 153, "split Y=150", fontsize=7, color='#888')

    # Power jack hole (left wall)
    ax2.plot(0, 60, 'ko', ms=5)
    ax2.annotate("Power\njack", (0,60), (-35,60), fontsize=7,
                 arrowprops=dict(arrowstyle='->', lw=0.8), ha='center')

    # Fill port
    ax2.add_patch(plt.Circle((106, 225), 8, fc='white', ec='#444', lw=1.5))
    ax2.text(106, 225, "Fill\nport", ha='center', va='center', fontsize=5.5)

    # Waste port (rear right wall)
    ax2.plot(296, 225, 'bs', ms=6)
    ax2.annotate("Waste\nport", (296,225), (310,225), fontsize=7,
                 arrowprops=dict(arrowstyle='->', lw=0.8))

    # M5 corner inserts
    for cx in [18, 282]:
        for cy in [18, 282]:
            ax2.add_patch(plt.Circle((cx,cy), 4, fc='none', ec='#555', lw=1))
    ax2.text(18, 18, "M5\ninsert", ha='center', va='center', fontsize=4.5)

    # Stack bolt holes
    for bx in [30, 150, 270]:
        for by in [20, 280]:
            ax2.plot(bx, by, 'k+', ms=6, mew=1.2)

    ax2.set_xlim(-40, 320); ax2.set_ylim(-20, 320)
    ax2.set_xlabel("X (mm)", fontsize=8); ax2.set_ylabel("Y (mm)", fontsize=8)
    ax2.set_title("Top-view floor plan (chambers)", fontsize=8, pad=6)
    ax2.legend(fontsize=7, loc='lower right')

    # Dimension annotations
    ax2.annotate('', xy=(300,310), xytext=(0,310),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(150, 313, "300 mm", ha='center', fontsize=7)
    ax2.annotate('', xy=(312,300), xytext=(312,0),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(318, 150, "300 mm", ha='center', fontsize=7, rotation=90)

    fig.tight_layout()
    save(fig, "02_base_unit.png")


# ════════════════════════════════════════════════════════════════════════════
# 3. TRAY RING
# ════════════════════════════════════════════════════════════════════════════
def render_tray_ring():
    fig = plt.figure(figsize=(14, 7))
    fig.patch.set_facecolor('white')
    fig.suptitle("Tray Level Ring  —  300×300×190 mm (×3 required)", fontsize=11,
                 fontweight='bold', y=1.0)

    # ── LEFT: full ring isometric ─────────────────────────────────────────
    ax3 = fig.add_subplot(1, 2, 1, projection='3d')
    W, D, H = 300, 300, 190
    wall = 4; flange = 8; ledge_w = 6; ledge_t = 4

    # Outer shell
    add_box(ax3, 0,0,0, W,D,H, facecolor=C_PETG, alpha=0.3)

    # Walls with hollow interior
    for face_coords, fc in [
        # front wall
        ((0,0,0, W,wall,H), C_PETG),
        # rear wall
        ((0, D-wall,0, W,wall,H), C_PETG),
        # left wall
        ((0,0,0, wall,D,H), C_PETG),
        # right wall
        ((W-wall,0,0, wall,D,H), C_PETG),
        # bottom flange
        ((0,0,0, W,D,flange), C_PETG_DARK),
        # top flange
        ((0,0,H-flange, W,D,flange), C_PETG_DARK),
    ]:
        add_box(ax3, *face_coords, facecolor=fc, alpha=0.55)

    # Sub-tray ledge rails (left and right, Z=12+flange=20)
    sub_z = 12 + flange
    add_box(ax3, wall, wall, sub_z, ledge_w, D-2*wall, ledge_t,
            facecolor="#aaaaff", alpha=0.9)
    add_box(ax3, W-wall-ledge_w, wall, sub_z, ledge_w, D-2*wall, ledge_t,
            facecolor="#aaaaff", alpha=0.9)

    # Growing tray ledge rails (Z=56+flange=64)
    grow_z = 56 + flange
    add_box(ax3, wall, wall, grow_z, ledge_w, D-2*wall, ledge_t,
            facecolor="#ffaaaa", alpha=0.9)
    add_box(ax3, W-wall-ledge_w, wall, grow_z, ledge_w, D-2*wall, ledge_t,
            facecolor="#ffaaaa", alpha=0.9)

    # Door aperture (front face, schematic)
    door_x0 = 75; door_w = 150; door_z0 = flange; door_h = H - 2*flange
    add_box(ax3, door_x0, -2, door_z0, door_w, 2, door_h,
            facecolor="#888888", alpha=0.4, linewidth=0.3)

    # LED bracket mounting rail (rear wall)
    add_box(ax3, 44, D-wall-8, flange, 112, 8, H-2*flange,
            facecolor=C_PETG_DARK, alpha=0.5)

    dim_label(ax3, "Sub-tray\nledge Z=20", W*0.5, D*0.6, sub_z+2, color="#3333aa")
    dim_label(ax3, "Grow tray\nledge Z=64", W*0.5, D*0.4, grow_z+2, color="#aa3333")
    dim_label(ax3, "LED bracket\nrail (rear)", W*0.5, D*0.85, H*0.5)
    dim_label(ax3, "Door\naperture\n150×174mm", door_x0+door_w//2, -15, H//2, color="#555")

    set_axes(ax3, [0,300],[0,300],[0,200], elev=22, azim=-45)
    ax3.set_title("Full ring — isometric (interior visible)", fontsize=8, pad=6)

    # ── RIGHT: cross-section diagram ─────────────────────────────────────
    ax2 = fig.add_subplot(1, 2, 2)
    ax2.set_facecolor('#f8f8f8')
    ax2.set_aspect('equal')

    # XZ cross-section at Y=D/2
    # Outer wall
    ax2.add_patch(Rectangle((0,0),300,190, fc='none', ec='#333', lw=2, ls='--'))

    # Left wall
    ax2.add_patch(Rectangle((0,0),wall,190, fc=C_PETG, ec=C_EDGE, lw=1))
    # Right wall
    ax2.add_patch(Rectangle((296,0),wall,190, fc=C_PETG, ec=C_EDGE, lw=1))

    # Flanges
    ax2.add_patch(Rectangle((0,0),300,flange, fc=C_PETG_DARK, ec=C_EDGE, lw=1))
    ax2.add_patch(Rectangle((0,190-flange),300,flange, fc=C_PETG_DARK, ec=C_EDGE, lw=1))

    # Sub-tray ledge
    ax2.add_patch(Rectangle((wall, sub_z), ledge_w, ledge_t, fc='#aaaaff', ec='#3333aa', lw=1.2))
    ax2.add_patch(Rectangle((300-wall-ledge_w, sub_z), ledge_w, ledge_t, fc='#aaaaff', ec='#3333aa', lw=1.2))
    ax2.annotate('Sub-tray ledge Z=20', (wall+ledge_w, sub_z+ledge_t/2),
                 (80, sub_z+ledge_t/2), fontsize=7,
                 arrowprops=dict(arrowstyle='->', lw=0.8))

    # Growing tray ledge
    ax2.add_patch(Rectangle((wall, grow_z), ledge_w, ledge_t, fc='#ffaaaa', ec='#aa3333', lw=1.2))
    ax2.add_patch(Rectangle((300-wall-ledge_w, grow_z), ledge_w, ledge_t, fc='#ffaaaa', ec='#aa3333', lw=1.2))
    ax2.annotate('Grow tray ledge Z=64', (wall+ledge_w, grow_z+ledge_t/2),
                 (80, grow_z+ledge_t/2+8), fontsize=7,
                 arrowprops=dict(arrowstyle='->', lw=0.8))

    # Sub-tray (schematic)
    ax2.add_patch(Rectangle((wall+ledge_w, sub_z+ledge_t), 300-2*(wall+ledge_w), 40,
                  fc=C_SOIL, ec=C_EDGE, lw=1, alpha=0.5))
    ax2.text(150, sub_z+ledge_t+20, "Sub-tray 256×40mm", ha='center', va='center',
             fontsize=7, color='white', fontweight='bold')

    # Growing tray (schematic)
    ax2.add_patch(Rectangle((wall+ledge_w, grow_z+ledge_t), 300-2*(wall+ledge_w), 50,
                  fc=C_COIR, ec=C_EDGE, lw=1, alpha=0.5))
    ax2.text(150, grow_z+ledge_t+25, "Growing tray 250×50mm + coir", ha='center', va='center',
             fontsize=7)

    # Door aperture on front wall (shown as outline)
    ax2.add_patch(Rectangle((door_x0, door_z0), door_w, door_h,
                  fc='none', ec='#888', lw=1.5, ls='-.'))
    ax2.text(door_x0+door_w/2, door_z0+door_h/2, "Door\naperture\n150×174mm",
             ha='center', va='center', fontsize=7, color='#555')

    # Dimension arrows
    ax2.annotate('', xy=(300,198), xytext=(0,198),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(150, 201, "300 mm", ha='center', fontsize=7)
    ax2.annotate('', xy=(308,190), xytext=(308,0),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(315, 95, "190 mm", ha='center', fontsize=7, rotation=90)

    # Quarter split lines
    ax2.axvline(150, color='#aaa', lw=1, ls=':')
    ax2.text(152, 5, "Quarter\nsplit X=150", fontsize=6, color='#888')

    ax2.set_xlim(-20, 330); ax2.set_ylim(-10, 215)
    ax2.set_xlabel("X (mm)", fontsize=8); ax2.set_ylabel("Z (mm)", fontsize=8)
    ax2.set_title("XZ cross-section through ring centre", fontsize=8, pad=6)

    legend_items = [
        mpatches.Patch(fc='#aaaaff', ec='#3333aa', label='Sub-tray ledge rail'),
        mpatches.Patch(fc='#ffaaaa', ec='#aa3333', label='Grow tray ledge rail'),
        mpatches.Patch(fc=C_SOIL, label='Sub-tray (40mm)'),
        mpatches.Patch(fc=C_COIR, label='Growing tray (50mm)'),
        mpatches.Patch(fc=C_PETG_DARK, label='Stack flange (8mm)'),
    ]
    ax2.legend(handles=legend_items, fontsize=6.5, loc='upper right')

    fig.tight_layout()
    save(fig, "03_tray_ring.png")


# ════════════════════════════════════════════════════════════════════════════
# 4. GROWING TRAY
# ════════════════════════════════════════════════════════════════════════════
def render_growing_tray():
    fig = plt.figure(figsize=(14, 6))
    fig.patch.set_facecolor('white')
    fig.suptitle("Growing Tray  —  250×250×50 mm  (×3 required)", fontsize=11,
                 fontweight='bold', y=1.01)

    # ── LEFT: isometric view ─────────────────────────────────────────────
    ax3 = fig.add_subplot(1, 2, 1, projection='3d')
    W, D, H = 250, 250, 50
    wall = 3; floor_t = 4; lip_h = 6; lip_w = 4

    # Body
    add_box(ax3, 0,0,0, W,D,H, facecolor=C_COIR, alpha=0.45)

    # Walls schematic
    for ox,oy,ow,od in [
        (0,0,W,wall),
        (0,D-wall,W,wall),
        (0,wall,wall,D-2*wall),
        (W-wall,wall,wall,D-2*wall),
    ]:
        add_box(ax3, ox,oy,0, ow,od,H, facecolor=C_PETG, alpha=0.7)

    # Floor
    add_box(ax3, 0,0,0, W,D,floor_t, facecolor=C_PETG_DARK, alpha=0.8)

    # Drain holes (4× Ø8mm at ±50 from centre)
    cx, cy = W/2, D/2
    for dx in [-50, 50]:
        for dy in [-50, 50]:
            ax3.scatter([cx+dx], [cy+dy], [0.5], c='#333', s=30, marker='o', zorder=5)

    # Retention lip (below floor)
    add_box(ax3, -lip_w, -lip_w, -lip_h,
            W+2*lip_w, D+2*lip_w, lip_h,
            facecolor=C_PETG_DARK, alpha=0.6)

    # Coir fill (schematic)
    add_box(ax3, wall,wall,floor_t, W-2*wall,D-2*wall,30, facecolor=C_COIR, alpha=0.5)

    dim_label(ax3, "4× Ø8mm\ndrain holes", cx, cy, -2, color="#333")
    dim_label(ax3, "Coir\ngrowing\nmedium\n~2cm", cx, D*0.7, floor_t+15, color="#5a3a00")
    dim_label(ax3, "Retention\nlip (6mm)", -lip_w*3, D//2, -lip_h//2, color="#333")

    set_axes(ax3, [-12,262],[-12,262],[-12,55], elev=28, azim=-45)
    ax3.set_title("Isometric view", fontsize=8, pad=6)

    # ── RIGHT: top view + cross-section ─────────────────────────────────
    ax2 = fig.add_subplot(1, 2, 2)
    ax2.set_facecolor('#f8f8f8')
    ax2.set_aspect('equal')

    # Top view (footprint)
    ax2.add_patch(Rectangle((-lip_w,-lip_w), W+2*lip_w, D+2*lip_w,
                  fc=C_PETG_DARK, ec=C_EDGE, lw=1.5, label='Retention lip'))
    ax2.add_patch(Rectangle((0,0), W, D,
                  fc=C_PETG, ec=C_EDGE, lw=1.5))
    ax2.add_patch(Rectangle((wall,wall), W-2*wall, D-2*wall,
                  fc=C_COIR, ec=C_EDGE, lw=1, alpha=0.6, label='Growing area 244×244mm'))

    # Drain holes
    cx2, cy2 = W/2, D/2
    for dx in [-50, 50]:
        for dy in [-50, 50]:
            ax2.add_patch(plt.Circle((cx2+dx, cy2+dy), 4, fc='#555', ec='#333', lw=1))
    ax2.text(cx2, cy2, "4× Ø8mm\ndrain holes\n(2×2 grid)", ha='center', va='center',
             fontsize=8, color='#333')

    # Dimension arrows
    ax2.annotate('', xy=(W, -15), xytext=(0, -15),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(W/2, -20, "250 mm", ha='center', fontsize=8)
    ax2.annotate('', xy=(W+18, D), xytext=(W+18, 0),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(W+24, D/2, "250 mm", ha='center', fontsize=8, rotation=90)

    # Growing area dimensions
    ax2.annotate('', xy=(W-wall, D+12), xytext=(wall, D+12),
                 arrowprops=dict(arrowstyle='<->', lw=0.8, color='#666'))
    ax2.text(W/2, D+16, "244 mm clear interior", ha='center', fontsize=7, color='#666')

    ax2.set_xlim(-15, W+40); ax2.set_ylim(-30, D+30)
    ax2.set_xlabel("X (mm)", fontsize=8); ax2.set_ylabel("Y (mm)", fontsize=8)
    ax2.set_title("Top view", fontsize=8, pad=6)
    ax2.legend(fontsize=7, loc='lower right')

    # Key specs text
    specs = (
        "Material: PETG\n"
        "Footprint: 250×250 mm\n"
        "Height: 50 mm\n"
        "Wall: 3 mm | Floor: 4 mm\n"
        "Retention lip: 6mm deep × 4mm wide\n"
        "Drain holes: 4× Ø8mm\n"
        "Growing area: 625 cm²\n"
        "Seed load: 12–15 g per cycle\n"
        "Expected yield: 90–130 g / 10 days"
    )
    ax2.text(0.02, 0.02, specs, transform=ax2.transAxes, fontsize=7,
             va='bottom', bbox=dict(boxstyle='round', fc='white', ec='#ccc', alpha=0.9))

    fig.tight_layout()
    save(fig, "04_growing_tray.png")


# ════════════════════════════════════════════════════════════════════════════
# 5. SUB-TRAY
# ════════════════════════════════════════════════════════════════════════════
def render_sub_tray():
    fig = plt.figure(figsize=(12, 6))
    fig.patch.set_facecolor('white')
    fig.suptitle("Sub-Tray (Sealed Water Retention)  —  256×256×40 mm  (×3 required)",
                 fontsize=11, fontweight='bold', y=1.01)

    ax3 = fig.add_subplot(1, 2, 1, projection='3d')
    W, D, H = 256, 256, 40
    wall = 3; floor_t = 4
    overflow_z = 25; overflow_d = 8; drain_z = 10

    # Outer shell
    add_box(ax3, 0,0,0, W,D,H, facecolor=C_SOIL, alpha=0.4)

    # Walls
    for ox,oy,ow,od in [
        (0,0,W,wall),
        (0,D-wall,W,wall),
        (0,wall,wall,D-2*wall),
        (W-wall,wall,wall,D-2*wall),
    ]:
        add_box(ax3, ox,oy,0, ow,od,H, facecolor=C_PETG, alpha=0.65)

    # Floor
    add_box(ax3, 0,0,0, W,D,floor_t, facecolor=C_PETG_DARK, alpha=0.8)

    # Water inside (up to overflow level)
    add_box(ax3, wall,wall,floor_t, W-2*wall,D-2*wall,
            overflow_z-floor_t, facecolor=C_WATER, alpha=0.5)

    # Overflow port (right wall)
    ax3.scatter([W], [D/2], [overflow_z], c='#0055bb', s=60, marker='s', zorder=5)
    dim_label(ax3, "Overflow\nport Ø8mm\nZ=25mm", W+5, D/2, overflow_z+5, color="#0055bb")

    # Drain fitting (rear wall)
    ax3.scatter([D/2], [D], [drain_z], c='#8b0000', s=60, marker='s', zorder=5)
    dim_label(ax3, "Drain\nfitting\nZ=10mm", D/2, D+10, drain_z+5, color="#8b0000")

    set_axes(ax3, [0,280],[0,280],[0,50], elev=28, azim=-35)
    ax3.set_title("Isometric view", fontsize=8)

    ax2 = fig.add_subplot(1, 2, 2)
    ax2.set_facecolor('#f8f8f8')

    # XZ cross-section (Y=D/2)
    ax2.add_patch(Rectangle((0,0), W, H, fc=C_PETG, ec=C_EDGE, lw=1.5))
    # Interior water zone
    ax2.add_patch(Rectangle((wall, floor_t), W-2*wall, overflow_z-floor_t,
                  fc=C_WATER, ec='#0055bb', lw=1, alpha=0.7, label='Water zone'))
    ax2.add_patch(Rectangle((wall, floor_t+overflow_z-floor_t), W-2*wall,
                  H-overflow_z, fc='#f0f0f0', ec='#ccc', lw=0.5, alpha=0.5, label='Airspace'))

    # Floor
    ax2.add_patch(Rectangle((0,0), W, floor_t, fc=C_PETG_DARK, ec=C_EDGE, lw=1))

    # Overflow port (right wall, at Z=25)
    ax2.plot([W-wall, W+5], [overflow_z, overflow_z], 'b-', lw=2)
    ax2.plot(W+5, overflow_z, 'b>', ms=6)
    ax2.text(W+8, overflow_z, "Overflow port\nØ8mm Z=25", fontsize=7, color='blue',
             va='center')

    # Drain fitting (right wall, Z=10)
    ax2.plot([W-wall, W+5], [drain_z, drain_z], 'r-', lw=2)
    ax2.plot(W+5, drain_z, 'r>', ms=6)
    ax2.text(W+8, drain_z, "Drain fitting\nZ=10mm → waste", fontsize=7, color='red',
             va='center')

    # Dimension arrows
    ax2.annotate('', xy=(W, -8), xytext=(0, -8),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(W/2, -12, "256 mm", ha='center', fontsize=8)
    ax2.annotate('', xy=(-12, H), xytext=(-12, 0),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(-22, H/2, "40 mm", ha='center', fontsize=8, rotation=90)

    ax2.annotate('', xy=(wall, overflow_z), xytext=(wall, floor_t),
                 arrowprops=dict(arrowstyle='<->', lw=0.8, color='blue'))
    ax2.text(wall/2+5, (overflow_z+floor_t)/2, "21mm\nwater\ncolumn",
             ha='center', va='center', fontsize=6.5, color='blue')

    ax2.set_xlim(-35, W+90); ax2.set_ylim(-20, H+15)
    ax2.set_xlabel("X (mm)", fontsize=8); ax2.set_ylabel("Z (mm)", fontsize=8)
    ax2.set_title("XZ cross-section showing overflow/drain", fontsize=8, pad=6)
    ax2.legend(fontsize=7)

    specs = (
        "⚠ WATERPROOF COATING REQUIRED\n"
        "Apply XTC-3D epoxy to all interior\n"
        "surfaces before first water contact.\n\n"
        "Overflow port routes to waste chamber.\n"
        "Drain fitting: Ø8.5mm push-fit on\n"
        "rear wall, connects to waste tubing."
    )
    ax2.text(0.02, 0.98, specs, transform=ax2.transAxes, fontsize=7,
             va='top', bbox=dict(boxstyle='round', fc='#ffffcc', ec='orange',
                                 alpha=0.95, lw=1.5))

    fig.tight_layout()
    save(fig, "05_sub_tray.png")


# ════════════════════════════════════════════════════════════════════════════
# 6. LED BRACKET
# ════════════════════════════════════════════════════════════════════════════
def render_led_bracket():
    fig = plt.figure(figsize=(12, 6))
    fig.patch.set_facecolor('white')
    fig.suptitle("LED Bracket  —  Adjustable Mount for 100×100mm LED Panel  (×3 required)",
                 fontsize=11, fontweight='bold', y=1.01)

    ax3 = fig.add_subplot(1, 2, 1, projection='3d')

    flange_w = 12; slot_l = 30; slot_w = 4.5; arm_t = 5
    panel_w = 100; panel_d = 100; panel_t = 4
    bracket_h = 120  # total bracket arm height

    # Wall-mount flange
    add_box(ax3, 0, 0, 0, flange_w, 4, bracket_h,
            facecolor=C_PETG, alpha=0.85)

    # Horizontal arm
    add_box(ax3, flange_w, 0, bracket_h/2-arm_t/2,
            panel_d+8, arm_t*2, arm_t,
            facecolor=C_PETG, alpha=0.85)

    # Adjustment slot (drawn as void in arm — just label it)
    add_box(ax3, flange_w+5, -1, bracket_h/2-slot_l/2,
            slot_w, arm_t*2+2, slot_l,
            facecolor='white', alpha=0.9)

    # LED panel
    add_box(ax3, flange_w+8, 0, bracket_h/2+arm_t/2,
            panel_w, panel_d, panel_t,
            facecolor=C_LED, alpha=0.85)

    dim_label(ax3, "Wall-mount\nflange\n12mm", -5, 2, bracket_h//2, color="#333")
    dim_label(ax3, "LED Panel\n100×100mm\n3W full-spec\n5000–6500K",
              flange_w+panel_w//2, panel_d//2, bracket_h//2+20, color="#776600")
    dim_label(ax3, "Adj. slot\n30mm travel\n±15mm", flange_w+slot_w//2, -8,
              bracket_h//2, color="#555")

    ax3.set_xlim([-20, 140]); ax3.set_ylim([-20, 120]); ax3.set_zlim([0, 150])
    ax3.set_box_aspect([160, 140, 150])
    ax3.view_init(elev=25, azim=-50)
    ax3.set_xlabel("X (mm)", fontsize=7, labelpad=2)
    ax3.set_ylabel("Y (mm)", fontsize=7, labelpad=2)
    ax3.set_zlabel("Z (mm)", fontsize=7, labelpad=2)
    ax3.tick_params(labelsize=6)
    ax3.set_title("Isometric view", fontsize=8)

    # ── RIGHT: side elevation ─────────────────────────────────────────────
    ax2 = fig.add_subplot(1, 2, 2)
    ax2.set_facecolor('#f8f8f8')
    ax2.set_aspect('equal')

    # Rear wall (schematic)
    ax2.add_patch(Rectangle((0,0), 8, 190, fc='#ddd', ec='#888', lw=1, ls='--'))
    ax2.text(4, 95, "Ring\nrear\nwall", ha='center', va='center', fontsize=6.5)

    # Bracket flange
    ax2.add_patch(Rectangle((8,30), flange_w, 120, fc=C_PETG, ec=C_EDGE, lw=1.2))
    ax2.text(14, 90, "Flange", ha='center', va='center', fontsize=6.5, rotation=90)

    # Arm + panel at nominal position (100mm above tray)
    arm_y = 30 + 60  # mid-bracket
    ax2.add_patch(Rectangle((8+flange_w, arm_y-arm_t/2), 50, arm_t,
                  fc=C_PETG, ec=C_EDGE, lw=1))

    # Slot
    ax2.add_patch(Rectangle((8+flange_w+3, arm_y-slot_l//2), slot_w, slot_l,
                  fc='white', ec='#555', lw=1, ls='--'))
    ax2.annotate('Adj. slot\n30mm', (8+flange_w+3+slot_w/2, arm_y),
                 (8+flange_w+50, arm_y+20), fontsize=7,
                 arrowprops=dict(arrowstyle='->', lw=0.8))

    # LED panel (horizontal, above tray)
    tray_top = 30  # schematic tray surface
    led_bottom = tray_top + 100  # 100mm above tray
    ax2.add_patch(Rectangle((8+flange_w, led_bottom), panel_w, panel_t,
                  fc=C_LED, ec='#776600', lw=1.5))
    ax2.text(8+flange_w+panel_w/2, led_bottom+panel_t/2,
             "LED 100×100mm 3W", ha='center', va='center', fontsize=7)

    # Tray surface
    ax2.axhline(tray_top, color='#888', lw=1.5, ls='--', xmin=0.05, xmax=0.95)
    ax2.text(8+flange_w+panel_w+5, tray_top, "Tray surface", fontsize=7, va='center')

    # Height annotation
    ax2.annotate('', xy=(8+flange_w+panel_w+2, led_bottom),
                 xytext=(8+flange_w+panel_w+2, tray_top),
                 arrowprops=dict(arrowstyle='<->', lw=1, color='red'))
    ax2.text(8+flange_w+panel_w+8, (led_bottom+tray_top)/2,
             "100 mm\nnominal\n(±15 adj.)", fontsize=7, va='center', color='red')

    # PPFD note
    ax2.text(8+flange_w+panel_w/2, tray_top-8,
             "~100 µmol/m²/s PPFD @ 100mm", ha='center', fontsize=7, color='#0055aa')

    ax2.set_xlim(-5, 200); ax2.set_ylim(0, 200)
    ax2.set_xlabel("X (mm)", fontsize=8); ax2.set_ylabel("Z (mm)", fontsize=8)
    ax2.set_title("Side elevation showing adjustment range", fontsize=8, pad=6)

    specs = (
        "LED spec: 3W, 5000–6500K full spectrum\n"
        "Panel size: 100×100mm aluminium PCB\n"
        "Nominal height: 100mm above tray\n"
        "Adjustment range: ±15mm (30mm total)\n"
        "Target PPFD: ~100 µmol/m²/s\n"
        "Photoperiod: 14h on / 10h off\n"
        "Software blackout days 0–2 per tray"
    )
    ax2.text(0.02, 0.02, specs, transform=ax2.transAxes, fontsize=7,
             va='bottom', bbox=dict(boxstyle='round', fc='white', ec='#ccc', alpha=0.9))

    fig.tight_layout()
    save(fig, "06_led_bracket.png")


# ════════════════════════════════════════════════════════════════════════════
# 7. TRAY DOOR
# ════════════════════════════════════════════════════════════════════════════
def render_tray_door():
    fig = plt.figure(figsize=(11, 6))
    fig.patch.set_facecolor('white')
    fig.suptitle("Front Door  —  150×174 mm PETG Hinged Panel  (×3 required)",
                 fontsize=11, fontweight='bold', y=1.01)

    ring_h = 190; flange = 8
    door_w = 150; door_h = ring_h - 2*flange  # = 174mm
    door_t = 6

    ax3 = fig.add_subplot(1, 2, 1, projection='3d')

    # Ring front wall (schematic context)
    ring_front_w = 300
    add_box(ax3, 0, 0, 0, ring_front_w, door_t, ring_h,
            facecolor=C_PETG, alpha=0.25)

    # Door aperture in ring
    ax3.bar3d(75, -1, flange, door_w, door_t+2, door_h,
              color='#f0f0f0', alpha=0.5, shade=True)

    # Door panel
    add_box(ax3, 75, -door_t, flange, door_w, door_t, door_h,
            facecolor=C_DOOR, alpha=0.9)

    # Hinge bosses (left edge)
    for hz in [flange + door_h*0.25,
               flange + door_h*0.5,
               flange + door_h*0.75]:
        add_box(ax3, 70, -door_t-4, hz-4, 8, 8, 8,
                facecolor=C_PETG_DARK, alpha=0.9)

    # Magnet catch (right edge, mid-height)
    add_box(ax3, 75+door_w-3, -door_t-4, flange+door_h/2-6,
            6, 8, 12, facecolor="#666688", alpha=0.9)

    # Foam groove (perimeter of door)
    dim_label(ax3, "3mm hinge\nbosses (×3)", 68, -12, flange+door_h*0.5, color="#333")
    dim_label(ax3, "Magnet\ncatch\nØ8mm", 75+door_w+5, -8, flange+door_h/2, color="#333")
    dim_label(ax3, "Foam\nweather-strip\ngroove", 75+door_w/2, -15, flange+5, color="#555")

    set_axes(ax3, [60,240],[-20,30],[0,200], elev=20, azim=-50)
    ax3.set_title("Door in context of ring front wall", fontsize=8)

    # ── RIGHT: front face diagram ─────────────────────────────────────────
    ax2 = fig.add_subplot(1, 2, 2)
    ax2.set_facecolor('#f8f8f8')
    ax2.set_aspect('equal')

    # Door outline
    ax2.add_patch(Rectangle((0,0), door_w, door_h,
                  fc=C_DOOR, ec=C_EDGE, lw=2))

    # Foam groove channel (2mm inside perimeter)
    foam_inset = 3
    ax2.add_patch(Rectangle((foam_inset, foam_inset),
                  door_w-2*foam_inset, door_h-2*foam_inset,
                  fc='none', ec='#888', lw=1.5, ls='--'))
    ax2.text(door_w/2, 2, "Foam weather-strip groove", ha='center', fontsize=6.5,
             color='#666')

    # Hinge knuckles (left edge)
    hinge_spacing = door_h / (3+1)
    for i in range(1, 4):
        hz = i * hinge_spacing
        ax2.add_patch(plt.Circle((-5, hz), 4, fc=C_PETG_DARK, ec=C_EDGE, lw=1))
        ax2.plot([-1, 0], [hz, hz], 'k-', lw=0.5)
    ax2.text(-5, door_h+5, "Hinge pin (×3)", ha='center', fontsize=7)

    # Magnet pocket (right edge)
    ax2.add_patch(plt.Circle((door_w+5, door_h/2), 4, fc='#666688', ec='#333', lw=1))
    ax2.text(door_w+5, door_h/2-10, "Magnet\npocket\nØ8mm", ha='center', fontsize=7)

    # Dimension arrows
    ax2.annotate('', xy=(door_w, -12), xytext=(0, -12),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(door_w/2, -17, f"{door_w} mm", ha='center', fontsize=8)
    ax2.annotate('', xy=(-20, door_h), xytext=(-20, 0),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(-28, door_h/2, f"{door_h} mm", ha='center', fontsize=8, rotation=90)

    # Print orientation note
    ax2.text(door_w/2, door_h/2, "Print flat\non bed\n(door face up)",
             ha='center', va='center', fontsize=9, color='#444',
             fontstyle='italic')

    ax2.set_xlim(-40, door_w+40); ax2.set_ylim(-30, door_h+20)
    ax2.set_xlabel("X (mm)", fontsize=8); ax2.set_ylabel("Z (mm)", fontsize=8)
    ax2.set_title("Front face view", fontsize=8, pad=6)

    specs = (
        "Panel: 150×174×6mm PETG\n"
        "Hinge: 3 knuckles, Ø3.5mm pin\n"
        "Catch: Ø8mm×3.5mm magnet pocket\n"
        "Seal: 4×2mm foam weather-strip\n"
        "Light-seal: blackout between levels\n"
        "Print: flat on bed, no supports\n"
        "Infill: 20%"
    )
    ax2.text(0.02, 0.02, specs, transform=ax2.transAxes, fontsize=7,
             va='bottom', bbox=dict(boxstyle='round', fc='white', ec='#ccc', alpha=0.9))

    fig.tight_layout()
    save(fig, "07_tray_door.png")


# ════════════════════════════════════════════════════════════════════════════
# 8. TOP CAP
# ════════════════════════════════════════════════════════════════════════════
def render_top_cap():
    fig = plt.figure(figsize=(14, 6))
    fig.patch.set_facecolor('white')
    fig.suptitle("Top Cap  —  300×300×80 mm  (Seed Storage + Handle + Ventilation Fan)",
                 fontsize=11, fontweight='bold', y=1.01)

    W, D, H = 300, 300, 80
    wall = 4
    # Fan / switch params (from params.scad — DECISION-024)
    fan_x, fan_y   = 150, 220   # fan centre (top surface)
    fan_hole_r     = 37 / 2     # exhaust hole radius
    fan_recess_r   = 42 / 2     # body recess radius
    fan_bolt_ctc   = 32         # bolt circle CTC
    switch_x       = 255        # switch X on front face
    switch_z       = 50         # switch Z on front face

    ax3 = fig.add_subplot(1, 2, 1, projection='3d')

    # Main body
    add_box(ax3, 0,0,0, W,D,H, facecolor=C_PETG, alpha=0.4)
    # Top face
    add_box(ax3, 0,0,H-wall, W,D,wall, facecolor=C_PETG_DARK, alpha=0.7)
    # Walls
    add_box(ax3, 0,0,0, wall,D,H, facecolor=C_PETG, alpha=0.65)
    add_box(ax3, W-wall,0,0, wall,D,H, facecolor=C_PETG, alpha=0.65)
    add_box(ax3, 0,0,0, W,wall,H, facecolor=C_PETG, alpha=0.65)
    add_box(ax3, 0,D-wall,0, W,wall,H, facecolor=C_PETG, alpha=0.65)

    # Seed storage box (rear-left)
    add_box(ax3, wall+10, D//2+10, wall, 60, 60, 50, facecolor="#ffe4b5", alpha=0.85)
    dim_label(ax3, "Seed\nstorage\n60×60×50", wall+10+30, D//2+10+30, wall+25, color="#5a3a00")

    # Bag tray (rear-right)
    add_box(ax3, W//2+10, D//2+10, wall, 80, 80, 30, facecolor="#e0e0ff", alpha=0.75)
    dim_label(ax3, "Bag/marker\ntray\n80×80×30", W//2+10+40, D//2+10+40, wall+15, color="#333")

    # OLED window (front face)
    add_box(ax3, W//2-14, -2, H-wall-wall-14, 28, 2, 14,
            facecolor="#333", alpha=0.9)
    dim_label(ax3, "OLED\nwindow", W//2, -10, H-18, color="#333")

    # Status LEDs (front face)
    for i in range(4):
        ax3.scatter([W//2-15+i*10], [-2], [H-wall-8],
                    c=['#00cc00','#ffcc00','#ff3333','#ff3333'][i],
                    s=30, marker='o', zorder=5)

    # Toggle switch hole (front face, right side — DECISION-024)
    ax3.scatter([switch_x], [-2], [switch_z],
                c='#333', s=50, marker='o', zorder=6)
    dim_label(ax3, "Fan switch\nØ6.5mm", switch_x+18, -12, switch_z,
              color="#1a5a1a", fontsize=7)

    # Handle arch (top surface)
    add_box(ax3, W//2-40, D//2-4, H, 80, 8, 25, facecolor=C_PETG_DARK, alpha=0.8)

    # Fan exhaust hole on top surface (recess ring + dark hole — DECISION-024)
    # Recess ring (grey annulus schematic)
    ax3.scatter([fan_x], [fan_y], [H+0.5],
                c='#888', s=500, marker='o', zorder=6, alpha=0.7)
    # Through-hole (dark centre)
    ax3.scatter([fan_x], [fan_y], [H+0.5],
                c='#111', s=220, marker='o', zorder=7)
    # 4× M3 mounting holes
    for dx in [-fan_bolt_ctc/2, fan_bolt_ctc/2]:
        for dy in [-fan_bolt_ctc/2, fan_bolt_ctc/2]:
            ax3.scatter([fan_x+dx], [fan_y+dy], [H+0.5],
                        c='white', s=18, marker='o', zorder=8)
    dim_label(ax3, "Fan exhaust\nØ37mm hole\nØ42mm recess\n4× M3 mounts",
              fan_x+40, fan_y+30, H+12, color="#1a5a1a", fontsize=7)

    # Bottom flange (stack join)
    add_box(ax3, 0,0,0, W,D,8, facecolor=C_PETG_DARK, alpha=0.8)
    dim_label(ax3, "Stack\nflange\n8mm", W*0.1, D*0.1, 4, color="#333")

    set_axes(ax3, [0,300],[0,300],[0,115], elev=30, azim=-40)
    ax3.set_title("Isometric view", fontsize=8)

    # ── RIGHT: composite view (interior + top-face fan overlay) ──────────
    ax2 = fig.add_subplot(1, 2, 2)
    ax2.set_facecolor('#f8f8f8')
    ax2.set_aspect('equal')

    # Outer border
    ax2.add_patch(Rectangle((0,0), W, D, fc='none', ec='#333', lw=2))

    # Seed box (interior, shown as if top face removed)
    ax2.add_patch(Rectangle((wall+10, D//2+10), 60, 60,
                  fc="#ffe4b5", ec="#5a3a00", lw=1.5, label="Seed box 60×60mm"))
    ax2.text(wall+10+30, D//2+10+30, "Seed\n60×60", ha='center', va='center', fontsize=7)

    # Bag tray (interior)
    ax2.add_patch(Rectangle((W//2+10, D//2+10), 80, 80,
                  fc="#e0e0ff", ec="#333377", lw=1.5, label="Bag tray 80×80mm"))
    ax2.text(W//2+10+40, D//2+10+40, "Bags\n80×80", ha='center', va='center', fontsize=7)

    # OLED window (front area, bottom of plan)
    oled_x = W//2 - 14; oled_y = 8
    ax2.add_patch(Rectangle((oled_x, oled_y), 28, 14,
                  fc="#222", ec="#000", lw=1.5, label="OLED 28×14mm"))
    ax2.text(W//2, oled_y+7, "OLED", ha='center', va='center',
             fontsize=6.5, color='white')

    # Status LEDs (front face, shown as small dots)
    for i, c in enumerate(['#00cc00','#ffcc00','#ff3333','#ff3333']):
        ax2.add_patch(plt.Circle((W//2-15+i*10, 30), 2, fc=c, ec='#333', lw=0.8))

    # Toggle switch (front face, shown as small circle at X=255 in plan X-axis)
    ax2.add_patch(plt.Circle((switch_x, 20), 3.25,
                  fc='#333', ec='#111', lw=1.2, label="Fan switch Ø6.5mm"))
    ax2.annotate("Fan\nswitch", (switch_x, 20), (switch_x+18, 8),
                 fontsize=6, arrowprops=dict(arrowstyle='->', lw=0.7),
                 color='#1a5a1a')

    # Handle footprint
    ax2.add_patch(Rectangle((W//2-40, D//2-4), 80, 8,
                  fc=C_PETG_DARK, ec=C_EDGE, lw=1.5, label="Handle 80mm span"))
    ax2.text(W//2, D//2, "Handle", ha='center', va='center', fontsize=7)

    # Fan exhaust on TOP SURFACE — shown as overlay with dashed outline
    # (top surface features overlaid on interior view for reference)
    ax2.add_patch(plt.Circle((fan_x, fan_y), fan_recess_r,
                  fc='none', ec='#1a5a1a', lw=1.5, ls='--',
                  label=f"Fan recess Ø{int(fan_recess_r*2)}mm (top surface)"))
    ax2.add_patch(plt.Circle((fan_x, fan_y), fan_hole_r,
                  fc='#333', ec='#111', lw=1.5,
                  label=f"Fan exhaust hole Ø{int(fan_hole_r*2)}mm"))
    # 4× M3 bolt holes
    for dx in [-fan_bolt_ctc/2, fan_bolt_ctc/2]:
        for dy in [-fan_bolt_ctc/2, fan_bolt_ctc/2]:
            ax2.add_patch(plt.Circle((fan_x+dx, fan_y+dy), 1.7,
                          fc='white', ec='#1a5a1a', lw=1))
    ax2.annotate("40mm fan\nX=150, Y=220\n(top surface)",
                 (fan_x, fan_y), (fan_x-55, fan_y+25), fontsize=6.5,
                 arrowprops=dict(arrowstyle='->', lw=0.8, color='#1a5a1a'),
                 color='#1a5a1a',
                 bbox=dict(boxstyle='round,pad=0.2', fc='#eeffee', ec='#1a5a1a', alpha=0.85))

    # Dimension arrows
    ax2.annotate('', xy=(W, D+12), xytext=(0, D+12),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(W//2, D+17, "300 mm", ha='center', fontsize=8)
    ax2.annotate('', xy=(W+12, D), xytext=(W+12, 0),
                 arrowprops=dict(arrowstyle='<->', lw=1))
    ax2.text(W+20, D//2, "300 mm", ha='center', fontsize=8, rotation=90)

    ax2.set_xlim(-15, W+35); ax2.set_ylim(-15, D+30)
    ax2.set_xlabel("X (mm)", fontsize=8); ax2.set_ylabel("Y (mm)", fontsize=8)
    ax2.set_title("Plan view — interior (top face removed) with fan overlay", fontsize=8, pad=6)
    ax2.legend(fontsize=6.5, loc='lower left')

    specs = (
        "Seed box: 60×60×50mm — airtight seed storage\n"
        "Bag tray: 80×80×30mm — zip-lock + marker storage\n"
        "OLED window: 28×14mm cutout (SSD1306)\n"
        "Status LEDs: 4× 3mm (power/water/harvest A/B+C)\n"
        "Handle: 80mm span × 25mm rise × 8mm wall\n"
        "Fan exhaust: Ø37mm hole, Ø42mm×2mm recess\n"
        "  Centre: X=150, Y=220 (rear half, top surface)\n"
        "  4× M3 bolts on 32mm bolt circle\n"
        "  40mm 12V brushless fan, exhausts upward\n"
        "Fan switch: Ø6.5mm hole, X=255, Z=50 (front face)\n"
        "Bottom flange: M3 bolts to ring 3  |  Infill: 25%"
    )
    ax2.text(0.02, 0.02, specs, transform=ax2.transAxes, fontsize=6.5,
             va='bottom', bbox=dict(boxstyle='round', fc='white', ec='#ccc', alpha=0.9))

    fig.tight_layout()
    save(fig, "08_top_cap.png")


# ════════════════════════════════════════════════════════════════════════════
# 9. MISCELLANEOUS PARTS
# ════════════════════════════════════════════════════════════════════════════
def render_misc_parts():
    fig, axes = plt.subplots(1, 3, figsize=(14, 5))
    fig.patch.set_facecolor('white')
    fig.suptitle("Miscellaneous 3D-Printed Parts", fontsize=11,
                 fontweight='bold', y=1.01)

    # ── A: 3-way water manifold ──────────────────────────────────────────
    ax = axes[0]
    ax.set_facecolor('#f8f8f8')
    ax.set_aspect('equal')
    ax.set_title("3-Way Water Manifold\n(1-to-3 drip splitter)", fontsize=8)

    # Body circle
    ax.add_patch(plt.Circle((0,0), 7, fc=C_PETG, ec=C_EDGE, lw=1.5))
    ax.text(0,0,"Body\nØ14mm", ha='center', va='center', fontsize=6)

    # Inlet barb (top)
    ax.add_patch(Rectangle((-4, 7), 8, 10, fc=C_PETG_DARK, ec=C_EDGE, lw=1.2))
    ax.add_patch(Rectangle((-3.5, 15), 7, 2, fc=C_PETG_DARK, ec=C_EDGE, lw=0.5))
    ax.text(0, 20, "Inlet barb\nØ8mm OD\n(6mm ID tube)", ha='center', fontsize=6.5)

    # Outlet barbs (three, at 120° angles from bottom)
    angles = [-60, -180, -300]  # degrees
    offsets = [(1,0),(-1,0),(0,-1)]
    labels = ["Tray A", "Tray B", "Tray C"]
    for i, ang in enumerate([-70, -90-40, -90+40+90]):
        rad = np.radians(ang)
        ex = 18 * np.cos(rad); ey = 18 * np.sin(rad)
        bx = 7 * np.cos(rad);  by = 7 * np.sin(rad)
        ax.plot([bx, ex], [by, ey], 'k-', lw=5, solid_capstyle='round')
        ax.plot([bx, ex], [by, ey], color=C_PETG_DARK, lw=3.5, solid_capstyle='round')
        ax.add_patch(plt.Circle((ex, ey), 2.5, fc='white', ec='#333', lw=1))
        ax.text(ex*1.35, ey*1.35, f"{labels[i]}\nØ6mm", ha='center', fontsize=6)

    ax.set_xlim(-35, 25); ax.set_ylim(-32, 30)
    ax.axis('off')
    ax.text(0, -30, "Qty: 1  |  Infill: 60%  |  PETG", ha='center', fontsize=7,
            style='italic', color='#555')

    # ── B: Drip emitter cap ──────────────────────────────────────────────
    ax = axes[1]
    ax.set_facecolor('#f8f8f8')
    ax.set_title("Drip Emitter Cap\n(press-fit on 6mm OD tubing)", fontsize=8)

    # Side profile
    # Body
    ax.add_patch(Rectangle((0, 0), 16, 8, fc=C_PETG, ec=C_EDGE, lw=1.5))
    # Barb insertion end (left)
    ax.add_patch(Rectangle((-2, 1.5), 3, 5, fc=C_PETG_DARK, ec=C_EDGE, lw=1))
    ax.add_patch(Rectangle((-1, 2), 2, 4, fc='white', ec='#888', lw=0.8))
    # Orifice (right end)
    ax.add_patch(plt.Circle((18, 4), 1, fc='white', ec='#333', lw=1.5))

    # Arrows
    ax.annotate('6mm ID\ntube\ninserts here', (-2, 4), (-18, 4), fontsize=7,
                arrowprops=dict(arrowstyle='->', lw=0.8), ha='center')
    ax.annotate('Ø2mm orifice\n~25 mL/event', (18, 4), (28, 4), fontsize=7,
                arrowprops=dict(arrowstyle='->', lw=0.8), ha='left', va='center')

    ax.annotate('', xy=(16, -3), xytext=(0, -3),
                arrowprops=dict(arrowstyle='<->', lw=1))
    ax.text(8, -5, "16 mm", ha='center', fontsize=7)
    ax.annotate('', xy=(-4, 8), xytext=(-4, 0),
                arrowprops=dict(arrowstyle='<->', lw=1))
    ax.text(-7, 4, "8 mm", ha='center', fontsize=7, rotation=90)

    ax.set_xlim(-25, 42); ax.set_ylim(-10, 16)
    ax.set_aspect('equal')
    ax.axis('off')
    ax.text(8, -9, "Qty: 3  |  Infill: 60%  |  PETG", ha='center', fontsize=7,
            style='italic', color='#555')

    # ── C: Tube saddle clip ──────────────────────────────────────────────
    ax = axes[2]
    ax.set_facecolor('#f8f8f8')
    ax.set_title("Tube Saddle Clip\n(secures 6mm OD silicone tubing)", fontsize=8)

    # Clip cross-section
    body_w = 14; wall_t = 4; tube_r = 3; tab_w = 8; tab_h = 8

    # Body (U-shaped saddle)
    ax.add_patch(Rectangle((-body_w//2, 0), body_w, wall_t, fc=C_PETG, ec=C_EDGE, lw=1.5))
    ax.add_patch(Rectangle((-body_w//2, wall_t), wall_t, tube_r*2+4, fc=C_PETG, ec=C_EDGE, lw=1.5))
    ax.add_patch(Rectangle((body_w//2-wall_t, wall_t), wall_t, tube_r*2+4, fc=C_PETG, ec=C_EDGE, lw=1.5))

    # Tube (schematic)
    ax.add_patch(plt.Circle((0, wall_t+tube_r+2), tube_r, fc='#cccccc', ec='#888', lw=1.5))
    ax.add_patch(plt.Circle((0, wall_t+tube_r+2), 2, fc='white', ec='#aaa', lw=0.8))
    ax.text(0, wall_t+tube_r+2, "Tube\nØ6", ha='center', va='center', fontsize=5.5)

    # Mounting tab (bottom)
    ax.add_patch(Rectangle((-tab_w//2, -tab_h), tab_w, tab_h, fc=C_PETG_DARK, ec=C_EDGE, lw=1.5))
    # Screw hole
    ax.add_patch(plt.Circle((0, -tab_h//2), 1.25, fc='white', ec='#333', lw=1))
    ax.text(0, -tab_h-3, "Self-tap\nscrew Ø2.5", ha='center', fontsize=6)

    ax.annotate('', xy=(body_w//2, 16), xytext=(-body_w//2, 16),
                arrowprops=dict(arrowstyle='<->', lw=1))
    ax.text(0, 18, f"{body_w} mm", ha='center', fontsize=7)

    ax.set_xlim(-18, 18); ax.set_ylim(-16, 22)
    ax.set_aspect('equal')
    ax.axis('off')
    ax.text(0, -14, "Qty: 12  |  Infill: 50%  |  PETG", ha='center', fontsize=7,
            style='italic', color='#555')

    fig.tight_layout()
    save(fig, "09_misc_parts.png")


# ════════════════════════════════════════════════════════════════════════════
# 10. SYSTEM STACK CUTAWAY (exploded view)
# ════════════════════════════════════════════════════════════════════════════
def render_exploded():
    fig = plt.figure(figsize=(9, 14))
    ax = fig.add_subplot(111, projection='3d')
    fig.patch.set_facecolor('white')

    W, D = 300, 300
    base_h  = 200
    ring_h  = 190
    cap_h   = 80
    explode = 40  # gap between sections

    # Draw each section with a vertical gap between
    z_positions = {
        'base':  0,
        'ring1': base_h  + explode,
        'ring2': base_h  + ring_h  + 2*explode,
        'ring3': base_h  + 2*ring_h + 3*explode,
        'cap':   base_h  + 3*ring_h + 4*explode,
    }

    part_colors = {
        'base':  C_PETG,
        'ring1': "#B8D4E8",
        'ring2': "#C4D8E0",
        'ring3': "#D0DDE0",
        'cap':   "#E0E0D0",
    }
    labels = {
        'base':  "Base Unit\n(reservoir + electronics)\n300×300×200mm",
        'ring1': "Tray Ring 1\n(oldest crop — harvest ready)\n300×300×190mm",
        'ring2': "Tray Ring 2\n(mid-growth, days 3–6)\n300×300×190mm",
        'ring3': "Tray Ring 3\n(freshly seeded, days 0–3)\n300×300×190mm",
        'cap':   "Top Cap\n(seed storage + display)\n300×300×80mm",
    }
    heights = {'base':base_h,'ring1':ring_h,'ring2':ring_h,'ring3':ring_h,'cap':cap_h}

    for name, z in z_positions.items():
        h = heights[name]
        add_box(ax, 0, 0, z, W, D, h,
                facecolor=part_colors[name], alpha=0.65)
        dim_label(ax, labels[name], W*0.5, D*0.5, z+h//2, fontsize=7)

        # Dashed leader lines at corners
        if name != 'base':
            prev_z = list(z_positions.values())[list(z_positions.keys()).index(name)-1]
            prev_h = heights[list(z_positions.keys())[list(z_positions.keys()).index(name)-1]]
            for cx, cy in [(0,0),(W,D)]:
                ax.plot([cx,cx],[cy,cy],[prev_z+prev_h, z],
                        '--', color='#aaa', lw=0.8, alpha=0.7)

    total_h = z_positions['cap'] + cap_h
    set_axes(ax, [0,300],[0,300],[0,total_h+20], elev=15, azim=-50)
    ax.set_title("Microgreen Box — Exploded Stack View\n"
                 "850mm assembled height  |  PETG throughout",
                 fontsize=10, fontweight='bold', pad=12)

    save(fig, "10_exploded_view.png")


# ════════════════════════════════════════════════════════════════════════════
# MAIN
# ════════════════════════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("Rendering Microgreen Box 3D model images…")
    render_overview()
    render_base_unit()
    render_tray_ring()
    render_growing_tray()
    render_sub_tray()
    render_led_bracket()
    render_tray_door()
    render_top_cap()
    render_misc_parts()
    render_exploded()
    print(f"\nDone. All renders saved to: {OUT}/")
