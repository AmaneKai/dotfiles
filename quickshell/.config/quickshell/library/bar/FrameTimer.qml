import QtQuick
import Quickshell.Services.Mpris
import "player.js" as Shelf

Item {
    readonly property var player: Shelf.pickPlayer(Mpris.players.values)
    readonly property real fraction: player ? Shelf.progress(player.position, player.length) : 0

    Timer {
        interval: 1000
        repeat: true
        running: player !== null && player.isPlaying
        onTriggered: player.positionChanged()
    }
}
