import QtQuick
import Quickshell.Networking
import "../"

Column {
    id: root
    spacing: 4

    readonly property var wifiDevice: {
        for (const device of Networking.devices.values)
            if (device.type === DeviceType.Wifi) return device;
        return null;
    }
    property var pending: null

    function describe(network) {
        if (network.connected) return "CONNECTED";
        if (network.stateChanging) return "…";
        return Math.round(network.signalStrength * 100) + "%";
    }

    function choose(network) {
        if (network.connected) return network.disconnect();
        const needsPassword = !network.known && network.security !== WifiSecurityType.Open;
        if (needsPassword) {
            pending = network;
            return;
        }
        network.connect();
    }

    PanelHeading {
        kicker: "Wireless"
        title: root.wifiDevice && root.wifiDevice.connected ? "Connected" : "Wi-Fi"
        checked: Networking.wifiEnabled
        onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
    }

    Text {
        visible: !Networking.wifiEnabled || !root.wifiDevice
        width: parent.width
        topPadding: 8
        bottomPadding: 8
        text: Networking.wifiEnabled ? "No wireless adapter found." : "Wi-Fi is switched off."
        color: Theme.muted
        font.family: Theme.bodySerif
        font.italic: true
        font.pixelSize: 12
    }

    Repeater {
        model: root.wifiDevice && Networking.wifiEnabled ? root.wifiDevice.networks : null

        PanelRow {
            required property var modelData
            title: modelData.name
            detail: root.describe(modelData)
            current: modelData.connected
            onActivated: root.choose(modelData)
        }
    }

    Rectangle {
        visible: root.pending !== null
        width: parent.width
        height: 34
        color: "transparent"
        border.width: 1
        border.color: Theme.accent

        TextInput {
            id: password
            anchors.fill: parent
            anchors.margins: 8
            echoMode: TextInput.Password
            color: Theme.text
            font.family: Theme.mono
            font.pixelSize: 12
            verticalAlignment: TextInput.AlignVCenter
            focus: root.pending !== null
            onAccepted: {
                root.pending.connectWithPsk(text);
                text = "";
                root.pending = null;
            }

            Text {
                visible: password.text === ""
                anchors.verticalCenter: parent.verticalCenter
                text: root.pending ? "Password for " + root.pending.name : ""
                color: Theme.muted
                font: password.font
            }
        }
    }
}
