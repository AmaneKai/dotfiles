#!/usr/bin/env bash

readonly LOCK_IMAGE="/tmp/lock_screen.png"
readonly LOCK_GENERATOR="$HOME/.config/i3/scripts/lock-gen.py"
readonly FONT="JetBrainsMono Nerd Font"
readonly BACKGROUND_COLOR="191724"

background_args=(-c "$BACKGROUND_COLOR")

generate_blurred_screenshot() {
  rm -f "$LOCK_IMAGE"
  python3 "$LOCK_GENERATOR" "$LOCK_IMAGE" 2>/dev/null
  [[ -s "$LOCK_IMAGE" ]] && background_args+=(--image "$LOCK_IMAGE")
}

lock_with_i3lock_color() {
  i3lock "$@" "${background_args[@]}" \
    --clock \
    --time-str="%H:%M" \
    --date-str="%A, %B %d" \
    --time-font="$FONT" \
    --date-font="$FONT" \
    --time-size=36 \
    --date-size=14 \
    --time-color=e0def4ff \
    --date-color=6e6a86ff \
    --ring-color=9ccfd855 \
    --ringver-color=c4a7e7ff \
    --ringwrong-color=eb6f92ff \
    --inside-color=1f1d2ecc \
    --insidever-color=1f1d2ecc \
    --insidewrong-color=1f1d2eee \
    --line-color=9ccfd830 \
    --keyhl-color=9ccfd8ff \
    --bshl-color=eb6f92ff \
    --separator-color=26233aff \
    --verif-color=c4a7e7ff \
    --wrong-color=eb6f92ff \
    --verif-text="..." \
    --wrong-text="x" \
    --verif-font="$FONT" \
    --wrong-font="$FONT" \
    --radius=95 \
    --ring-width=5 \
    --indicator
}

lock_with_plain_i3lock() {
  i3lock "$@" "${background_args[@]}"
}

generate_blurred_screenshot
lock_with_i3lock_color "$@" || lock_with_plain_i3lock "$@"
rm -f "$LOCK_IMAGE"
