#!/usr/bin/env bash
# Lock screen: flat Rose Pine base, clock, date, and a thin line that jumps as
# you type. No ring. Needs i3lock-color; anything else gets a plain lock.

readonly FONT="JetBrainsMono Nerd Font"

readonly BASE=191724
readonly TEXT=e0def4ff
readonly MUTED=6e6a86ff
readonly OVERLAY=26233aff
readonly IRIS=c4a7e7ff
readonly LOVE=eb6f92ff

styled=(
  --color="$BASE"

  --clock
  --indicator
  --time-str="%H:%M"
  --time-font="$FONT"
  --time-size=96
  --time-color="$TEXT"
  --time-pos="w/2:h/2-20"
  --date-str="%A, %d %B"
  --date-font="$FONT"
  --date-size=18
  --date-color="$MUTED"
  --date-pos="w/2:h/2+24"

  # the typing line replaces the ring
  --bar-indicator
  --bar-pos="w/2-160:h/2+70"
  --bar-total-width=320
  --bar-count=32
  --bar-max-height=10
  --bar-base-width=2
  --bar-color="$OVERLAY"
  --keyhl-color="$IRIS"
  --bshl-color="$LOVE"
  --ringver-color="$IRIS"
  --ringwrong-color="$LOVE"

  --verif-text="checking"
  --verif-font="$FONT"
  --verif-size=14
  --verif-color="$IRIS"
  --verif-pos="w/2:h/2+110"
  --wrong-text="wrong password"
  --wrong-font="$FONT"
  --wrong-size=14
  --wrong-color="$LOVE"
  --wrong-pos="w/2:h/2+110"
  --noinput-text=""
)

i3lock "$@" "${styled[@]}" &
locker=$!

# xss-lock holds off suspend until every copy of this fd is closed.
[[ -n "${XSS_SLEEP_LOCK_FD:-}" ]] && exec {XSS_SLEEP_LOCK_FD}<&-

wait "$locker" || exec i3lock "$@" --color="$BASE"
