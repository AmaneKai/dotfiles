import QtQuick
import "../"

Item {
    id: root
    property string title: ""
    property string detail: ""
    property bool current: false
    signal activated()

    width: parent ? parent.width : 0
    height: 34

    Rectangle {
        anchors.fill: parent
        color: hover.hovered ? Theme.hairlineSoft : "transparent"
    }
    Rectangle {
        visible: root.current
        width: 2
        height: parent.height - 10
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.accent
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - detailText.width - 26
        text: root.title
        color: root.current ? Theme.text : Theme.heading
        font.family: Theme.bodySerif
        font.pixelSize: 13
        elide: Text.ElideRight
    }
    Text {
        id: detailText
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        text: root.detail
        color: Theme.muted
        font.family: Theme.mono
        font.pixelSize: 10
    }

    HoverHandler { id: hover }
    TapHandler { onTapped: root.activated() }
}
