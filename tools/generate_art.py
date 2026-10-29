"""Create the first game-ready pixel art tiles and courier frames.

All shapes are drawn on a small integer grid and enlarged with nearest-neighbor
sampling so the assets remain crisp at the game's 480x800 viewport.
"""

from pathlib import Path
from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets"
ASSETS.mkdir(exist_ok=True)

NAVY = "#172b3c"
ROOF = ["#bc6347", "#d1784d", "#a95542"]
STONE = "#d3b98c"
ORANGE = "#e9843d"
SKIN = "#f3c391"


def art(width, height):
    image = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    return image, ImageDraw.Draw(image)


def box(draw, x0, y0, x1, y1, color):
    draw.rectangle((x0, y0, x1, y1), fill=color)


terrain, t = art(256, 16)
# 0 water, 1 packed earth, 2 grass, 3 asphalt, 4 beach sand,
# 5 stone square, 6 shallow water, 7 flowered grass.
tile_colors = ["#12627f", "#b8aa88", "#739b5d", "#516571", "#e2cf9e", "#b7b09c", "#348aa0", "#4f7d53"]
for tile, color in enumerate(tile_colors):
    for variation in (0, 1):
        x = (tile + variation * 8) * 16
        box(t, x, 0, x + 15, 15, color)
        if tile in (0, 6):
            for px, py in ((2, 3), (10, 9)) if variation == 0 else ((5, 6), (12, 2)):
                box(t, x + px, py, x + px + 3, py, "#5caeb8" if tile == 6 else "#287c91")
                box(t, x + px + 1, py + 1, x + px + 2, py + 1, "#87c4bd" if tile == 6 else "#3991a3")
        elif tile in (1, 4):
            for px, py in ((2, 3), (11, 10)) if variation == 0 else ((7, 2), (3, 12)):
                box(t, x + px, py, x + px + 1, py + 1, "#cdbb96" if tile == 1 else "#ecd7a7")
                box(t, x + px + 4, py + 3, x + px + 4, py + 3, "#9b9479")
        elif tile in (2, 7):
            for px, py in ((3, 4), (11, 11)) if variation == 0 else ((8, 3), (4, 12)):
                box(t, x + px, py, x + px + 2, py + 1, "#8eaf67" if tile == 2 else "#709b61")
                box(t, x + px + 1, py - 1, x + px + 1, py - 1, "#b3c878")
        elif tile == 5:
            for line in (4, 10):
                box(t, x, line, x + 15, line, "#aaa38f")
            for line in (5, 12):
                box(t, x + line, 0, x + line, 3, "#d1c7ad")
                box(t, x + line - 3, 5, x + line - 3, 9, "#d1c7ad")
                box(t, x + line, 11, x + line, 15, "#d1c7ad")
        elif tile == 3:
            box(t, x + 3, 5 if variation == 0 else 11, x + 5, 5 if variation == 0 else 11, "#657785")
for x, y in [(2, 2), (9, 5), (3, 11), (11, 13)]:
    box(t, x, y, x + 4, y, "#3295a6")
    box(t, x + 1, y + 1, x + 3, y + 1, "#1f7c99")
for x, y in [(1, 3), (7, 2), (3, 9), (10, 12)]:
    box(t, 16 + x, y, 18 + x, y + 1, "#d1c09a")
for x, y in [(4, 3), (10, 6), (5, 12), (13, 13)]:
    box(t, 32 + x, y, 33 + x, y + 2, "#86ad62")
box(t, 37, 5, 37, 6, "#446c49")
for x, y in [(2, 5), (9, 2), (13, 10), (5, 13)]:
    box(t, 48 + x, y, 48 + x + 1, y, "#65727a")
for x, y in [(2, 3), (11, 4), (5, 10), (12, 13)]:
    box(t, 64 + x, y, 65 + x, y, "#f0ddad")
    box(t, 64 + x + 1, y + 2, 64 + x + 2, y + 2, "#bca879")
for y in (4, 11):
    box(t, 80, y, 95, y, "#92998f")
for x in (5, 13):
    box(t, 80 + x, 0, 80 + x, 15, "#c0bcab")
for x, y in [(2, 3), (10, 7), (5, 12)]:
    box(t, 96 + x, y, 99 + x, y, "#7bc6c3")
    box(t, 97 + x, y + 1, 98 + x, y + 1, "#b4d9c7")
for x, y in [(3, 5), (11, 10)]:
    box(t, 112 + x, y, 114 + x, y + 1, "#e0ad69")
    box(t, 113 + x, y, 113 + x, y, "#f6e5ae")
terrain.save(ASSETS / "terrain.png")


buildings, b = art(400, 40)
for variant in range(3):
    x = variant * 40
    box(b, x + 3, 7, x + 38, 38, NAVY)
    box(b, x + 1, 11, x + 36, 35, STONE)
    box(b, x + 4, 14, x + 7, 30, "#a88f72")
    for wx in (10, 27):
        box(b, x + wx, 28, x + wx + 5, 33, "#31566b")
        box(b, x + wx + 1, 29, x + wx + 2, 30, "#b5dedb")
    b.polygon(
        [(x + 1, 12), (x + 8, 3), (x + 31, 3), (x + 38, 12), (x + 35, 26), (x + 4, 26)],
        fill=ROOF[variant],
    )
    box(b, x + 6, 12, x + 33, 13, "#e49b63")
    box(b, x + 18, 4, x + 20, 24, "#8c4639")
    box(b, x + 11, 8, x + 14, 11, "#f1b379")
    box(b, x + 27, 17, x + 30, 20, "#f1b379")
    if variant == 2:
        for awning_x in range(x + 5, x + 35, 6):
            box(b, awning_x, 27, awning_x + 2, 31, "#edede2")
            box(b, awning_x + 3, 27, awning_x + 5, 31, "#d6594b")

# Small landmark: a stone tower with a conical roof, drawn from above.
x = 120
box(b, x + 8, 10, x + 34, 38, "#29445a")
b.ellipse((x + 5, 6, x + 34, 35), fill="#d3c29b", outline="#6c776f", width=2)
b.ellipse((x + 10, 9, x + 29, 28), fill="#8a9a91", outline="#526579", width=2)
b.polygon([(x + 20, 2), (x + 11, 17), (x + 29, 17)], fill="#42647a")
box(b, x + 18, 6, x + 21, 14, "#7396a2")
for wx in (9, 29):
    box(b, x + wx, 21, x + wx + 2, 25, NAVY)

# Six small Şile house silhouettes based on the concept brief. Keep the roof
# dominant so each remains readable at the 24px map display size.
for variant in range(6):
    x = 160 + variant * 40
    walls = ("#f2e8d4", "#e8d3ad", "#f1e9d9", "#80634e", "#c1b79e", "#e8cf91")
    roofs = ("#b95d45", "#c66b48", "#cb714c", "#855747", "#aa5946", "#c8754b")
    # Slightly different footprints suggest cottages, family homes and shops.
    inset = (5, 3, 4, 7, 4, 3)[variant]
    box(b, x + inset + 1, 13, x + 39 - inset, 36, NAVY)
    box(b, x + inset + 3, 15, x + 37 - inset, 34, walls[variant])
    box(b, x + inset + 3, 29, x + 37 - inset, 31, "#b29e83")
    # A visible wall strip, with muted teal shutters on the coastal house.
    for wx in (x + inset + 7, x + 28 - inset):
        box(b, wx, 23, wx + 4, 27, "#35566a")
        box(b, wx + 1, 24, wx + 2, 25, "#a5d2d0")
        if variant == 2:
            box(b, wx - 2, 23, wx - 1, 27, "#5e938f")
            box(b, wx + 5, 23, wx + 6, 27, "#5e938f")
    b.polygon([(x + inset, 15), (x + inset + 8, 5), (x + 30 - inset, 5),
               (x + 39 - inset, 15), (x + 36 - inset, 22), (x + inset + 3, 22)], fill=NAVY)
    b.polygon([(x + inset + 2, 15), (x + inset + 9, 7), (x + 29 - inset, 7),
               (x + 37 - inset, 15), (x + 34 - inset, 20), (x + inset + 5, 20)], fill=roofs[variant])
    box(b, x + 11, 12, x + 27, 13, "#e4a073")
    for tile_x in (11, 18, 25):
        box(b, x + tile_x, 16, x + tile_x + 3, 17, "#8e4e3e")
    box(b, x + 29, 4, x + 33, 11, walls[variant])  # chimney
    box(b, x + 28, 3, x + 34, 4, NAVY)
    box(b, x + 18, 31, x + 23, 35, "#775a4c")
    if variant == 1:  # small timber balcony
        box(b, x + 12, 28, x + 28, 29, "#705847")
        for post in (13, 20, 27):
            box(b, x + post, 27, x + post, 31, "#705847")
    elif variant == 3:  # timber cladding
        for plank_y in (24, 27, 30):
            box(b, x + 9, plank_y, x + 31, plank_y, "#a07a5c")
    elif variant == 4:  # stone ground floor
        for stone_x in (9, 15, 26, 32):
            box(b, x + stone_x, 29, x + stone_x + 2, 30, "#8c9186")
    elif variant == 5:  # compact projecting bay
        box(b, x + 8, 23, x + 14, 30, "#e8cf91")
        box(b, x + 9, 24, x + 12, 27, "#4f8390")
