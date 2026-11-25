import QtQuick
import Quickshell.Services.Mpris
import Quickshell.Widgets
import "../"
import "player.js" as Shelf

Column {
    id: root
    spacing: 8

    readonly property var player: Shelf.pickPlayer(Mpris.players.values)

    FrameTimer { id: ticker }

    PanelHeading {
        kicker: root.player ? root.player.identity : "Player"
        title: root.player && root.player.trackTitle ? root.player.trackTitle : "Nothing playing"
        switchable: false
    }

    Text {
        visible: text !== ""
        width: parent.width
        text: root.player ? root.player.trackArtist : ""
        color: Theme.muted
        font.family: Theme.bodySerif
        font.italic: true
        font.pixelSize: 13
        elide: Text.ElideRight
    }

    Item {
        visible: root.player !== null && root.player.lengthSupported
        width: parent.width
        height: 14

        Rectangle { anchors.verticalCenter: parent.verticalCenter; width: parent.width; height: 1; color: Theme.rule }
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * ticker.fraction
            height: 2
            color: Theme.text
        }
        Rectangle {
            x: Math.max(0, Math.min(parent.width - width, parent.width * ticker.fraction - width / 2))
            anchors.verticalCenter: parent.verticalCenter
            width: 5
            height: 14
            color: Theme.accent
        }
    }

    Row {
        visible: root.player !== null && root.player.positionSupported && root.player.lengthSupported
        width: parent.width
        Text { text: Shelf.clock(root.player ? root.player.position : 0); color: Theme.muted; font.family: Theme.mono; font.pixelSize: 10 }
        Item { width: parent.width - 80; height: 1 }
        Text { text: Shelf.clock(root.player ? root.player.length : 0); color: Theme.muted; font.family: Theme.mono; font.pixelSize: 10 }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 22

        Repeater {
            model: [
                { glyph: 0xF04AE, enabled: root.player && root.player.canGoPrevious, run: () => root.player.previous() },
                { glyph: root.player && root.player.isPlaying ? 0xF03E4 : 0xF040A, enabled: root.player && root.player.canTogglePlaying, run: () => root.player.togglePlaying() },
                { glyph: 0xF04AD, enabled: root.player && root.player.canGoNext, run: () => root.player.next() }
            ]

            Text {
                required property var modelData
                text: String.fromCodePoint(modelData.glyph)
                color: modelData.enabled ? Theme.text : Theme.muted
                opacity: modelData.enabled ? 1 : 0.4
                font.family: Theme.mono
                font.pixelSize: 22
                TapHandler { enabled: modelData.enabled; onTapped: modelData.run() }
            }
        }
    }
}
