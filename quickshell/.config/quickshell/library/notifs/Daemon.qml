import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Notifications
import "../"

Scope {
    id: root

    NotificationServer {
        id: server
        keepOnReload: false
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true

        onNotification: n => {
            n.tracked = true;
            History.record(n);
        }
    }

    IpcHandler {
        target: "notifications"
        function clearHistory(): void { History.clear(); }

        function dismissAll(): void {
            for (const n of server.trackedNotifications.values.slice()) n.dismiss();
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            readonly property bool onFocusedMonitor:
                Hyprland.focusedMonitor && Hyprland.focusedMonitor.name === modelData.name

            visible: onFocusedMonitor && server.trackedNotifications.values.length > 0
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs-notifications"

            anchors { top: true; right: true }
            margins { top: 8; right: 12 }
            implicitWidth: 300
            implicitHeight: column.implicitHeight

            Column {
                id: column
                width: parent.width
                spacing: 6

                Repeater {
                    model: server.trackedNotifications.values.slice().reverse()

                    Card {
                        required property var modelData
                        notification: modelData
                        width: column.width
                    }
                }
            }
        }
    }
}
