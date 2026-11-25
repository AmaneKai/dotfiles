import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../"
import "../components"

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: window
        required property var modelData
        screen: modelData

        readonly property bool onFocusedMonitor:
            Hyprland.focusedMonitor && Hyprland.focusedMonitor.name === modelData.name
        readonly property bool open: onFocusedMonitor && Controller.panel !== ""

        readonly property var sources: ({
            network: "NetworkPanel.qml",
            bluetooth: "BluetoothPanel.qml",
            sound: "SoundPanel.qml",
            player: "PlayerPanel.qml",
            power: "PowerPanel.qml",
            tray: "TrayMenuPanel.qml",
            notifications: "NotificationsPanel.qml",
            calendar: "CalendarPanel.qml",
            controls: "ControlsPanel.qml",
            clipboard: "ClipboardPanel.qml",
            wallpapers: "WallpaperPanel.qml"
        })

        readonly property var widths: ({
            wallpapers: 420
        })

        visible: open
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "qs-panel"
        WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        anchors { top: true; bottom: true; left: true; right: true }

        MouseArea {
            anchors.fill: parent
            onClicked: Controller.close()
        }

        Frame {
            id: sheet
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 36
            anchors.rightMargin: 12
            width: window.widths[Controller.panel] || 340
            height: loader.item ? loader.item.implicitHeight + 40 : 0

            MouseArea { anchors.fill: parent }

            Loader {
                id: loader
                anchors.fill: parent
                anchors.margins: 20
                source: window.sources[Controller.panel] || ""
            }
        }

        Shortcut {
            sequence: "Escape"
            enabled: window.open
            onActivated: Controller.close()
        }
    }
}
