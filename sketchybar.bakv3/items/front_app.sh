#!/bin/bash

# Enhanced front_app.sh with better icon handling and animations
# Shows the currently focused application with icon

ICON_MAP_SCRIPT="$CONFIG_DIR/plugins/icon_map.sh"

# Function to log debug information
log_debug() {
  echo "[$(date +%H:%M:%S)] [front_app.sh] $1" >> /tmp/sketchybar_debug.log
}

front_app=(
  label.font="$FONT:Semibold:13.0"
  icon.background.drawing=on
  icon.background.image.scale=0.8
  icon.background.corner_radius=9
  icon.background.padding_left=4
  icon.background.padding_right=4
  icon.padding_right=6
  display=active
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
)

sketchybar --add item front_app left \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched
