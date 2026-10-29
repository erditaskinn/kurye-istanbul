"""Build an original, compact coastal town for the Şile game chapter.

Coordinates are hand composed for readability and do not use map data.
"""

import json
import random
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "assets/maps/sile.json"


def build():
    rng = random.Random(42)
    xs = [62, 145, 230, 315, 410]
    ys = [338, 418, 502, 590, 682]
    nodes = []
    for row, y in enumerate(ys):
        for col, x in enumerate(xs):
            nodes.append([x + (5 if row % 2 else -5) * (col % 2), y + (4 if col % 2 else -3) * (row % 2)])
    edges = []
    major_edges = []
    for row in range(len(ys)):
        for col in range(len(xs)):
            current = row * len(xs) + col
            if col + 1 < len(xs):
                edges.append([current, current + 1])
                if row in (0, 2):
                    major_edges.append(len(edges) - 1)
            if row + 1 < len(ys) and col in (0, 2, 4):
                edges.append([current, current + len(xs)])
                if col == 2:
                    major_edges.append(len(edges) - 1)
    # Two quiet neighborhood connectors complete the network without a dense grid.
    for a, b in [(6, 11), (13, 18)]:
        edges.append([a, b])
    coastline = [[-96, 278], [0, 284], [54, 291], [108, 287], [157, 273],
                 [203, 268], [252, 274], [303, 285], [353, 280], [411, 289],
                 [480, 282], [576, 281]]
    def coast_y(x):
        for a, b in zip(coastline, coastline[1:]):
            if a[0] <= x <= b[0]:
                fraction = (x - a[0]) / (b[0] - a[0])
                return a[1] + (b[1] - a[1]) * fraction
        return 280
    buildings = []
    for row, y in enumerate((374, 458, 545, 632)):
        for col, x in enumerate((103, 185, 272, 360, 450)):
            if (row, col) in ((0, 2), (1, 1), (2, 3)):
                continue
            buildings.append([x + rng.randrange(-7, 8), y + rng.randrange(-7, 8), 4 + (row * 5 + col) % 6])
    trees = [[x + rng.randrange(-8, 9), y + rng.randrange(-9, 10)]
             for x, y in [(35, 360), (190, 350), (355, 355), (465, 385), (35, 460),
                          (260, 460), (385, 465), (65, 545), (178, 550), (450, 560),
                          (44, 625), (242, 624), (390, 640), (90, 723), (180, 733),
                          (275, 723), (360, 730), (447, 730)]]
    return {
        "nodes": nodes, "edges": edges, "major_edges": major_edges,
        "coastline": coastline, "shore_heights": [round(coast_y(x), 1) for x in range(0, 484, 4)],
        "pickup_nodes": [1, 3, 5, 9, 11, 13, 16, 21],
        "drop_nodes": [2, 7, 10, 14, 17, 19, 22, 24], "spawn_node": 12,
        "buildings": buildings, "urban_roofs": [], "trees": trees,
        "props": {"pier": [100, 270], "lighthouse": [190, 246],
                  "rocks": [[280, 238], [425, 250]], "ferry": [75, 200],
                  "stall": [270, 373], "lamps": [[145, 324], [315, 324], [230, 489]]},
    }


if __name__ == "__main__":
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(build(), ensure_ascii=False, separators=(",", ":")) + "\n")
    print("Created fictional Şile map:", OUTPUT)
