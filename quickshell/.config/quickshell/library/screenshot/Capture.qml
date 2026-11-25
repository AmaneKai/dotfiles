import QtQuick
import Quickshell
import Quickshell.Io
import "geometry.js" as Geometry

Scope {
    id: root

    readonly property string folder: Quickshell.env("HOME") + "/Pictures/Screenshots"

    signal finished(bool ok)

    readonly property var scripts: ({ copy: copyScript, annotate: annotateScript })

    function region(rect, origin, mode) {
        if (!Geometry.isUsable(rect)) return finished(false);
        job.command = ["sh", "-c", scripts[mode] || copyScript, "capture", Geometry.grimGeometry(rect, origin), folder];
        job.running = true;
    }

    readonly property string copyScript: `
        set -eu
        mkdir -p "$2"
        file="$2/library-$(date +%Y%m%d-%H%M%S).png"
        grim -g "$1" "$file"
        wl-copy --type image/png < "$file"
        notify-send -a Screenshot -i "$file" "Page captured" "$file"
    `

    readonly property string annotateScript: `
        set -eu
        mkdir -p "$2"
        file="$2/library-$(date +%Y%m%d-%H%M%S).png"
        grim -g "$1" - | satty --filename - --output-filename "$file" --early-exit --copy-command wl-copy
    `

    Process {
        id: job
        onExited: code => root.finished(code === 0)
    }
}