buildings.save(ASSETS / "buildings.png")


props, p = art(160, 32)
# Tree with a readable dark outline and three canopy shades.
p.ellipse((6, 24, 27, 30), fill="#48634b")
box(p, 14, 18, 18, 28, "#70543b")
p.ellipse((4, 8, 28, 24), fill="#285e48", outline=NAVY)
p.ellipse((6, 4, 19, 19), fill="#4f9359")
p.ellipse((15, 6, 27, 19), fill="#4c8b53")
for x, y in [(10, 8), (20, 10), (8, 17)]:
    box(p, x, y, x + 3, y + 2, "#91ba6b")
# White and orange Bosphorus ferry, top-down.
p.polygon([(36, 16), (42, 9), (54, 7), (60, 10), (61, 25), (37, 25)], fill=NAVY)
p.polygon([(38, 15), (43, 10), (54, 9), (59, 13), (59, 23), (38, 23)], fill="#f4e8d1")
box(p, 42, 14, 56, 16, "#db8352")
for x in (42, 47, 52):
    box(p, x, 19, x + 2, 21, "#36718c")
box(p, 45, 7, 47, 10, "#e8bd66")
# Waterfront street stall.
box(p, 69, 17, 90, 28, "#6b4d39")
box(p, 72, 21, 87, 25, "#dda15d")
for x in range(68, 92, 6):
    box(p, x, 12, x + 2, 18, "#f6ebd2")
    box(p, x + 3, 12, x + 5, 18, "#cf5848")
box(p, 72, 10, 87, 11, NAVY)
# Şile lighthouse: chunky white tower and warm beacon.
box(p, 108, 27, 116, 30, "#536b62")
box(p, 109, 12, 115, 27, NAVY)
box(p, 110, 13, 114, 26, "#f1e9d6")
box(p, 108, 11, 116, 14, "#bd5d49")
box(p, 110, 6, 114, 11, "#f5dc9b")
box(p, 109, 4, 115, 6, "#334c5b")
box(p, 111, 2, 113, 4, "#e5b963")
box(p, 106, 20, 118, 22, "#e8e2cf")
# Shore rocks and a low shrub.
box(p, 132, 23, 155, 29, "#295267")
p.polygon([(132, 25), (137, 19), (143, 20), (146, 16), (152, 20), (156, 25)], fill="#a8a897")
box(p, 136, 20, 139, 21, "#d0c8ad")
box(p, 148, 18, 150, 20, "#d0c8ad")
p.ellipse((139, 12, 150, 20), fill="#3e7958", outline=NAVY)
p.ellipse((142, 10, 152, 18), fill="#619c60")
props.save(ASSETS / "props.png")


