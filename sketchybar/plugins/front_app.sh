#!/bin/sh


# Get the focused workspace
AEROSPACE_FOCUSED_MONITOR_NO=$(aerospace list-workspaces --focused)

# Get windows in a more robust way
AEROSPACE_LIST_OF_WINDOWS_IN_FOCUSED_MONITOR=$(aerospace list-windows --workspace $AEROSPACE_FOCUSED_MONITOR_NO | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

# Debug info
echo "Focused workspace: $AEROSPACE_FOCUSED_MONITOR_NO" >> /tmp/sketchybar_debug.log
echo "Windows: $AEROSPACE_LIST_OF_WINDOWS_IN_FOCUSED_MONITOR" >> /tmp/sketchybar_debug.log

if [ "$SENDER" = "front_app_switched" ]; then
  # Set the app name and icon
  sketchybar --set "$NAME" label="$INFO" icon.background.image="app.$INFO" icon.background.image.scale=0.8

  # Process all windows in the workspace and create an icon strip
  apps=$AEROSPACE_LIST_OF_WINDOWS_IN_FOCUSED_MONITOR
  icon_strip=""
  
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      # Get icon for the app - make sure to capture the output correctly
      app_icon=$($CONFIG_DIR/plugins/icon_map.sh "$app")
      echo "App: $app, Icon: $app_icon" >> /tmp/sketchybar_debug.log
      icon_strip+=" $app_icon"
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi
  
  # Update the space label with the icons
  sketchybar --set space.$AEROSPACE_FOCUSED_MONITOR_NO label="$icon_strip"
  echo "Updated icon strip: $icon_strip" >> /tmp/sketchybar_debug.log
fi
