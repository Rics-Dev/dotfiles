#!/bin/sh

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.font="$FONT:Regular:15.0"
  padding_right=5
  padding_left=0
  label.drawing=on
  update_freq=30
  updates=on
)
sketchybar --add item battery right \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke
