import QtQuick
import Quickshell

QtObject {
    id: root
    required property var recents

    function launchApp(row) {
        recents.remember(row.key);
        row.payload.execute();
    }

    function focusWindow(row) {
        const window = row.payload.wayland;
        if (window) window.activate();
    }

    function runCommand(row) {
        Quickshell.execDetached(["sh", "-c", row.payload]);
    }

    function copyResult(row) {
        Quickshell.execDetached(["wl-copy", row.payload]);
    }

    function perform(row) {
        const handlers = {
            app: launchApp,
            window: focusWindow,
            run: runCommand,
            calculation: copyResult
        };
        const handler = handlers[row.kind];
        if (handler) handler(row);
    }
}
