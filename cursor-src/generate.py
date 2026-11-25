import json
import os
import struct
import sys

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.abspath(__file__))
PALETTE = os.path.join(ROOT, "..", "palette", "palette.json")
OUTPUT = os.path.join(ROOT, "..", "cursor", ".local", "share", "icons", "Library")
SIZES = (24, 32, 48, 64)
SUPERSAMPLE = 8
CANVAS = 32
XCURSOR_MAGIC = b"Xcur"
IMAGE_CHUNK_TYPE = 0xFFFD0002

ARROW = [(2, 1), (2, 24), (8, 18), (12, 27), (16, 25), (12, 17), (20, 17)]
CURSORS = {
    "left_ptr": {"shape": "arrow", "fill": "text", "hotspot": (2, 1), "aliases": ["default", "arrow", "top_left_arrow"]},
    "pointer": {"shape": "arrow", "fill": "accent", "hotspot": (2, 1), "aliases": ["hand1", "hand2", "pointing_hand"]},
    "text": {"shape": "beam", "fill": "text", "hotspot": (16, 16), "aliases": ["xterm", "ibeam"]},
}


def load_palette():
    with open(PALETTE) as handle:
        return json.load(handle)["colours"]


def rgba(hex_value, alpha=255):
    return tuple(int(hex_value[i:i + 2], 16) for i in (0, 2, 4)) + (alpha,)


def scaled(points):
    return [(x * SUPERSAMPLE, y * SUPERSAMPLE) for x, y in points]


def draw_arrow(draw, fill, outline):
    draw.polygon(scaled(ARROW), fill=outline)
    draw.polygon(scaled([(3.4, 4.2), (3.4, 20.4), (8.2, 16.2), (12, 23.6), (13.6, 22.8), (9.8, 15.2), (15, 15.2)]), fill=fill)


def draw_beam(draw, fill, outline):
    draw.rectangle([13 * SUPERSAMPLE, 4 * SUPERSAMPLE, 19 * SUPERSAMPLE, 28 * SUPERSAMPLE], fill=outline)
    draw.rectangle([15 * SUPERSAMPLE, 6 * SUPERSAMPLE, 17 * SUPERSAMPLE, 26 * SUPERSAMPLE], fill=fill)
    draw.rectangle([10 * SUPERSAMPLE, 4 * SUPERSAMPLE, 22 * SUPERSAMPLE, 7 * SUPERSAMPLE], fill=outline)
    draw.rectangle([10 * SUPERSAMPLE, 25 * SUPERSAMPLE, 22 * SUPERSAMPLE, 28 * SUPERSAMPLE], fill=outline)
    draw.rectangle([11 * SUPERSAMPLE, 5 * SUPERSAMPLE, 21 * SUPERSAMPLE, 6 * SUPERSAMPLE], fill=fill)
    draw.rectangle([11 * SUPERSAMPLE, 26 * SUPERSAMPLE, 21 * SUPERSAMPLE, 27 * SUPERSAMPLE], fill=fill)


SHAPES = {"arrow": draw_arrow, "beam": draw_beam}


def render(shape, fill, outline, size):
    side = CANVAS * SUPERSAMPLE
    image = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    SHAPES[shape](ImageDraw.Draw(image), fill, outline)
    return image.resize((size, size), Image.LANCZOS)


def premultiplied_bytes(image):
    raw = image.tobytes()
    pixels = bytearray()
    for index in range(0, len(raw), 4):
        red, green, blue, alpha = raw[index:index + 4]
        pixels += struct.pack("<I", (alpha << 24) | ((red * alpha // 255) << 16) | ((green * alpha // 255) << 8) | (blue * alpha // 255))
    return bytes(pixels)


def xcursor_bytes(frames):
    header_size = 16
    toc_size = 12 * len(frames)
    chunks = []
    offset = header_size + toc_size
    toc = b""
    for size, hotspot, image in frames:
        body = struct.pack("<9I", 36, IMAGE_CHUNK_TYPE, size, 1, size, size, hotspot[0], hotspot[1], 0) + premultiplied_bytes(image)
        toc += struct.pack("<3I", IMAGE_CHUNK_TYPE, size, offset)
        chunks.append(body)
        offset += len(body)
    return XCURSOR_MAGIC + struct.pack("<3I", header_size, 0x10000, len(frames)) + toc + b"".join(chunks)


def write_cursor(name, spec, colours):
    fill = rgba(colours[spec["fill"]])
    outline = rgba(colours["bg"])
    frames = []
    for size in SIZES:
        factor = size / CANVAS
        hotspot = (round(spec["hotspot"][0] * factor), round(spec["hotspot"][1] * factor))
        frames.append((size, hotspot, render(spec["shape"], fill, outline, size)))
    target = os.path.join(OUTPUT, "cursors", name)
    with open(target, "wb") as handle:
        handle.write(xcursor_bytes(frames))
    for alias in spec["aliases"]:
        link = os.path.join(OUTPUT, "cursors", alias)
        if os.path.lexists(link):
            os.remove(link)
        os.symlink(name, link)


def write_index():
    with open(os.path.join(OUTPUT, "index.theme"), "w") as handle:
        handle.write("[Icon Theme]\nName=Library\nComment=Cream ink on navy, square\nInherits=breeze_cursors\n")


def main():
    colours = load_palette()
    os.makedirs(os.path.join(OUTPUT, "cursors"), exist_ok=True)
    for name, spec in CURSORS.items():
        write_cursor(name, spec, colours)
    write_index()
    print("wrote cursor theme Library")


if __name__ == "__main__":
    sys.exit(main())
