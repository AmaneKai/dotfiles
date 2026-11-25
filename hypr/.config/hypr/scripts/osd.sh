#!/usr/bin/env bash
set -u

readonly SINK="@DEFAULT_AUDIO_SINK@"
readonly VOLUME_STEP="5%"
readonly BRIGHTNESS_STEP="5%"
readonly FALLBACK_TIMEOUT_MS=1300
readonly HUD_IPC=(qs -c library ipc call osd set)

die() {
    echo "osd: $*" >&2
    exit 1
}

require_commands() {
    local command_name
    for command_name in "$@"; do
        command -v "$command_name" >/dev/null || die "missing command: $command_name"
    done
}

show_hud() {
    local kind=$1 percent=$2 muted=$3

    "${HUD_IPC[@]}" "$kind" "$percent" "$muted" >/dev/null 2>&1 && return 0

    notify-send -a osd -t "$FALLBACK_TIMEOUT_MS" \
        -h string:x-canonical-private-synchronous:osd \
        -h "int:value:$percent" "$kind" "$percent%"
}

volume_percent() {
    wpctl get-volume "$SINK" | awk '{ printf "%d", $2 * 100 + 0.5 }'
}

volume_muted() {
    wpctl get-volume "$SINK" | grep -q MUTED && echo true || echo false
}

brightness_percent() {
    brightnessctl -m | awk -F, 'NR == 1 { gsub("%", "", $4); print $4 }'
}

report_volume() {
    show_hud volume "$(volume_percent)" "$(volume_muted)"
}

report_brightness() {
    show_hud brightness "$(brightness_percent)" false
}

main() {
    local action=${1:-}

    case $action in
        volume-up)       require_commands wpctl;        wpctl set-volume -l 1 "$SINK" "$VOLUME_STEP+"; report_volume ;;
        volume-down)     require_commands wpctl;        wpctl set-volume "$SINK" "$VOLUME_STEP-";      report_volume ;;
        volume-mute)     require_commands wpctl;        wpctl set-mute "$SINK" toggle;                 report_volume ;;
        brightness-up)   require_commands brightnessctl; brightnessctl set "$BRIGHTNESS_STEP+" >/dev/null;    report_brightness ;;
        brightness-down) require_commands brightnessctl; brightnessctl -n1 set "$BRIGHTNESS_STEP-" >/dev/null; report_brightness ;;
        *) die "usage: ${0##*/} volume-up|volume-down|volume-mute|brightness-up|brightness-down" ;;
    esac
}

main "$@"
