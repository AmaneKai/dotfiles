#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

device_description() {
    local kind=$1 name=$2 description
    description=$(pactl list "${kind}s" \
        | grep -A 30 "Name: $name" \
        | grep -m1 "Description:" \
        | sed 's/.*Description: //')
    printf '%s\n' "${description:-$name}"
}

list_devices() {
    local kind=$1 wired_icon=$2 bluetooth_icon=$3 name icon
    pactl list "${kind}s" short | awk '{print $2}' | while read -r name; do
        [[ "$name" == *monitor* ]] && continue
        icon=$wired_icon
        [[ "$name" == *bluez* ]] && icon=$bluetooth_icon
        menu_entry "${icon}  $(device_description "$kind" "$name")" "$kind" "$name"
    done
}

build_menu() {
    menu_header "─────  󰕾  OUTPUTS  ─────"
    list_devices sink "󰕾" "󰋋"
    menu_header "─────  󰍬  INPUTS  ──────"
    list_devices source "󰍬" "󰋎"
}

main() {
    local choice kind
    choice=$(build_menu | choose_menu_entry "audio") || exit 0
    kind=$(entry_action "$choice")

    set_default_audio_device "$kind" "$(entry_value "$choice")"

    case "$kind" in
        sink)   notify-send "󰕾 Output" "$(entry_label "$choice")" ;;
        source) notify-send "󰍬 Input" "$(entry_label "$choice")" ;;
    esac
}

main
