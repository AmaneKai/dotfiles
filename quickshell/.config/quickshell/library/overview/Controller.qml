pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property bool active: false

    function toggle() {
        active = !active;
    }

    function close() {
        active = false;
    }

    function goTo(workspaceId) {
        close();
        Hyprland.dispatch("hl.dispatch(hl.dsp.focus({ workspace = " + workspaceId + " }))");
    }

    IpcHandler {
        target: "overview"

        function toggle(): void { root.toggle(); }
        function close(): void { root.close(); }
    }

    function init() {}
}
