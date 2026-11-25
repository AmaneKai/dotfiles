"""Shared pieces for the library launcher's rofi script modes."""
import configparser
import json
import os
import re
import subprocess
import zlib
from html import escape

HOME = os.path.expanduser("~")
STATE_DIR = os.path.join(os.environ.get("XDG_STATE_HOME", HOME + "/.local/state"), "library-launcher")
CACHE_DIR = os.path.join(os.environ.get("XDG_CACHE_HOME", HOME + "/.cache"), "library-launcher")

APP_DIRS = [
    HOME + "/.local/share/applications",
    HOME + "/.local/share/flatpak/exports/share/applications",
    "/var/lib/flatpak/exports/share/applications",
    "/usr/local/share/applications",
    "/usr/share/applications",
]

# book spine fills, picked by hashing the app name
SPINE_COLORS = ["#ce8563", "#283a51", "#dfba88", "#c8cdab", "#68474e", "#a65651"]
LIGHT_FILLS = {"#ce8563", "#dfba88", "#c8cdab"}      # these take navy lettering

CREAM, MUTED, SUB, ACCENT, RULE = "#f6e7c0", "#8e7f6b", "#a39682", "#ce8563", "#3a4d68"
SERIF = "Shippori Mincho"
SANS = "Zen Kaku Gothic New, Noto Sans CJK JP"
MONO = "JetBrainsMono Nerd Font"


# ---------- rofi script protocol ----------

def row(text, icon=None, info=None, meta=None, selectable=True):
    parts = []
    if icon:
        parts += ["icon", icon]
    if meta:
        parts += ["meta", meta]
    if info:
        parts += ["info", info]
    if not selectable:
        parts += ["nonselectable", "true"]
    return text + ("\0" + "\x1f".join(parts) if parts else "")


def option(key, value):
    return "\0%s\x1f%s" % (key, value)


def header(name, label, rule=22):
    """Section header: serif name, a hairline rule, a mono uppercase label."""
    text = ("<span font_family='%s' size='11250' foreground='#d6c8aa'>%s</span>  "
            "<span foreground='%s'>%s</span>  "
            "<span font_family='%s' size='8250' foreground='%s'>%s</span>"
            % (SERIF, escape(name), RULE, "─" * rule, MONO, MUTED, escape(label.upper())))
    return row(text, selectable=False)


def entry_text(name, sub):
    """Name over a sub line. Rows must stay on one protocol line, so the line
    break is Pango's &#10; rather than a newline."""
    return ("<span size='12000'>%s</span>&#10;<span size='9750' foreground='%s'>%s</span>"
            % (escape(name), SUB, escape(sub)))


# ---------- spine and index-card icons ----------

