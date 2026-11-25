import QtQuick
import "../"

Item {
    id: root
    property string title: ""
    property string label: ""

    implicitHeight: 34

    Row {
        anchors.verticalCenter: parent.verticalCenter
        x: 8
        width: parent.width - 16
        spacing: 10

        Text {
            id: titleText
            text: root.title
            color: Theme.heading
            font.family: Theme.serif
            font.pixelSize: 15
        }
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: root.width - 16 - titleText.width - labelText.width - 20
            height: 1
            color: Theme.rule
        }
        Text {
            id: labelText
            anchors.verticalCenter: parent.verticalCenter
            text: root.label.toUpperCase()
            color: Theme.muted
            font.family: Theme.mono
            font.pixelSize: 10
            font.letterSpacing: 1
        }
    }
}
