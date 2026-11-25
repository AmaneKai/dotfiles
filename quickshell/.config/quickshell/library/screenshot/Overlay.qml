import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../"
import "geometry.js" as Geometry

Scope {
    id: root

    Capture {
        id: capture
        onFinished: Controller.end()
    }

    LazyLoader {
        active: Controller.active

        PanelWindow {
            id: window
            screen: Quickshell.screens.find(s => s.name === Controller.monitorName) || Quickshell.screens[0]

            property var anchorPoint: null
            property var pointer: ({ x: 0, y: 0 })
            readonly property var selection: anchorPoint
                ? Geometry.clamp(Geometry.normalise(anchorPoint, pointer), { width: width, height: height })
                : null

            function commit() {
                if (!Geometry.isUsable(selection)) return Controller.end();
                hideTimer.start();
            }

            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs-screenshot"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            anchors { top: true; bottom: true; left: true; right: true }

            Timer {
                id: hideTimer
                interval: 180
                onTriggered: capture.region(window.selection, { x: window.screen.x, y: window.screen.y }, Controller.mode)
            }

            Item {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: Controller.end()

                Rectangle {
                    anchors.fill: parent
                    color: "#8c000000"
                    visible: !window.selection
                }

                Repeater {
                    model: window.selection ? 4 : 0

                    Rectangle {
                        required property int index
                        color: "#8c000000"
                        x: [0, 0, window.selection.x + window.selection.width, 0][index]
                        y: [0, window.selection.y + window.selection.height, window.selection.y, window.selection.y][index]
                        width: [window.width, window.width, window.width - (window.selection.x + window.selection.width), window.selection.x][index]
                        height: [window.selection.y, window.height - (window.selection.y + window.selection.height), window.selection.height, window.selection.height][index]
                    }
                }

                Rectangle {
                    visible: window.selection !== null
                    x: window.selection ? window.selection.x : 0
                    y: window.selection ? window.selection.y : 0
                    width: window.selection ? window.selection.width : 0
                    height: window.selection ? window.selection.height : 0
                    color: "transparent"
                    border.width: 1
                    border.color: Theme.accent
                }

                Rectangle {
                    visible: window.selection !== null && Geometry.isUsable(window.selection)
                    x: window.selection ? window.selection.x : 0
                    y: window.selection ? Math.max(0, window.selection.y - 24) : 0
                    width: tag.implicitWidth + 14
                    height: 20
                    color: Theme.bar
                    border.width: 1
                    border.color: Theme.hairline
                    Text {
                        id: tag
                        anchors.centerIn: parent
                        text: window.selection ? Geometry.label(window.selection) : ""
                        color: Theme.text
                        font.family: Theme.mono
                        font.pixelSize: 11
                    }
                }

                Rectangle {
                    visible: !window.anchorPoint
                    anchors.centerIn: parent
                    width: hint.implicitWidth + 40
                    height: hint.implicitHeight + 22
                    color: Theme.panel
                    border.width: 1
                    border.color: Theme.hairline
                    Text {
                        id: hint
                        anchors.centerIn: parent
                        text: "Drag to mark a passage  ·  Esc to cancel"
                        color: Theme.text
                        font.family: Theme.serif
                        font.pixelSize: 18
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.CrossCursor
                    onPressed: mouse => { window.anchorPoint = { x: mouse.x, y: mouse.y }; window.pointer = { x: mouse.x, y: mouse.y }; }
                    onPositionChanged: mouse => { if (pressed) window.pointer = { x: mouse.x, y: mouse.y }; }
                    onReleased: window.commit()
                }
            }
        }
    }
}
