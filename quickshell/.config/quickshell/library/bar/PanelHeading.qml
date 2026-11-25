import QtQuick
import "../"

Item {
    id: root
    property string kicker: ""
    property string title: ""
    property bool checked: false
    property bool switchable: true
    signal toggled()

    implicitHeight: Math.max(40, column.implicitHeight + 12)
    width: parent ? parent.width : 0

    readonly property real reserved: switchable ? 56 : 0

    Column {
        id: column
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - root.reserved
        spacing: 1

        Text {
            width: parent.width
            elide: Text.ElideRight
            text: root.kicker.toUpperCase()
            color: Theme.muted
            font.family: Theme.mono
            font.pixelSize: 9
            font.letterSpacing: 1.4
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            text: root.title
            color: Theme.text
            font.family: Theme.serif
            font.pixelSize: 17
            font.weight: Font.Bold
        }
    }

    Rectangle {
        visible: root.switchable
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        height: 20
        color: root.checked ? Theme.accent : "transparent"
        border.width: 1
        border.color: root.checked ? Theme.accent : Theme.hairline

        Text {
            anchors.centerIn: parent
            text: root.checked ? "ON" : "OFF"
            color: root.checked ? Theme.bar : Theme.muted
            font.family: Theme.mono
            font.pixelSize: 10
            font.weight: Font.Bold
        }
        TapHandler { onTapped: root.toggled() }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Theme.rule
    }
}
