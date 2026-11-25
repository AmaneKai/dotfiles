import QtQuick
import Quickshell.Services.Mpris
import "../"
import "player.js" as Shelf

Item {
    id: root
    readonly property var player: Shelf.pickPlayer(Mpris.players.values)
    readonly property string headline: Shelf.headline(player)

    visible: headline !== ""
    implicitWidth: visible ? Math.min(row.implicitWidth + 14, 320) : 0
    implicitHeight: parent ? parent.height : 28

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        color: hover.hovered ? Theme.hairlineSoft : "transparent"
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 7
        spacing: 6

        Text {
            text: root.player && root.player.isPlaying ? String.fromCodePoint(0xF040A) : String.fromCodePoint(0xF03E4)
            color: Theme.accent
            font.family: Theme.mono
            font.pixelSize: 13
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            width: Math.min(implicitWidth, 280)
            text: root.headline
            color: Theme.heading
            font.family: Theme.bodySerif
            font.pixelSize: 12
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    HoverHandler { id: hover }
    TapHandler { onTapped: Controller.toggle("player") }
}
