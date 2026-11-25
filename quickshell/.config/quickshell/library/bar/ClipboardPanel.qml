import QtQuick
import Quickshell
import Quickshell.Io
import "../"
import "clipboard.js" as Shelf

Column {
    id: root
    spacing: 4

    property var entries: []
    readonly property var shown: Shelf.filter(entries, search.text).slice(0, 8)

    function pick(entry) {
        Controller.close();
        Quickshell.execDetached(["sh", "-c", 'cliphist decode "$1" | wl-copy', "pick", entry.id]);
    }

    Process {
        command: ["cliphist", "list"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.entries = Shelf.parseEntries(text) }
    }

    PanelHeading {
        kicker: "Commonplace book"
        title: "Clipboard"
        switchable: false
    }

    Rectangle {
        width: parent.width
        height: 30
        color: "transparent"
        border.width: 1
        border.color: Theme.hairline

        TextInput {
            id: search
            anchors.fill: parent
            anchors.margins: 7
            color: Theme.text
            font.family: Theme.mono
            font.pixelSize: 12
            verticalAlignment: TextInput.AlignVCenter
            focus: true
            Keys.onReturnPressed: if (root.shown.length > 0) root.pick(root.shown[0])
            Text {
                visible: search.text === ""
                anchors.verticalCenter: parent.verticalCenter
                text: "Search the notes"
                color: Theme.muted
                font: search.font
            }
        }
    }

    Repeater {
        model: root.shown
        PanelRow {
            required property var modelData
            title: Shelf.label(modelData)
            detail: modelData.isImage ? "IMG" : ""
            onActivated: root.pick(modelData)
        }
    }

    Text {
        visible: root.shown.length === 0
        text: "Nothing copied yet."
        color: Theme.muted
        font.family: Theme.bodySerif
        font.italic: true
        font.pixelSize: 12
        topPadding: 6
    }
}
