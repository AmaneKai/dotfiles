#!/usr/bin/env bash

set -euo pipefail

readonly VOLUME_STEP="5%"
readonly BRIGHTNESS_STEP="10%"
readonly POWER_PROFILES=(power-saver balanced performance)

notify_level() {
    local tag=$1 label=$2 percent=$3
    notify-send -a osd -u low -h "int:value:$percent" -h "string:x-dunst-stack-tag:$tag" "$label $percent%"
}

notify_text() {
    local tag=$1 text=$2
    notify-send -a osd -u low -h "string:x-dunst-stack-tag:$tag" "$text"
}

volume_percent() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf "%d", $2 * 100 + 0.5}'
}

volume_is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -q MUTED
}

brightness_percent() {
    brightnessctl -m | cut -d, -f4 | tr -d %
}

change_volume() {
    case "$1" in
        up)   wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "$VOLUME_STEP+" ;;
        down) wpctl set-volume @DEFAULT_AUDIO_SINK@ "$VOLUME_STEP-" ;;
        mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        *)    return 1 ;;
    esac

    if volume_is_muted; then
        notify_text volume "vol muted"
    else
        notify_level volume vol "$(volume_percent)"
    fi
}

change_brightness() {
    case "$1" in
        up)   brightnessctl -q set "+$BRIGHTNESS_STEP" ;;
        down) brightnessctl -q set "$BRIGHTNESS_STEP-" ;;
        *)    return 1 ;;
    esac

    notify_level brightness bri "$(brightness_percent)"
}

next_power_profile() {
    local current next=${POWER_PROFILES[1]} index
    current=$(powerprofilesctl get)
    for index in "${!POWER_PROFILES[@]}"; do
        if [[ "${POWER_PROFILES[$index]}" == "$current" ]]; then
            next=${POWER_PROFILES[$(( (index + 1) % ${#POWER_PROFILES[@]} ))]}
        fi
    done

    powerprofilesctl set "$next"
    notify_text power-profile "power $next"
}

case "${1:-}" in
    volume)     change_volume "${2:-}" ;;
    brightness) change_brightness "${2:-}" ;;
    profile)    next_power_profile ;;
    *)          echo "Usage: $0 {volume up|down|mute|brightness up|down|profile}" >&2; exit 1 ;;
esac
