import QtQuick
import Quickshell
import "../"

PopupWindow {
    id: root
    required property Item target
    property string text: ""
    property bool wanted: false

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: 4
    implicitWidth: label.implicitWidth + 20
    implicitHeight: label.implicitHeight + 12
    color: "transparent"
    visible: wanted && text !== ""

    Rectangle {
        anchors.fill: parent
        color: Theme.bar
        border.width: 1
        border.color: Theme.hairline

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            color: Theme.heading
            font.family: Theme.bodySerif
            font.pixelSize: 12
        }
    }
}
