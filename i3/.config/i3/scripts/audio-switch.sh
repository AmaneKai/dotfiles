#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

readonly AIRPODS_PROFILE="a2dp-sink"
readonly SOUNDS="$HOME/.config/i3/sounds"

first_matching_name() {
    local list=$1 pattern=$2
    pactl list "$list" short | awk -v pattern="$pattern" '$2 ~ pattern {print $2; exit}'
}

fifine_sink()   { first_matching_name sinks "FIFINE"; }
airpods_card()  { first_matching_name cards "^bluez_card[.]"; }
airpods_sink()  { first_matching_name sinks "^bluez_output[.]"; }

play_sound() {
    mpv --no-video "$SOUNDS/$1" &>/dev/null &
}

notify() {
    notify-send "オーディオ" "$1"
}

report_missing() {
    notify "$1"
    play_sound "airpods-error.mp3"
    return 1
}

switch_to_sink() {
    local sink=$1 message=$2 sound=$3
    set_default_audio_device sink "$sink"
    notify "$message"
    play_sound "$sound"
}

activate_airpods() {
    local card sink
    card=$(airpods_card)
    [[ -n "$card" ]] || report_missing "イヤホンが接続されていません (╥﹏╥)" || return

    pactl set-card-profile "$card" "$AIRPODS_PROFILE" 2>/dev/null \
        || { notify "AirPodsプロファイル設定エラー"; return 1; }
    sleep 0.5

    sink=$(airpods_sink)
    [[ -n "$sink" ]] || report_missing "イヤホンが接続されていません (╥﹏╥)" || return
    switch_to_sink "$sink" "イヤホンに接続しました ♪(´▽｀)" "airpods-connected.mp3"
}

activate_fifine() {
    local sink
    sink=$(fifine_sink)
    [[ -n "$sink" ]] || report_missing "マイクが接続されていません (╥﹏╥)" || return
    switch_to_sink "$sink" "マイクに接続しました (✿◠‿◠)" "mic-connected.mp3"
}

toggle() {
    if [[ "$(pactl get-default-sink)" == *FIFINE* ]]; then
        activate_airpods
    else
        activate_fifine
    fi
}

case "${1:-}" in
    fifine)  activate_fifine ;;
    airpods) activate_airpods ;;
    toggle)  toggle ;;
    *)       echo "Usage: $0 {fifine|airpods|toggle}" >&2; exit 1 ;;
esac
