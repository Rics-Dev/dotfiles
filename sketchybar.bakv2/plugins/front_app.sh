#!/bin/sh

# ======================================================
# Enhanced Front App Plugin
# ======================================================
# Features:
# - Improved window tracking
# - Better icon handling
# - Workspace icon updates
# - Error handling and debugging
# ======================================================

# Function to log debug information
log_debug() {
  echo "[$(date +%H:%M:%S)] [front_app.sh] $1" >> /tmp/sketchybar_debug.log
}

# Get the focused workspace information
AEROSPACE_FOCUSED_MONITOR_NO=$(aerospace list-workspaces --focused 2>/dev/null)
if [ $? -ne 0 ]; then
  log_debug "Error: Failed to get focused workspace"
  AEROSPACE_FOCUSED_MONITOR_NO=1  # Fallback to first workspace
fi

# Get windows in the focused workspace with error handling
AEROSPACE_LIST_OF_WINDOWS_IN_FOCUSED_MONITOR=$(aerospace list-windows --workspace $AEROSPACE_FOCUSED_MONITOR_NO 2>/dev/null | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
if [ $? -ne 0 ]; then
  log_debug "Error: Failed to list windows in workspace $AEROSPACE_FOCUSED_MONITOR_NO"
  AEROSPACE_LIST_OF_WINDOWS_IN_FOCUSED_MONITOR=""
fi

# Debug info
log_debug "Focused workspace: $AEROSPACE_FOCUSED_MONITOR_NO"
log_debug "Windows: $AEROSPACE_LIST_OF_WINDOWS_IN_FOCUSED_MONITOR"
log_debug "Sender: $SENDER, Info: $INFO"

if [ "$SENDER" = "front_app_switched" ]; then
  # Handle application switch with better error recovery
  if [ -z "$INFO" ]; then
    log_debug "Warning: Empty application name"
    sketchybar --set "$NAME" label="Desktop" icon.background.image=""
  else
    # Set the app name and icon with animation
    sketchybar --animate tanh 15 --set "$NAME" label="$INFO" icon.background.image="app.$INFO" icon.background.image.scale=0.8
    log_debug "Updated front app to: $INFO"
  fi

  # Process all windows in the workspace and create an icon strip
  apps=$AEROSPACE_LIST_OF_WINDOWS_IN_FOCUSED_MONITOR
  icon_strip=""
  
  if [ -n "${apps}" ]; then
    while read -r app
    do
      # Skip empty app names
      if [ -z "$app" ]; then
        continue
      fi
      
      # Get icon for the app with error handling
      app_icon=$($CONFIG_DIR/plugins/icon_map.sh "$app" 2>/dev/null)
      if [ $? -ne 0 ] || [ -z "$app_icon" ]; then
        app_icon=":default:"
        log_debug "Warning: Failed to get icon for app: $app"
      else
        log_debug "App: $app, Icon: $app_icon"
      fi
      
      icon_strip+=" $app_icon"
    done <<< "${apps}"
  else
    icon_strip=" —"
    log_debug "No apps in workspace $AEROSPACE_FOCUSED_MONITOR_NO"
  fi
  
  # Update the space label with the icons using animation
  sketchybar --animate tanh 20 --set space.$AEROSPACE_FOCUSED_MONITOR_NO label="$icon_strip"
  log_debug "Updated icon strip: $icon_strip"
  
  # Update workspace highlighting
  sketchybar --set space.$AEROSPACE_FOCUSED_MONITOR_NO \
    icon.highlight=true \
    label.highlight=true \
    background.border_color=$GREY
fi
