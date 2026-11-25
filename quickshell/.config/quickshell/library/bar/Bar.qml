import QtQuick
import Quickshell
import Quickshell.Wayland
import "../"
import "../notifs"

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: window
        required property var modelData
        screen: modelData

        anchors { top: true; left: true; right: true }
        implicitHeight: 30
        color: Theme.bar
        WlrLayershell.namespace: "qs-bar"

        Image {
            anchors.fill: parent
            source: "../assets/paper-grain.png"
            fillMode: Image.Tile
            smooth: false
        }

        Image {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -3
            width: parent.width
            height: 8
            source: "../assets/inked-rule.png"
            fillMode: Image.TileHorizontally
            smooth: false
        }

        Workspaces {
            anchors.left: parent.left
            anchors.leftMargin: 10
            height: parent.height - 1
            screen: window.screen
        }

        NowPlaying {
            anchors.left: parent.left
            anchors.leftMargin: 320
            height: parent.height - 1
        }

        Clock {
            anchors.centerIn: parent
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 10
            height: parent.height - 1
            spacing: 8

            Tray { anchors.verticalCenter: parent.verticalCenter }
            StatusItem {
                height: parent.height
                glyph: String.fromCodePoint(0xF0493)
                hint: "Controls"
                onActivated: Controller.toggle("controls")
            }
            StatusItem {
                height: parent.height
                glyph: String.fromCodePoint(0xF009C)
                label: History.entries.length > 0 ? History.entries.length : ""
                hint: "Notifications"
                onActivated: Controller.toggle("notifications")
            }
            Status { height: parent.height }
            StatusItem {
                height: parent.height
                glyph: String.fromCodePoint(0xF0425)
                hint: "Session"
                onActivated: Controller.toggle("power")
            }
        }
    }
}
