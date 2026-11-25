import QtQuick
import Quickshell
import "../"

Column {
    id: root
    spacing: 2

    property var trail: []
    readonly property var item: Controller.trayItem
    readonly property var current: trail.length > 0 ? trail[trail.length - 1] : (item ? item.menu : null)

    function enter(entry) {
        trail = trail.concat([entry]);
    }

    function back() {
        trail = trail.slice(0, -1);
    }

    function choose(entry) {
        if (!entry.enabled) return;
        if (entry.hasChildren) return enter(entry);
        entry.triggered();
        Controller.close();
    }

    function label(entry) {
        return String(entry.text || "").replace(/&(.)/g, "$1");
    }

    QsMenuOpener {
        id: opener
        menu: root.current
    }

    PanelHeading {
        kicker: "Tray"
        title: root.item ? (root.item.tooltipTitle || root.item.title || root.item.id) : ""
        switchable: false
    }

    PanelRow {
        visible: root.trail.length > 0
        title: "Back"
        detail: "‹"
        onActivated: root.back()
    }

    Repeater {
        model: opener.children

        Item {
            id: entry
            required property var modelData
            width: root.width
            height: modelData.isSeparator ? 9 : 34

            Rectangle {
                visible: entry.modelData.isSeparator
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 1
                color: Theme.rule
            }

            PanelRow {
                visible: !entry.modelData.isSeparator
                width: parent.width
                opacity: entry.modelData.enabled ? 1 : 0.4
                title: root.label(entry.modelData)
                detail: entry.modelData.hasChildren ? "›" : (entry.modelData.checkState === Qt.Checked ? "✓" : "")
                onActivated: root.choose(entry.modelData)
            }
        }
    }
}
