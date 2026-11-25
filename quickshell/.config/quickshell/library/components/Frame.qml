import QtQuick
import "../"

Rectangle {
    id: frame
    default property alias content: inner.data
    property color edge: Theme.hairline
    property bool ornamented: true

    color: Theme.panel
    radius: 0
    border.width: 1
    border.color: edge

    Rectangle {
        anchors.fill: parent
        anchors.margins: 3
        color: "transparent"
        radius: 0
        border.width: 1
        border.color: Theme.hairlineSoft
    }

    Image {
        anchors.fill: parent
        anchors.margins: 1
        source: "../assets/paper-grain.png"
        fillMode: Image.Tile
        smooth: false
    }

    Repeater {
        model: frame.ornamented ? [0, 90, 180, 270] : []

        Image {
            required property int modelData
            source: "../assets/inked-corner.png"
            x: modelData === 90 || modelData === 180 ? frame.width - width - 4 : 4
            y: modelData === 180 || modelData === 270 ? frame.height - height - 4 : 4
            rotation: modelData
            smooth: false
        }
    }

    Item { id: inner; anchors.fill: parent }
}
