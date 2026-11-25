.pragma library

function parseBrightness(output) {
    const fields = String(output || "").trim().split(",");
    if (fields.length < 5) return -1;
    const percent = parseInt(fields[3], 10);
    return isNaN(percent) ? -1 : Math.max(0, Math.min(100, percent));
}

function brightnessCommand(percent) {
    const clamped = Math.max(1, Math.min(100, Math.round(percent)));
    return ["brightnessctl", "set", clamped + "%"];
}

const NIGHT_TEMPERATURE = 3800;

function nightLightCommand(enabled) {
    if (enabled) return ["sh", "-c", "pgrep -x hyprsunset >/dev/null || exec hyprsunset -t " + NIGHT_TEMPERATURE];
    return ["pkill", "-x", "hyprsunset"];
}