def courier_frame(direction, stride):
    sprite, d = art(12, 16)
    # The foot position stays at the same pixel in each animation frame.
    box(d, 3, 14, 5, 15 if stride == 0 else 14, NAVY)
    box(d, 7, 14 if stride == 0 else 13, 9, 15, NAVY)
    box(d, 3, 11, 5, 13, "#283e59")
    box(d, 7, 11, 9, 13, "#283e59")
    box(d, 2, 6, 9, 11, NAVY)
    box(d, 3, 7, 8, 10, ORANGE)
    box(d, 3, 9, 8, 9, "#ffd56c")
    box(d, 4, 10, 7, 10, "#b65d36")
    box(d, 1, 7, 2, 10 if stride == 0 else 9, ORANGE)
    box(d, 10, 7, 11, 9 if stride == 0 else 10, ORANGE)
    box(d, 2, 10 if stride == 0 else 9, 2, 11, SKIN)
    box(d, 10, 9 if stride == 0 else 10, 10, 11, SKIN)
    box(d, 3, 2, 8, 6, NAVY)
    box(d, 4, 3, 7, 5, SKIN)
    box(d, 3, 1, 8, 2, "#25384b")
    box(d, 4, 0, 7, 1, "#25384b")
    box(d, 4, 2, 7, 2, "#e9a14d")
    if direction == 0:  # facing down, backpack edges visible
        box(d, 5, 7, 6, 10, "#ffc260")
        box(d, 4, 4, 4, 4, "#2d4554")
        box(d, 7, 4, 7, 4, "#2d4554")
    elif direction == 1:  # back view
        box(d, 3, 3, 8, 6, "#273e50")
        box(d, 3, 6, 8, 11, "#b95b31")
        box(d, 4, 7, 7, 9, "#ed8e3c")
        box(d, 5, 10, 6, 10, "#f5bd66")
        box(d, 4, 8, 7, 8, "#ffe08a")
    else:
        box(d, 7, 7, 9, 10, "#b95b31")
        box(d, 8, 8, 8, 9, "#ffc260")
        box(d, 3, 4, 3, 4, "#513f37")
        if direction == 3:
            sprite = sprite.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    return sprite.resize((24, 32), Image.Resampling.NEAREST)


courier, _ = art(8 * 24, 32)
for direction in range(4):
    for stride in range(2):
        courier.paste(courier_frame(direction, stride), ((direction * 2 + stride) * 24, 0))
courier.save(ASSETS / "courier_walk.png")


def vehicle_frame(kind, direction, stride):
    """One 12px top-down courier vehicle, enlarged on a fixed 24px cell."""
    sprite, d = art(12, 12)
    if kind == 3:  # compact company car
        box(d, 2, 0, 9, 11, NAVY)
        box(d, 3, 1, 8, 10, "#f1ede2")
        box(d, 3, 1, 8, 2, "#f1bb65")
        box(d, 3, 9, 8, 10, "#da8056")
        box(d, 3, 3, 8, 5, "#6ca8b7")
        box(d, 3, 7, 8, 8, "#6ca8b7")
        box(d, 1, 2, 2, 4, "#273949")
        box(d, 9, 2, 10, 4, "#273949")
        box(d, 1, 8, 2, 10, "#273949")
        box(d, 9, 8, 10, 10, "#273949")
        box(d, 4, 0, 4, 0, "#fff1bc")
        box(d, 7, 0, 7, 0, "#fff1bc")
    else:
        body = ["#e5b451", "#e27948", "#c95248"][kind]
        box(d, 4, 0, 7, 3, NAVY)
        box(d, 4, 9, 7, 11, NAVY)
        box(d, 5, 1, 6, 2, "#7899aa" if stride else "#526a7b")
        box(d, 5, 10, 6, 10, "#7899aa" if stride else "#526a7b")
        if kind == 0:  # bicycle frame and pedals
            d.line([(5, 3), (3, 7), (6, 9), (8, 7), (5, 3)], fill=body, width=1)
            box(d, 2, 3, 9, 3, "#c8d4c3")
            box(d, 2 if stride else 8, 7, 3 if stride else 9, 8, "#f4c291")
            box(d, 5, 4, 6, 5, "#f5d38e")
        else:  # motor body and headlights
            box(d, 4, 2, 7, 10, body)
            box(d, 5, 1, 6, 2, "#fff1bc")
            box(d, 3, 4, 8, 5, "#263c4d")
            box(d, 4, 9, 7, 9, "#f5ca72")
            box(d, 4, 2, 4, 3, "#ffd589")
        box(d, 3, 6, 8, 8, NAVY)
        box(d, 4, 6, 7, 7, ORANGE)
        box(d, 4, 4, 7, 6, "#f1ca9d")
        box(d, 4, 3, 7, 4, "#f1f2e5" if kind < 2 else "#283849")
        box(d, 8, 8, 10, 10, "#edaa50")  # delivery box
        box(d, 8, 8, 10, 8, "#ffe19a")
        box(d, 9, 9, 9, 10, "#b96b3e")
    if direction == 0:
        sprite = sprite.transpose(Image.Transpose.ROTATE_180)
    elif direction == 2:
        sprite = sprite.transpose(Image.Transpose.ROTATE_90)
    elif direction == 3:
        sprite = sprite.transpose(Image.Transpose.ROTATE_270)
    return sprite.resize((24, 24), Image.Resampling.NEAREST)


