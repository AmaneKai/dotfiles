import json
import math
import os
import random

from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.dirname(os.path.abspath(__file__))
PALETTE = os.path.join(ROOT, "..", "palette", "palette.json")
OUTPUT = os.path.join(ROOT, "..", "quickshell", ".config", "quickshell", "library", "assets")
SEED = 1923
SUPERSAMPLE = 4
GRAIN_SIDE = 256
FIBRE_COUNT = 260
RULE_LENGTH = 512
RULE_HEIGHT = 8
CORNER_SIDE = 16


def load_colours():
    with open(PALETTE) as handle:
        return json.load(handle)["colours"]


def rgb(hex_value):
    return tuple(int(hex_value[i:i + 2], 16) for i in (0, 2, 4))


def wobble(position, phases, amplitude):
    return amplitude * sum(math.sin(position * frequency + phase) for frequency, phase in phases) / len(phases)


def random_phases(generator, period, count=3):
    return [(generator.randint(2, 9) * math.tau / period, generator.uniform(0, math.tau)) for _ in range(count)]


def tile_offsets(side):
    return [(dx * side, dy * side) for dx in (-1, 0, 1) for dy in (-1, 0, 1)]


def paper_grain(colours, generator, side=GRAIN_SIDE):
    light = rgb(colours["text"])
    image = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    pixels = image.load()
    for y in range(side):
        for x in range(side):
            pixels[x, y] = light + (generator.randint(0, 20),)
    draw = ImageDraw.Draw(image)
    for _ in range(FIBRE_COUNT * (side // GRAIN_SIDE) ** 2):
        x, y = generator.uniform(0, side), generator.uniform(0, side)
        angle = generator.uniform(0, math.tau)
        length = generator.uniform(4, 14)
        alpha = generator.randint(14, 34)
        for dx, dy in tile_offsets(side):
            end = (x + dx + math.cos(angle) * length, y + dy + math.sin(angle) * length)
            draw.line([(x + dx, y + dy), end], fill=light + (alpha,), width=1)
    return image


def inked_rule(colours, generator):
    ink = rgb(colours["text"])
    side = RULE_LENGTH * SUPERSAMPLE
    height = RULE_HEIGHT * SUPERSAMPLE
    canvas = Image.new("RGBA", (side, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    for offset, alpha, width in ((0.35, 150, 1.5), (0.68, 70, 1.0)):
        phases = random_phases(generator, side)
        baseline = height * offset
        points = [(x, baseline + wobble(x, phases, SUPERSAMPLE * 0.7)) for x in range(0, side + 1, 4)]
        draw.line(points, fill=ink + (alpha,), width=max(1, round(width * SUPERSAMPLE)))
    return canvas.resize((RULE_LENGTH, RULE_HEIGHT), Image.LANCZOS)


def inked_corner(colours, generator):
    ink = rgb(colours["accent"])
    side = CORNER_SIDE * SUPERSAMPLE
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    jitter = lambda: generator.uniform(-0.6, 0.6) * SUPERSAMPLE
    arm = side * 0.82
    draw.line([(1.5 * SUPERSAMPLE + jitter(), 1.5 * SUPERSAMPLE), (1.5 * SUPERSAMPLE + jitter(), arm)], fill=ink + (230,), width=SUPERSAMPLE)
    draw.line([(1.5 * SUPERSAMPLE, 1.5 * SUPERSAMPLE + jitter()), (arm, 1.5 * SUPERSAMPLE + jitter())], fill=ink + (230,), width=SUPERSAMPLE)
    centre = 5 * SUPERSAMPLE
    reach = 1.6 * SUPERSAMPLE
    draw.polygon([(centre, centre - reach), (centre + reach, centre), (centre, centre + reach), (centre - reach, centre)], fill=ink + (200,))
    return canvas.resize((CORNER_SIDE, CORNER_SIDE), Image.LANCZOS)


ASSETS = {
    "paper-grain.png": paper_grain,
    "inked-rule.png": inked_rule,
    "inked-corner.png": inked_corner,
}


def main():
    colours = load_colours()
    os.makedirs(OUTPUT, exist_ok=True)
    for name, build in ASSETS.items():
        build(colours, random.Random(SEED)).save(os.path.join(OUTPUT, name))
        print("wrote " + name)


if __name__ == "__main__":
    main()
