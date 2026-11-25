#!/usr/bin/env bash
set -u

readonly SOUND_DIR="$HOME/.config/hypr/sounds"
readonly EVENT_SOCKET="${XDG_RUNTIME_DIR:-}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.socket2.sock"

require_commands() {
    local command_name
    for command_name in socat pw-play; do
        command -v "$command_name" >/dev/null || exit 1
    done
}

sound_for_event() {
    case "$1" in
        openwindow) echo "$SOUND_DIR/page-open.wav" ;;
        closewindow) echo "$SOUND_DIR/page-close.wav" ;;
        *) return 1 ;;
    esac
}

play() {
    [[ -f "$1" ]] && setsid pw-play "$1" >/dev/null 2>&1 &
}

listen() {
    local event sound
    while IFS='>' read -r event _; do
        sound=$(sound_for_event "$event") || continue
        play "$sound"
    done < <(socat -u "UNIX-CONNECT:$EVENT_SOCKET" -)
}

require_commands
[[ -S "$EVENT_SOCKET" ]] || exit 1
listen
