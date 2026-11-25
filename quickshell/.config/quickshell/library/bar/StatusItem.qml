import QtQuick
import "../"

Item {
    id: root
    property string glyph: ""
    property string label: ""
    property string hint: ""
    property color tint: Theme.text
    signal activated()

    implicitWidth: row.implicitWidth + 14
    implicitHeight: parent ? parent.height : 28

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        color: hover.hovered ? Theme.hairlineSoft : "transparent"
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: root.glyph
            color: root.tint
            font.family: Theme.mono
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            visible: root.label !== ""
            text: root.label
            color: Theme.heading
            font.family: Theme.mono
            font.pixelSize: 11
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    HoverHandler { id: hover }
    Hint { target: root; text: root.hint }
    TapHandler { onTapped: root.activated() }
}
