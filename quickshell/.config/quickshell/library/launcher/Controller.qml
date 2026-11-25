pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool isOpen: false
    property string pendingQuery: ""
    property int pendingDrawer: 0

    function open() {
        isOpen = true;
    }

    function close() {
        isOpen = false;
        pendingQuery = "";
        pendingDrawer = 0;
    }

    function toggle() {
        if (isOpen) close();
        else open();
    }

    function init() {}

    IpcHandler {
        target: "launcher"

        function toggle(): void { root.toggle(); }
        function open(): void { root.open(); }
        function close(): void { root.close(); }

        function search(text: string, drawer: int): void {
            root.pendingQuery = text;
            root.pendingDrawer = drawer;
            root.open();
        }
    }

    LazyLoader {
        active: root.isOpen
        Overlay {}
    }
}
