#!/usr/bin/env bash

set -Eeuo pipefail

readonly PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly PROGRAM="$PROJECT_DIR/g14-power"
readonly CONFIG="$PROJECT_DIR/g14-power.conf.example"

bash -n "$PROGRAM"
grep -Fq 'g14-power ' < <("$PROGRAM" --version)
"$PROGRAM" --help >/dev/null
NO_COLOR=1 G14_POWER_CONFIG="$CONFIG" "$PROGRAM" status >/dev/null

printf 'smoke tests passed\n'
