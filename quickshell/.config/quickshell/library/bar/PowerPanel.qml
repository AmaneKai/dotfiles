import QtQuick
import Quickshell
import "../"
import "power.js" as Power

Column {
    id: root
    spacing: 4

    property string armed: ""

    function choose(action) {
        if (Power.needsConfirmation(action, armed)) {
            armed = action.id;
            return;
        }
        Controller.close();
        Quickshell.execDetached(action.command);
    }

    PanelHeading {
        kicker: "Session"
        title: "Farewell"
        switchable: false
    }

    Repeater {
        model: Power.actions()

        PanelRow {
            required property var modelData
            title: root.armed === modelData.id ? "Press again to confirm" : modelData.title
            detail: modelData.detail
            current: root.armed === modelData.id
            onActivated: root.choose(modelData)
        }
    }
}
