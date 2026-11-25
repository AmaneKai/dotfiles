#!/usr/bin/env bash
# Library launcher (Super+Space): rofi 2.0 with script modes for apps and windows.
#   launch.sh [all|apps|windows|run] [rofi options]
#   which drawer to open first (default: all); extra arguments go to rofi

dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
modes="python3 $dir/modes.py"

# the script drawers start with a section header, so begin on the row below it
case "${1:-all}" in run) first=0 ;; *) first=1 ;; esac

exec rofi -no-config -theme "$dir/theme.rasi" \
    -modi "all:$modes all,apps:$modes apps,windows:$modes windows,run" \
    -show "${1:-all}" -selected-row "$first" "${@:2}"