vehicles, _ = art(8 * 24, 4 * 24)
for kind in range(4):
    for direction in range(4):
        for stride in range(2):
            frame = direction * 2 + stride
            vehicles.paste(vehicle_frame(kind, direction, stride), (frame * 24, kind * 24))
vehicles.save(ASSETS / "vehicles.png")


markers, m = art(32, 16)
# Restaurant/shop sign: orange striped awning, lit window and door.
box(m, 1, 5, 14, 14, NAVY)
box(m, 2, 7, 13, 13, "#ddbd8f")
box(m, 1, 3, 14, 7, "#e9e1c8")
for x in (2, 6, 10):
    box(m, x, 3, x + 2, 6, "#d76b4b")
box(m, 4, 8, 8, 11, "#87b9ba")
box(m, 10, 9, 12, 13, "#684f40")
box(m, 3, 1, 12, 2, "#e7b75c")
# Apartment sign: blue roof, two windows and a dark entrance.
box(m, 17, 5, 30, 14, NAVY)
box(m, 18, 6, 29, 13, "#d4c8ad")
m.polygon([(17, 5), (23, 1), (30, 5)], fill="#60899d")
for x in (19, 26):
    box(m, x, 7, x + 2, 9, "#77adbb")
box(m, 22, 10, 25, 14, "#4d6471")
markers.save(ASSETS / "markers.png")

# Launcher icon, drawn at 64px then scaled without blur.
icon, i = art(64, 64)
box(i, 0, 0, 63, 63, "#122c40")
box(i, 0, 41, 63, 63, "#13657b")
for y in (46, 55, 61):
    for x in range(3 + y % 7, 64, 17):
        box(i, x, y, min(63, x + 7), y + 1, "#3c9aae")
box(i, 5, 36, 59, 39, "#e3c695")
for x in (12, 52):
    box(i, x, 20, x + 3, 37, "#e3c695")
    box(i, x + 1, 17, x + 2, 19, "#f2d9a3")
for x in range(15, 53, 5):
    i.line((14, 22, x, 30), fill="#bbd3ce", width=1)
box(i, 19, 26, 44, 53, NAVY)
box(i, 21, 28, 42, 51, "#ef893d")
box(i, 25, 24, 38, 29, "#ef893d")
box(i, 27, 23, 36, 25, "#ffd080")
box(i, 23, 32, 40, 35, "#ffc46d")
box(i, 27, 37, 36, 45, "#fff0ce")
box(i, 30, 38, 33, 44, "#bd633e")
box(i, 27, 40, 36, 42, "#bd633e")
icon.resize((256, 256), Image.Resampling.NEAREST).save(ASSETS / "icon.png")

print("Generated terrain, buildings, props, courier_walk, vehicles, markers and icon in", ASSETS)
