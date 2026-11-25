import QtQuick
import "../"
import "ranking.js" as Ranking

Item {
    id: root
    property string name: ""

    readonly property color fill: Ranking.spineColour(name)
    readonly property int tileHeight: Ranking.spineHeight(name)
    readonly property color band: Qt.rgba(0.04, 0.09, 0.15, 0.45)
    readonly property int bandHeight: 2
    readonly property int bandInset: 4

    implicitWidth: 24
    implicitHeight: 38

    Rectangle {
        width: root.width
        height: root.tileHeight
        anchors.bottom: parent.bottom
        color: root.fill

        Rectangle { y: root.bandInset; width: parent.width; height: root.bandHeight; color: root.band }
        Rectangle { y: parent.height - root.bandInset - root.bandHeight; width: parent.width; height: root.bandHeight; color: root.band }

        Text {
            anchors.centerIn: parent
            text: Ranking.initial(root.name)
            color: Ranking.spineInk(root.fill)
            font.family: Theme.serif
            font.pixelSize: 14
            font.weight: Font.Bold
        }
    }
}
