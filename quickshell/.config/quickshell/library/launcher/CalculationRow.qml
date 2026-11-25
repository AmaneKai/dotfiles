import QtQuick
import "../"
import "../components"

Item {
    id: root
    required property var row
    property bool selected: false
    signal activated()
    signal hovered()

    implicitHeight: 92

    Rectangle {
        anchors.fill: parent
        color: root.selected ? Theme.hairlineSoft : "transparent"
        border.width: root.selected ? 1 : 0
        border.color: Theme.accent
    }

    IndexCard {
        x: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Column {
        x: 84
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
            text: root.row.title
            color: Theme.text
            font.family: Theme.serif
            font.pixelSize: 46
            font.weight: Font.Bold
        }
        Text {
            text: root.row.subtitle
            color: Theme.muted
            font.family: Theme.mono
            font.pixelSize: 12
        }
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 44
        anchors.verticalCenter: parent.verticalCenter
        text: "Copy result"
        color: Theme.muted
        font.family: Theme.sans
        font.pixelSize: 13
    }

    Bookmark {
        visible: root.selected
        x: root.width - width - 14
        y: 0
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: root.hovered()
        onClicked: root.activated()
    }
}
