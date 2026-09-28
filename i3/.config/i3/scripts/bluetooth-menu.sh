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
    local choice value
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
            if bluetoothctl connect "$value"; then
                notify "󰂱" "Connected to $(device_name "$value")"
            else
                notify "󰂯" "Failed to connect"
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
