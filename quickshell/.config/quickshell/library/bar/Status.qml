import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Networking
import Quickshell.Bluetooth
import "../"
import "status.js" as Gauge

Row {
    id: root
    spacing: 2

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery && battery.isPresent && battery.isLaptopBattery
    readonly property int volume: sink && sink.audio ? Gauge.percent(sink.audio.volume) : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property int charge: hasBattery ? Gauge.percent(battery.percentage) : 0
    readonly property bool charging: hasBattery && battery.state === UPowerDeviceState.Charging
    readonly property bool bluetoothOn: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
    readonly property bool bluetoothLinked: Bluetooth.devices.values.some(device => device.connected)
    readonly property bool wifiLinked: Networking.devices.values.some(device => device.type === DeviceType.Wifi && device.connected)

    PwObjectTracker { objects: root.sink ? [root.sink] : [] }

    StatusItem {
        glyph: Gauge.volumeGlyph(root.volume, root.muted)
        label: root.muted ? "" : root.volume + "%"
        tint: root.muted ? Theme.muted : Theme.text
        hint: root.muted ? "Sound: muted" : "Sound: " + root.volume + "%"
        onActivated: Controller.toggle("sound")
    }

    StatusItem {
        glyph: !Networking.wifiEnabled ? String.fromCodePoint(0xF05AA)
            : root.wifiLinked ? String.fromCodePoint(0xF05A9) : String.fromCodePoint(0xF092E)
        tint: root.wifiLinked ? Theme.text : Theme.muted
        hint: root.wifiLinked ? "Wi-Fi: connected" : (Networking.wifiEnabled ? "Wi-Fi: not connected" : "Wi-Fi: off")
        onActivated: Controller.toggle("network")
    }

    StatusItem {
        glyph: !root.bluetoothOn ? String.fromCodePoint(0xF00B2)
            : root.bluetoothLinked ? String.fromCodePoint(0xF00B1) : String.fromCodePoint(0xF00AF)
        tint: root.bluetoothLinked ? Theme.text : Theme.muted
        hint: !root.bluetoothOn ? "Bluetooth: off" : (root.bluetoothLinked ? "Bluetooth: connected" : "Bluetooth: on")
        onActivated: Controller.toggle("bluetooth")
    }

    StatusItem {
        visible: root.hasBattery
        glyph: Gauge.batteryGlyph(root.charge, root.charging)
        label: root.charge + "%"
        hint: root.charging ? "Battery: charging" : "Battery: on battery"
        tint: Gauge.isLow(root.charge, root.charging) ? Theme.accent2 : (root.charging ? Theme.green : Theme.text)
    }
}
