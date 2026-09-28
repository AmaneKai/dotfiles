#!/usr/bin/env bash

readonly POLYBAR_CONFIG="$HOME/.config/polybar/config.ini"

kill_existing_polybar() {
  killall -q polybar
  while pgrep -u "$UID" -x polybar > /dev/null
    do sleep 1
  done
}

list_active_outputs() {
  xrandr --query \
    | awk '$2 == "connected" && $0 ~ / [0-9]+x[0-9]+\+[0-9]+\+[0-9]+/ {print $1}'
}

find_laptop_output() {
  list_active_outputs | grep -m1 '^eDP' || echo "eDP-1"
}

find_active_external_output() {
  list_active_outputs | grep -v '^eDP' | head -1
}

launch_polybar() {
  local active_external_output
  active_external_output=$(find_active_external_output)

  if [ -n "$active_external_output" ]
    then MONITOR="$active_external_output" polybar --config="$POLYBAR_CONFIG" monitor &
    return
  fi

  MONITOR="$(find_laptop_output)" polybar --config="$POLYBAR_CONFIG" laptop &
}

kill_existing_polybar
launch_polybar
