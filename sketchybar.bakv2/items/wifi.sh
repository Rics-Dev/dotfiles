#!/bin/sh

# WiFi item with dynamic signal strength indicator and SSID display
wifi=(
  script="$PLUGIN_DIR/wifi.sh"
  icon.font="$FONT:Regular:14.0"
  icon.color=$BLUE
  icon.padding_right=4
  label.drawing=on
  label.font="$FONT:Regular:12.0"
  padding_right=5
  update_freq=120
  updates=on
  background.padding_left=4
  background.padding_right=4
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}" \
           --subscribe wifi wifi_change system_woke
