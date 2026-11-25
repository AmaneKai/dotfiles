import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../"
import "workspaces.js" as Book

Row {
    id: root
    required property var screen

    readonly property var monitor: Hyprland.monitorFor(screen)
    readonly property int activeId: monitor && monitor.activeWorkspace ? monitor.activeWorkspace.id : -1
    readonly property var occupied: Book.occupied(Hyprland.toplevels.values)

    spacing: 2

    Repeater {
        model: Book.ids()

        Item {
            id: tab
            required property int modelData
            readonly property bool active: modelData === root.activeId
            readonly property bool filled: root.occupied[modelData] === true

            width: 26
            height: root.height

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 4
                anchors.bottomMargin: 4
                color: tab.active ? Theme.surface : (hover.hovered ? Theme.hairlineSoft : "transparent")
                border.width: tab.active ? 1 : 0
                border.color: Theme.accent
            }

            Text {
                anchors.centerIn: parent
                text: Book.numeral(tab.modelData)
                color: tab.active ? Theme.text : (tab.filled ? Theme.heading : Theme.muted)
                opacity: tab.active || tab.filled ? 1 : 0.55
                font.family: Theme.serif
                font.pixelSize: 13
                font.weight: tab.active ? Font.Bold : Font.Normal
            }

            HoverHandler { id: hover }

            TapHandler {
                onTapped: Hyprland.dispatch("hl.dispatch(hl.dsp.focus({ workspace = " + tab.modelData + " }))")
            }
        }
    }
}
