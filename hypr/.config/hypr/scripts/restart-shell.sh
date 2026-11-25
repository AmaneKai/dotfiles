#!/usr/bin/env bash
set -u

readonly SHELL_CONFIG="library"

shell_running() {
    pgrep -x qs >/dev/null
}

start_shell() {
    command -v qs >/dev/null || return 1
    setsid qs -c "$SHELL_CONFIG" >/dev/null 2>&1 &
}

shell_running || start_shell
