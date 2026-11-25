import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../"
import "../components"

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        readonly property bool onFocusedMonitor:
            Hyprland.focusedMonitor && Hyprland.focusedMonitor.name === modelData.name

        function glyph() {
            if (Controller.kind === "brightness") return String.fromCodePoint(0xF00E0);
            if (Controller.muted || Controller.level === 0) return String.fromCodePoint(0xF075F);
            if (Controller.level < 34) return String.fromCodePoint(0xF057F);
            if (Controller.level < 67) return String.fromCodePoint(0xF0580);
            return String.fromCodePoint(0xF057E);
        }

        visible: onFocusedMonitor && panel.opacity > 0.01
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "qs-osd"

        anchors { bottom: true }
        margins { bottom: 72 }
        implicitWidth: 230
        implicitHeight: 44
        mask: Region {}

        Frame {
            id: panel
            ornamented: false
            anchors.fill: parent
            opacity: Controller.shown ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 160 } }

            Text {
                id: icon
                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                text: glyph()
                color: Theme.text
                font.family: Theme.mono
                font.pixelSize: 16
            }

            Text {
                id: page
                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                width: 28
                horizontalAlignment: Text.AlignRight
                text: Controller.muted ? "off" : Controller.level
                color: Theme.text
                font.family: Theme.serif
                font.pixelSize: 15
                font.weight: Font.Bold
            }

            Item {
                id: track
                anchors.left: icon.right
                anchors.leftMargin: 12
                anchors.right: page.left
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                height: 14

                readonly property real fraction: Controller.muted ? 0 : Controller.level / 100

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 1
                    color: Theme.rule
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * track.fraction
                    height: 2
                    color: Theme.text
                    Behavior on width { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
                }
                Rectangle {
                    x: Math.max(0, Math.min(parent.width - width, parent.width * track.fraction - width / 2))
                    anchors.verticalCenter: parent.verticalCenter
                    width: 5
                    height: 14
                    color: Theme.accent
                    Behavior on x { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
                }
            }
        }
    }
}
