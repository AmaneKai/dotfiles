import QtQuick
import "../"
import "../components"

Item {
    id: root
    implicitHeight: 30

    Rectangle { width: parent.width; height: 1; color: Theme.hairlineSoft }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        x: 6
        spacing: 18

        Keycap { keys: "↵"; label: "Open" }
        Keycap { keys: "⇥"; label: "Next drawer" }
        Keycap { keys: "↑ ↓"; label: "Move" }
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        text: "Super + Space"
        color: Theme.muted
        font.family: Theme.mono
        font.pixelSize: 10
    }
}
