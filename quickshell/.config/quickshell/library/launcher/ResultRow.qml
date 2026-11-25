import QtQuick
import "../"
import "../components"
import "ranking.js" as Ranking

Item {
    id: root
    required property var row
    property bool selected: false
    property string query: ""
    signal activated()
    signal hovered()

    implicitHeight: 56

    Rectangle {
        anchors.fill: parent
        color: root.selected ? Theme.hairlineSoft : "transparent"
        border.width: root.selected ? 1 : 0
        border.color: Theme.accent
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Theme.hairlineSoft
        visible: !root.selected
    }

    Spine {
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        name: root.row.title
    }

    Column {
        x: 50
        width: parent.width - 50 - 44
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
            width: parent.width
            textFormat: Text.StyledText
            text: Ranking.highlight(root.row.title, root.query, Theme.accent)
            color: Theme.text
            font.family: Theme.sans
            font.pixelSize: 16
            elide: Text.ElideRight
            maximumLineCount: 1
        }
        Text {
            width: parent.width
            text: root.row.subtitle
            color: Theme.muted
            font.family: Theme.sans
            font.pixelSize: 13
            elide: Text.ElideRight
            maximumLineCount: 1
        }
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
