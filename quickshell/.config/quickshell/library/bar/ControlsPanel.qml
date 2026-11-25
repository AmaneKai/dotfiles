import QtQuick
import Quickshell
import Quickshell.Io
import "../"
import "controls.js" as Dials

Column {
    id: root
    spacing: 4

    property real brightness: 0.5
    property bool nightLight: false

    function run(command) {
        Quickshell.execDetached(command);
    }

    function setBrightness(fraction) {
        brightness = fraction;
        run(Dials.brightnessCommand(fraction * 100));
    }

    function toggleNightLight() {
        nightLight = !nightLight;
        run(Dials.nightLightCommand(nightLight));
    }

    Process {
        command: ["brightnessctl", "-m"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const percent = Dials.parseBrightness(text);
                if (percent >= 0) root.brightness = percent / 100;
            }
        }
    }

    Process {
        command: ["pgrep", "-x", "hyprsunset"]
        running: true
        onExited: code => root.nightLight = code === 0
    }

    PanelHeading {
        kicker: "Reading lamp"
        title: "Controls"
        switchable: false
    }

    Text {
        topPadding: 6
        text: "BRIGHTNESS  " + Math.round(root.brightness * 100) + "%"
        color: Theme.muted
        font.family: Theme.mono
        font.pixelSize: 10
        font.letterSpacing: 1.2
    }
    Slider { value: root.brightness; onMoved: fraction => root.setBrightness(fraction) }

    PanelRow {
        title: "Night light"
        detail: root.nightLight ? "ON" : "OFF"
        current: root.nightLight
        onActivated: root.toggleNightLight()
    }
    PanelRow {
        title: "Pick a colour"
        detail: "COPIES HEX"
        onActivated: { Controller.close(); root.run(["sh", "-c", "sleep 0.2 && hyprpicker -a"]); }
    }
    PanelRow {
        title: "Next wallpaper"
        onActivated: root.run([Quickshell.env("HOME") + "/.config/hypr/scripts/wallpaper.sh", "next"])
    }
    PanelRow {
        title: "Choose a wallpaper"
        onActivated: Controller.toggle("wallpapers")
    }
    PanelRow {
        title: "Annotate a screenshot"
        onActivated: { Controller.close(); root.run(["qs", "-c", "library", "ipc", "call", "screenshot", "annotate"]); }
    }
}
