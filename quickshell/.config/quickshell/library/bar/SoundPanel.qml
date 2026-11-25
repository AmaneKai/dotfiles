import QtQuick
import Quickshell.Services.Pipewire
import "../"
import "names.js" as Names

Column {
    id: root
    spacing: 4

    readonly property var sink: Pipewire.defaultAudioSink

    PwObjectTracker { objects: root.sink ? [root.sink] : [] }

    PanelHeading {
        kicker: "Sound"
        title: root.sink ? Names.tidy(root.sink.description) : "No output"
        checked: root.sink && root.sink.audio ? !root.sink.audio.muted : false
        switchable: root.sink !== null && root.sink.audio !== null
        onToggled: root.sink.audio.muted = !root.sink.audio.muted
    }

    Repeater {
        model: Pipewire.nodes

        PanelRow {
            required property var modelData
            visible: modelData.isSink && !modelData.isStream
            height: visible ? 34 : 0
            title: Names.tidy(modelData.description)
            current: root.sink === modelData
            onActivated: Pipewire.preferredDefaultAudioSink = modelData
        }
    }
}
