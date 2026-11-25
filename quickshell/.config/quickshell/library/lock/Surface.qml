import QtQuick
import QtQuick.Effects
import Quickshell
import "../"
import "../components"
import "mask.js" as Mask

Item {
    id: root
    required property var context

    readonly property string wallpaper: "file://" + Quickshell.env("HOME") + "/Pictures/Wallpapers/library-closeup.png"

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Image {
        id: backdrop
        anchors.fill: parent
        source: root.wallpaper
        fillMode: Image.PreserveAspectCrop
        visible: false
    }
    MultiEffect {
        anchors.fill: parent
        source: backdrop
        blurEnabled: true
        blur: 1
        blurMax: 48
        brightness: -0.25
    }
    Rectangle { anchors.fill: parent; color: "#66070f1c" }

    Frame {
        anchors.centerIn: parent
        width: 420
        height: 300

        Bookmark { x: parent.width - width - 22; y: 0; z: 2 }

        Column {
            anchors.centerIn: parent
            width: parent.width - 64
            spacing: 14

            Text {
                width: parent.width
                text: "LIBRARY CARD  ·  BORROWER"
                color: Theme.muted
                font.family: Theme.mono
                font.pixelSize: 10
                font.letterSpacing: 1.6
            }
            Text {
                text: Qt.formatTime(clock.date, "h:mm")
                color: Theme.text
                font.family: Theme.serif
                font.pixelSize: 64
                font.weight: Font.Bold
            }
            Text {
                text: Qt.formatDate(clock.date, "dddd, d MMMM").toUpperCase()
                color: Theme.heading
                font.family: Theme.mono
                font.pixelSize: 11
                font.letterSpacing: 1.4
            }

            Rectangle { width: parent.width; height: 1; color: Theme.rule }

            Item {
                width: parent.width
                height: 30

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.context.checking ? "Checking the register…"
                        : root.context.failed ? "That is not the passphrase."
                        : root.context.typed === "" ? "Speak the passphrase" : ""
                    color: root.context.failed ? Theme.accent2 : Theme.muted
                    font.family: Theme.bodySerif
                    font.italic: true
                    font.pixelSize: 14
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Mask.marks(root.context.typed.length)
                    color: Theme.accent
                    font.family: Theme.mono
                    font.pixelSize: 26
                    font.letterSpacing: 4
                }
            }
        }
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) return root.context.submit();
            if (event.key === Qt.Key_Backspace) return root.context.erase();
            if (event.key === Qt.Key_Escape) return root.context.clear();
            if (event.text.length > 0 && event.text.charCodeAt(0) >= 32) root.context.type(event.text);
        }
    }
}
