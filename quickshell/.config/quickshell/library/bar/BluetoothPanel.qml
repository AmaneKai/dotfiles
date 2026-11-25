import QtQuick
import Quickshell.Bluetooth
import "../"

Column {
    id: root
    spacing: 4

    readonly property var adapter: Bluetooth.defaultAdapter

    function describe(device) {
        if (device.state === BluetoothDeviceState.Connecting) return "…";
        if (device.connected && device.batteryAvailable) return Math.round(device.battery * 100) + "%";
        if (device.connected) return "CONNECTED";
        return device.paired ? "PAIRED" : "";
    }

    function choose(device) {
        if (device.connected) return device.disconnect();
        if (device.paired) return device.connect();
        device.pair();
    }

    PanelHeading {
        kicker: "Bluetooth"
        title: root.adapter && root.adapter.enabled ? "Devices" : "Bluetooth"
        checked: root.adapter ? root.adapter.enabled : false
        switchable: root.adapter !== null
        onToggled: root.adapter.enabled = !root.adapter.enabled
    }

    Text {
        visible: !root.adapter || !root.adapter.enabled
        width: parent.width
        topPadding: 8
        bottomPadding: 8
        text: root.adapter ? "Bluetooth is switched off." : "No Bluetooth adapter found."
        color: Theme.muted
        font.family: Theme.bodySerif
        font.italic: true
        font.pixelSize: 12
    }

    Repeater {
        model: root.adapter && root.adapter.enabled ? root.adapter.devices : null

        PanelRow {
            required property var modelData
            visible: modelData.name !== ""
            height: visible ? 34 : 0
            title: modelData.name
            detail: root.describe(modelData)
            current: modelData.connected
            onActivated: root.choose(modelData)
        }
    }

    PanelRow {
        visible: root.adapter !== null && root.adapter.enabled
        title: root.adapter && root.adapter.discovering ? "Searching…" : "Search for devices"
        onActivated: root.adapter.discovering = !root.adapter.discovering
    }
}