def _write_once(path, content):
    if not os.path.exists(path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
    return path


def spine(name):
    """A 24px-wide book spine: hashed fill, a dark band near the top and bottom,
    the app's first letter in Shippori Mincho bold. Height varies 32..38."""
    h = zlib.crc32(name.encode("utf-8"))
    color = SPINE_COLORS[h % len(SPINE_COLORS)]
    height = 32 + (h >> 8) % 7
    letter = (name.strip()[:1] or "?").upper()
    ink = "#0a1626" if color in LIGHT_FILLS else CREAM
    top = 38 - height
    svg = (
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="38" viewBox="0 0 24 38">'
        '<rect x="0" y="%d" width="24" height="%d" rx="1.5" fill="%s"/>'
        '<rect x="0" y="%d" width="24" height="2" fill="#0a1626" fill-opacity="0.45"/>'
        '<rect x="0" y="%d" width="24" height="2" fill="#0a1626" fill-opacity="0.45"/>'
        '<text x="12" y="%d" text-anchor="middle" font-family="%s, serif" font-weight="700" '
        'font-size="14" fill="%s">%s</text></svg>'
        % (top, height, color, top + 4, 36 - 4, top + height // 2 + 5, SERIF, ink, escape(letter))
    )
    return _write_once("%s/spine-%s-%d-%x.svg" % (CACHE_DIR, color[1:], height, ord(letter)), svg)


def index_card():
    """A cream index card: red top line, blue ruled lines."""
    svg = (
        '<svg xmlns="http://www.w3.org/2000/svg" width="56" height="72" viewBox="0 0 56 72">'
        '<rect width="56" height="72" rx="2" fill="#f6e7c0"/>'
        '<rect y="14" width="56" height="1.5" fill="#a65651"/>'
        + "".join('<rect x="4" y="%d" width="48" height="1" fill="#6f8fb5"/>' % y for y in range(26, 66, 9))
        + "</svg>"
    )
    return _write_once(CACHE_DIR + "/index-card.svg", svg)


# ---------- applications ----------

def read_entries():
    entries = {}
    for directory in APP_DIRS:
        if not os.path.isdir(directory):
            continue
        for filename in sorted(os.listdir(directory)):
            if not filename.endswith(".desktop"):
                continue
            desktop_id = filename[: -len(".desktop")]
            if desktop_id in entries:
                continue
            cp = configparser.ConfigParser(interpolation=None, strict=False)
            try:
                cp.read(os.path.join(directory, filename), encoding="utf-8")
                d = cp["Desktop Entry"]
            except (configparser.Error, KeyError, UnicodeDecodeError):
                continue
            if d.get("Type") != "Application":
                continue
            if d.get("NoDisplay", "").lower() == "true" or d.get("Hidden", "").lower() == "true":
                continue
            only = [x for x in d.get("OnlyShowIn", "").split(";") if x]
            if only and "Hyprland" not in only:
                continue
            name = d.get("Name", "").strip()
            if not name:
                continue
            sub = (d.get("Comment") or d.get("GenericName") or "Application").strip()
            exec_words = d.get("Exec", "").split()
            exec_name = os.path.basename(exec_words[0]).lower() if exec_words else ""
            entries[desktop_id] = {
                "id": desktop_id,
                "name": name,
                "sub": sub if len(sub) <= 64 else sub[:61] + "…",
                "keys": {desktop_id.lower(), d.get("StartupWMClass", "").lower(), exec_name} - {""},
            }
    return entries


def app_row(e):
    return row(entry_text(e["name"], e["sub"]), icon=spine(e["name"]), info="app:" + e["id"],
               meta=e["id"])


def recent_ids():
    try:
        with open(STATE_DIR + "/recent.json") as f:
            return [x for x in json.load(f) if isinstance(x, str)]
    except (OSError, ValueError):
        return []


def remember(desktop_id, keep=4):
    ids = [desktop_id] + [x for x in recent_ids() if x != desktop_id]
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(STATE_DIR + "/recent.json", "w") as f:
        json.dump(ids[:keep], f)


# ---------- windows ----------

def windows():
    try:
        out = subprocess.run(["hyprctl", "clients", "-j"], capture_output=True, text=True, timeout=3).stdout
        clients = json.loads(out)
    except (OSError, ValueError, subprocess.SubprocessError):
        return []
    clients = [c for c in clients if c.get("mapped") and (c.get("class") or c.get("title"))]
    clients.sort(key=lambda c: c.get("focusHistoryID", 99))
    return clients


def window_row(c, entries):
    cls = c.get("class", "")
    app = cls
    for e in entries.values():
        if cls.lower() in e["keys"]:
            app = e["name"]
            break
    title = c.get("title") or cls
    if len(title) > 70:
        title = title[:67] + "…"
    sub = "Workspace %s  ·  %s  ·  Switch to window" % (c.get("workspace", {}).get("name", "?"), app)
    return row(entry_text(title, sub), icon=spine(app), info="win:" + c["address"],
               meta=" ".join([cls, app]))


# ---------- calculator ----------

_MATH = re.compile(r"^[0-9a-zA-Z_+\-*/^().,%\s]+$")


def calculate(expr):
    """Return the result string if expr is a math expression, else None."""
    expr = expr.strip()
    if not expr or not _MATH.match(expr) or not re.search(r"\d", expr):
        return None
    if not re.search(r"[+\-*/^%]|sqrt|sin|cos|tan|log|ln|\(", expr):
        return None
    try:
        out = subprocess.run(["qalc", "-t", expr], capture_output=True, text=True, timeout=3)
    except (OSError, subprocess.SubprocessError):
        return None
    result = out.stdout.strip().splitlines()[-1].strip() if out.stdout.strip() else ""
    if out.returncode != 0 or not result or result.lower().startswith(("error", "warning")):
        return None
    return result


def notify(title, body):
    subprocess.run(["notify-send", "-a", "library", "-t", "3500", title, body])
