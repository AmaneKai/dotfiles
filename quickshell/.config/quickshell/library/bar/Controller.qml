pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

Singleton {
    id: root

    property string panel: ""
    property var trayItem: null

    function toggle(name) {
        if (!name) return;
        panel = panel === name ? "" : name;
    }

    function close() {
        panel = "";
        trayItem = null;
    }

    function openTray(item) {
        if (!item) return;
        trayItem = item;
        panel = "tray";
    }

    IpcHandler {
        target: "bar"

        function toggle(name: string): void { root.toggle(name); }
        function close(): void { root.close(); }
        function tray(index: int): void { root.openTray(SystemTray.items.values[index]); }
    }

    function init() {}
}
