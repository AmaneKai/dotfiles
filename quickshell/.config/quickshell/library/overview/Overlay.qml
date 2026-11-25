import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../"
import "../components"
import "overview.js" as Shelf

Scope {
    LazyLoader {
        active: Controller.active

        PanelWindow {
            id: window
            screen: Quickshell.screens.find(s => Hyprland.focusedMonitor && s.name === Hyprland.focusedMonitor.name) || Quickshell.screens[0]

            readonly property var grouped: Shelf.groups(Hyprland.toplevels.values)
            readonly property var monitor: Hyprland.monitorFor(screen)
            readonly property int activeId: monitor && monitor.activeWorkspace ? monitor.activeWorkspace.id : -1

            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs-overview"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            anchors { top: true; bottom: true; left: true; right: true }

            Rectangle {
                anchors.fill: parent
                color: "#cc070f1c"
                focus: true

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) return Controller.close();
                    const digit = event.key - Qt.Key_0;
                    if (digit >= 0 && digit <= 9) Controller.goTo(digit === 0 ? 10 : digit);
                }

                MouseArea { anchors.fill: parent; onClicked: Controller.close() }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 56
                    text: "TABLE OF CONTENTS"
                    color: Theme.muted
                    font.family: Theme.mono
                    font.pixelSize: 12
                    font.letterSpacing: 3
                }

                Grid {
                    anchors.centerIn: parent
                    columns: 5
                    spacing: 18

                    Repeater {
                        model: Shelf.ids()

                        Frame {
                            id: card
                            required property int modelData
                            readonly property var windows: window.grouped[modelData]
                            readonly property bool current: modelData === window.activeId

                            width: Math.min(260, (window.width - 200) / 5)
                            height: 170
                            edge: current ? Theme.accent : Theme.hairline

                            Column {
                                anchors.fill: parent
                                anchors.margins: 22
                                spacing: 6

                                Text {
                                    text: card.modelData
                                    color: card.current ? Theme.accent : Theme.text
                                    font.family: Theme.serif
                                    font.pixelSize: 30
                                    font.weight: Font.Bold
                                }
                                Text {
                                    text: Shelf.summary(card.windows).toUpperCase()
                                    color: Theme.muted
                                    font.family: Theme.mono
                                    font.pixelSize: 9
                                    font.letterSpacing: 1.4
                                }
                                Repeater {
                                    model: card.windows.slice(0, 3)
                                    Text {
                                        required property var modelData
                                        width: parent.width
                                        text: modelData.title
                                        color: Theme.heading
                                        font.family: Theme.bodySerif
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            TapHandler { onTapped: Controller.goTo(card.modelData) }
                        }
                    }
                }
            }
        }
    }
}
