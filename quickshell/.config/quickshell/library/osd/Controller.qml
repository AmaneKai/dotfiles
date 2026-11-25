pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string kind: "volume"
    property int level: 0
    property bool muted: false
    property bool shown: false

    IpcHandler {
        target: "osd"

        function set(kind: string, percent: int, muted: bool): void {
            root.kind = kind;
            root.level = Math.max(0, Math.min(100, percent));
            root.muted = muted;
            root.shown = true;
            hideTimer.restart();
        }
    }

    Timer { id: hideTimer; interval: 1300; onTriggered: root.shown = false }

    function init() {}
}
