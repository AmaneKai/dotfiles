.pragma library

const ACTIONS = [
    { id: "lock", title: "Close the book", detail: "LOCK", command: ["loginctl", "lock-session"], confirm: false },
    { id: "logout", title: "Leave the library", detail: "LOG OUT", command: ["hyprctl", "dispatch", "hl.dispatch(hl.dsp.exit())"], confirm: true },
    { id: "suspend", title: "Rest between chapters", detail: "SUSPEND", command: ["systemctl", "suspend"], confirm: false },
    { id: "reboot", title: "Begin again", detail: "REBOOT", command: ["systemctl", "reboot"], confirm: true },
    { id: "shutdown", title: "Close the library", detail: "SHUT DOWN", command: ["systemctl", "poweroff"], confirm: true }
];

function actions() {
    return ACTIONS;
}

function needsConfirmation(action, armedId) {
    return action.confirm && armedId !== action.id;
}
