#!/usr/bin/env bash
set -u

readonly WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
readonly FIT_MODE=cover

die() {
    echo "wallpaper: $*" >&2
    exit 1
}

require_commands() {
    local command_name
    for command_name in "$@"; do
        command -v "$command_name" >/dev/null || die "missing command: $command_name"
    done
}

list_wallpapers() {
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \) | sort
}

monitor_names() {
    hyprctl monitors -j | jq -r '.[].name'
}

focused_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
}

wallpaper_on() {
    local monitor=$1
    hyprctl hyprpaper listactive | sed -n "s/^${monitor}: //p"
}

index_of() {
    local target=$1; shift
    local index=0 candidate

    for candidate in "$@"; do
        [[ $candidate == "$target" ]] && { echo "$index"; return; }
        index=$((index + 1))
    done
    echo 0
}

neighbour_index() {
    local direction=$1 index=$2 count=$3

    if [[ $direction == prev ]]; then
        echo $(((index + count - 1) % count))
    else
        echo $(((index + 1) % count))
    fi
}

set_everywhere() {
    local path=$1 monitor

    while read -r monitor; do
        hyprctl hyprpaper wallpaper "$monitor,$path,$FIT_MODE" >/dev/null
    done < <(monitor_names)
}

set_chosen() {
    local path=${1:-}
    [[ -f $path && $path == "$WALLPAPER_DIR"/* ]] || die "not a wallpaper: $path"
    set_everywhere "$path"
}

main() {
    local direction=${1:-next}
    [[ $direction == next || $direction == prev || $direction == set ]] || die "usage: ${0##*/} [next|prev|set PATH]"
    require_commands hyprctl jq find sed
    [[ $direction == set ]] && { set_chosen "${2:-}"; return; }

    local wallpapers
    mapfile -t wallpapers < <(list_wallpapers)
    local count=${#wallpapers[@]}
    (( count > 1 )) || exit 0

    local current index
    current=$(wallpaper_on "$(focused_monitor)")
    index=$(index_of "$current" "${wallpapers[@]}")
    set_everywhere "${wallpapers[$(neighbour_index "$direction" "$index" "$count")]}"
}

main "$@"
