import QtQuick
import "../"
import "../notifs"

Column {
    id: root
    spacing: 4

    readonly property int visibleLimit: 8

    PanelHeading {
        kicker: "Margin notes"
        title: History.entries.length === 0 ? "All quiet" : History.entries.length + " kept"
        switchable: false
    }

    Repeater {
        model: History.entries.slice(0, root.visibleLimit)

        PanelRow {
            required property var modelData
            required property int index
            title: modelData.summary !== "" ? modelData.summary : modelData.body
            detail: modelData.app.toUpperCase() + "  " + History.ago(modelData.time)
            onActivated: History.remove(index)
        }
    }

    PanelRow {
        visible: History.entries.length > 0
        title: "Clear all"
        onActivated: History.clear()
    }
}
