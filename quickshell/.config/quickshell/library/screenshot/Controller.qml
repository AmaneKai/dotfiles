pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property bool active: false
    property string mode: "copy"
    readonly property string monitorName: Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""

    function begin(requestedMode) {
        if (active || monitorName === "") return;
        mode = requestedMode;
        active = true;
    }

    function end() {
        active = false;
    }

    IpcHandler {
        target: "screenshot"

        function region(): void { root.begin("copy"); }
        function annotate(): void { root.begin("annotate"); }
        function cancel(): void { root.end(); }
    }

    function init() {}
}
