#!/usr/bin/env bash
set -u

readonly SHELL_CONFIG="library"

is_hyprland() {
    [[ "${XDG_CURRENT_DESKTOP:-}" == *Hyprland* ]]
}

is_hyprland || exit 1
command -v qs >/dev/null || exit 1
exec qs -c "$SHELL_CONFIG" --no-duplicate
