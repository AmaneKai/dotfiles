#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

readonly LOCK_SCRIPT="$HOME/bin/lock.sh"

build_menu() {
    menu_entry "󰌾  Lock" lock
    menu_entry "󰤄  Suspend" suspend
    menu_entry "󰍃  Logout" logout
    menu_entry "󰜉  Reboot" reboot
    menu_entry "󰐥  Shutdown" shutdown
}

confirmed() {
    local action=$1 choice
    choice=$(
        {
            menu_entry "Yes, $action" yes
            menu_entry "No" no
        } | choose_menu_entry "$action?"
    ) || return 1
    [[ "$(entry_action "$choice")" == "yes" ]]
}

main() {
    local choice action
    choice=$(build_menu | choose_menu_entry "power") || exit 0
    action=$(entry_action "$choice")

    case "$action" in
        lock)     "$LOCK_SCRIPT" ;;
        suspend)  systemctl suspend ;;
        logout)   confirmed logout   && i3-msg exit ;;
        reboot)   confirmed reboot   && systemctl reboot ;;
        shutdown) confirmed shutdown && systemctl poweroff ;;
    esac
}

main
