import base64
import importlib.util
import io
import json
import os
import random
import re

ROOT = os.path.dirname(os.path.abspath(__file__))
PALETTE = os.path.join(ROOT, "..", "palette", "palette.json")
TEXTURES = os.path.join(ROOT, "..", "texture-src", "generate.py")
BASE = "/usr/share/Kvantum/KvFlat"
OUTPUT = os.path.join(ROOT, "..", "kvantum", ".config", "Kvantum")
THEME = "Library"
GRAIN_SIDE = 1024
SEED = 1923
TEXTURED_ELEMENT = "window"
TEXTURED_SECTIONS = ("Window", "Toolbar", "Dock", "MenuBar")
CORNER_GROUP = re.compile(r'(<g[^>]*id="[a-z0-9-]*-(?:topleft|topright|bottomleft|bottomright)"[^>]*>)(.*?)(</g>)', re.S)
CUBIC = re.compile(r"c\s*(-?[\d.]+)[, ](-?[\d.]+)\s+(-?[\d.]+)[, ](-?[\d.]+)\s+(-?[\d.]+)[, ](-?[\d.]+)")
COLOUR = re.compile(r"#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})\b")
GREY_RAMP = (("bar", 0.0), ("bg", 0.16), ("surface", 0.3), ("rule", 0.42), ("dim", 0.62), ("muted", 0.8), ("heading", 0.92), ("text", 1.0))
ACCENT_RAMP = (("accent2", 0.0), ("accent", 0.45), ("gold", 0.8), ("text", 1.0))
SATURATION_THRESHOLD = 40
EXTRA_HACKS = ("transparent_dolphin_view=true",)


def load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_colours():
    with open(PALETTE) as handle:
        return json.load(handle)["colours"]


def parse_hex(text):
    if len(text) == 3:
        text = "".join(character * 2 for character in text)
    return tuple(int(text[i:i + 2], 16) for i in (0, 2, 4))


def format_hex(channels):
    return "#" + "".join("%02x" % max(0, min(255, round(value))) for value in channels)


def luminance(channels):
    red, green, blue = channels
    return (0.2126 * red + 0.7152 * green + 0.0722 * blue) / 255


def ramp_colour(ramp, colours, level):
    stops = [(parse_hex(colours[name]), position) for name, position in ramp]
    for (low, low_position), (high, high_position) in zip(stops, stops[1:]):
        if level <= high_position:
            span = (level - low_position) / (high_position - low_position)
            return tuple(a + (b - a) * span for a, b in zip(low, high))
    return stops[-1][0]


def is_accent(channels):
    red, green, blue = channels
    return max(channels) - min(channels) > SATURATION_THRESHOLD and blue > red


def recolour(match, colours):
    channels = parse_hex(match.group(1))
    ramp = ACCENT_RAMP if is_accent(channels) else GREY_RAMP
    return format_hex(ramp_colour(ramp, colours, luminance(channels)))


def recolour_text(text, colours):
    return COLOUR.sub(lambda match: recolour(match, colours), text)


def square_arc(match):
    dx1, dy1, dx2, dy2, dx, dy = (float(value) for value in match.groups())
    determinant = dx1 * (dy - dy2) - dy1 * (dx - dx2)
    if abs(determinant) < 1e-9:
        return "l %g,%g" % (dx, dy)
    along = (dx * (dy - dy2) - dy * (dx - dx2)) / determinant
    corner_x, corner_y = along * dx1, along * dy1
    return "l %g,%g %g,%g" % (corner_x, corner_y, dx - corner_x, dy - corner_y)


def square_corners(svg):
    def square_group(match):
        return match.group(1) + CUBIC.sub(square_arc, match.group(2)) + match.group(3)
    return CORNER_GROUP.sub(square_group, svg)


def grain_data_uri(colours):
    textures = load_module(TEXTURES, "library_textures")
    image = textures.paper_grain(colours, random.Random(SEED), GRAIN_SIDE)
    buffer = io.BytesIO()
    image.save(buffer, format="PNG", optimize=True)
    return "data:image/png;base64," + base64.b64encode(buffer.getvalue()).decode()


def textured_element(colours, uri):
    return (
        '<g id="%s-normal"><rect x="0" y="0" width="%d" height="%d" style="fill:#%s"/>'
        '<image x="0" y="0" width="%d" height="%d" preserveAspectRatio="xMinYMin slice" xlink:href="%s"/></g>'
        % (TEXTURED_ELEMENT, GRAIN_SIDE, GRAIN_SIDE, colours["bg"], GRAIN_SIDE, GRAIN_SIDE, uri)
    )


def build_svg(colours):
    with open(os.path.join(BASE, "KvFlat.svg")) as handle:
        svg = square_corners(recolour_text(handle.read(), colours))
    element = textured_element(colours, grain_data_uri(colours))
    return svg.replace("</svg>", element + "</svg>")


def retexture_section(config, section):
    pattern = re.compile(r"(\[%s\]\n)(.*?)(?=\n\[|\Z)" % section, re.S)
    def rewrite(match):
        lines = [line for line in match.group(2).split("\n") if not line.startswith(("interior=", "interior.element="))]
        lines += ["interior=true", "interior.element=" + TEXTURED_ELEMENT]
        return match.group(1) + "\n".join(lines)
    if pattern.search(config):
        return pattern.sub(rewrite, config)
    return config + "\n[%s]\ninterior=true\ninterior.element=%s\n" % (section, TEXTURED_ELEMENT)


def build_config(colours):
    with open(os.path.join(BASE, "KvFlat.kvconfig")) as handle:
        config = recolour_text(handle.read(), colours)
    config = re.sub(r"(?m)^(\S+\.color)=white$", lambda match: "%s=#%s" % (match.group(1), colours["text"]), config)
    for section in TEXTURED_SECTIONS:
        config = retexture_section(config, section)
    config = add_hacks(config)
    return config.replace("comment=A dark flat theme inspired by Breeze", "comment=Cream ink on navy paper, square")


def add_hacks(config):
    return config.replace("[Hacks]\n", "[Hacks]\n" + "".join(line + "\n" for line in EXTRA_HACKS), 1)


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as handle:
        handle.write(text)


def main():
    colours = load_colours()
    write(os.path.join(OUTPUT, THEME, THEME + ".svg"), build_svg(colours))
    write(os.path.join(OUTPUT, THEME, THEME + ".kvconfig"), build_config(colours))
    write(os.path.join(OUTPUT, "kvantum.kvconfig"), "[General]\ntheme=%s\n" % THEME)
    print("wrote kvantum theme " + THEME)


if __name__ == "__main__":
    main()
