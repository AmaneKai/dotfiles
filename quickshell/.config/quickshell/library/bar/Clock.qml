import QtQuick
import Quickshell
import "../"

Row {
    id: root
    spacing: 10

    TapHandler { onTapped: Controller.toggle("calendar") }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Text {
        text: Qt.formatDate(clock.date, "ddd d MMM").toUpperCase()
        color: Theme.muted
        font.family: Theme.mono
        font.pixelSize: 10
        font.letterSpacing: 1.2
        anchors.verticalCenter: parent.verticalCenter
    }
    Text {
        text: Qt.formatTime(clock.date, "h:mm AP")
        color: Theme.text
        font.family: Theme.serif
        font.pixelSize: 14
        font.weight: Font.Bold
        anchors.verticalCenter: parent.verticalCenter
    }
}
