import QtQuick
import "../"

Row {
    id: root
    property string keys: ""
    property string label: ""
    spacing: 6

    Rectangle {
        implicitWidth: cap.implicitWidth + 12
        implicitHeight: 18
        radius: 0
        color: Theme.hairlineSoft
        border.width: 1
        border.color: Theme.hairlineSoft
        Text {
            id: cap
            anchors.centerIn: parent
            text: root.keys
            color: Theme.text
            font.family: Theme.mono
            font.pixelSize: 10
        }
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.label
        color: Theme.muted
        font.family: Theme.sans
        font.pixelSize: 12
    }
}
