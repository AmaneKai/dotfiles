#!/usr/bin/env python3
"""rofi script modes for the library launcher.

    modes.py all|apps|windows        used through  rofi -modi "all:modes.py all,..."

rofi calls this with no arguments to list rows, and again with the chosen row's
info in $ROFI_INFO (ROFI_RETV=1) or the typed text as $1 (ROFI_RETV=2).
"""
import os
import subprocess
import sys

sys.dont_write_bytecode = True      # keep __pycache__ out of the stowed repo
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib  # noqa: E402


def emit(options, rows):
    sys.stdout.write("".join(o + "\n" for o in options) + "".join(r + "\n" for r in rows))


def listing(mode):
    entries = lib.read_entries()
    options = [lib.option("markup-rows", "true"), lib.option("no-custom", "false")]
    lines = []

    if mode in ("all", "apps"):
        if mode == "all":
            recent = [entries[i] for i in lib.recent_ids() if i in entries]
            if recent:
                lines.append(lib.header("Recently returned", "Recent"))
                lines += [lib.app_row(e) for e in recent]
        lines.append(lib.header("On the shelves", "Applications"))
        lines += [lib.app_row(e) for e in sorted(entries.values(), key=lambda e: e["name"].lower())]

    if mode in ("all", "windows"):
        wins = lib.windows()
        if wins:
            lines.append(lib.header("Checked out", "Windows"))
            lines += [lib.window_row(c, entries) for c in wins]
    # start on the first real row, not on a section header
    first = next((i for i, l in enumerate(lines) if "nonselectable" not in l), 0)
    options += [lib.option("keep-selection", "true"), lib.option("new-selection", str(first))]
    emit(options, lines)


def choose(info):
    kind, _, value = info.partition(":")
    if kind == "app":
        lib.remember(value)
        subprocess.Popen(["gtk-launch", value], stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                         stderr=subprocess.DEVNULL, start_new_session=True)
    elif kind == "win":
        subprocess.run(["hyprctl", "dispatch", 'hl.dsp.focus({ window = "address:%s" })' % value],
                       capture_output=True)
    elif kind == "copy":
        subprocess.run(["wl-copy", value])
        lib.notify("Copied", value)


def typed(text):
    """Enter on text that matched no row: a calculation, or a title we don't hold."""
    result = lib.calculate(text)
    if result is None:
        lib.notify("蔵書にありません", "We don't hold \u201c%s\u201d." % text)
        return
    # the "Marginalia" section header and the big result live in the message area,
    # so the only row is "Copy result" and it starts selected
    message = ("<span font_family='%s' size='11250' foreground='#d6c8aa'>Marginalia</span>  "
               "<span foreground='%s'>%s</span>  "
               "<span font_family='%s' size='8250' foreground='%s'>CALCULATOR</span>&#10;"
               "<span font_family='%s' size='34500' weight='bold' foreground='%s'>%s</span>"
               % (lib.SERIF, lib.RULE, "─" * 22, lib.MONO, lib.MUTED,
                  lib.SERIF, lib.CREAM, lib.escape(result)))
    emit([lib.option("markup-rows", "true"), lib.option("message", message)],
         [lib.row(lib.entry_text("Copy result", "%s  =  %s" % (text.strip(), result)),
                  icon=lib.index_card(), info="copy:" + result)])


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "all"
    retv = int(os.environ.get("ROFI_RETV", "0"))
    if retv == 0:
        listing(mode)
    elif retv == 1:
        info = os.environ.get("ROFI_INFO", "")
        if info:
            choose(info)
        else:                       # Enter on a section header: stay put
            listing(mode)
    elif retv == 2:
        typed(sys.argv[2] if len(sys.argv) > 2 else sys.argv[1])


if __name__ == "__main__":
    main()
