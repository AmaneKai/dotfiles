#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

readonly SCAN_SECONDS=10
readonly CONTROLLER_TIMEOUT_SECONDS=2

bluetooth_is_powered() {
    timeout "$CONTROLLER_TIMEOUT_SECONDS" bluetoothctl show | grep -q "Powered: yes"
}

device_is_connected() {
    bluetoothctl info "$1" | grep -q "Connected: yes"
}

device_is_bonded() {
    bluetoothctl info "$1" | grep -q "Bonded: yes"
}

device_is_paired() {
    bluetoothctl info "$1" | grep -q "Paired: yes"
}

device_is_known() {
    bluetoothctl devices | grep -q "$1"
}

rediscover() {
    timeout "$((SCAN_SECONDS + 2))" bluetoothctl --timeout "$SCAN_SECONDS" scan on >/dev/null 2>&1
    device_is_known "$1"
}

pair_and_bond() {
    local mac=$1
    bluetoothctl pairable on >/dev/null
    device_is_paired "$mac" && bluetoothctl remove "$mac" >/dev/null
    if ! device_is_known "$mac" && ! rediscover "$mac"; then
        echo "not found: put the device in pairing mode"
        return 1
    fi
    bluetoothctl pair "$mac" && bluetoothctl trust "$mac"
}

pair_if_needed() {
    device_is_bonded "$1" || pair_and_bond "$1"
}

connect_device() {
    local mac=$1 output
    output=$( { pair_if_needed "$mac" && bluetoothctl connect "$mac"; } 2>&1 ) && return 0
    printf '%s\n' "$output" | sed 's/\x1b\[[0-9;]*[A-Za-z]//g' | grep -v '^\s*$' | tail -1
    return 1
}

device_name() {
    bluetoothctl info "$1" | grep -m1 "Name:" | sed 's/.*Name: //'
}

notify() {
    notify-send "$1 Bluetooth" "$2"
}

reopen_menu() {
    exec bash "$0"
}

list_devices() {
    local mac name
    bluetoothctl devices | grep "^Device" | while read -r _ mac name; do
        name=${name:-$mac}
        if device_is_connected "$mac"; then
            menu_entry "󰂱  ${name} (connected)" disconnect "$mac"
        else
            menu_entry "󰂯  ${name}" connect "$mac"
        fi
    done
}

build_menu() {
    menu_header "─────  󰂯  BLUETOOTH  ─────"
    if ! bluetooth_is_powered; then
        menu_entry "⏻   Turn Bluetooth On" power on
        return
    fi

    menu_entry "⏻   Turn Bluetooth Off" power off
    menu_header "─────  󰂯  DEVICES  ───────"
    list_devices
    menu_header "─────  󰂲  SCAN  ──────────"
    menu_entry "󰂯  Scan for new devices" scan
}

main() {
    local choice value reason
    choice=$(build_menu | choose_menu_entry "bluetooth") || exit 0
    value=$(entry_value "$choice")

    case "$(entry_action "$choice")" in
        power)
            bluetoothctl power "$value"
            if [[ "$value" == "on" ]]; then
                notify "󰂯" "Turned on"
                sleep 1
                reopen_menu
            fi
            notify "󰂯" "Turned off"
            ;;
        connect)
            notify "󰂯" "Connecting..."
            if reason=$(connect_device "$value"); then
                notify "󰂱" "Connected to $(device_name "$value")"
            else
                notify "󰂯" "Failed: ${reason:-unknown error}"
            fi
            ;;
        disconnect)
            local name
            name=$(device_name "$value")
            bluetoothctl disconnect "$value"
            notify "󰂯" "Disconnected from ${name}"
            ;;
        scan)
            notify "󰂯" "Scanning for ${SCAN_SECONDS} seconds..."
            bluetoothctl --timeout "$SCAN_SECONDS" scan on
            reopen_menu
            ;;
    esac
}

main
