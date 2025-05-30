#!/bin/sh

# ======================================================
# Enhanced Front App Plugin with Aerospace Integration
# ======================================================

source "$CONFIG_DIR/colors.sh"

# Function to log debug information
log_debug() {
  echo "[$(date +%H:%M:%S)] [front_app.sh] $1" >> /tmp/sketchybar_debug.log
}

# Get the focused workspace information with error handling
get_focused_workspace() {
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
  if [ $? -ne 0 ] || [ -z "$FOCUSED_WORKSPACE" ]; then
    log_debug "Error: Failed to get focused workspace, using fallback"
    FOCUSED_WORKSPACE=1
  fi
  echo "$FOCUSED_WORKSPACE"
}

# Get windows in workspace with better error handling
get_workspace_windows() {
  local workspace="$1"
  local windows=$(aerospace list-windows --workspace "$workspace" 2>/dev/null | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  if [ $? -ne 0 ]; then
    log_debug "Error: Failed to list windows in workspace $workspace"
    windows=""
  fi
  echo "$windows"
}

# Update front app display
update_front_app() {
  local app_name="$1"
  
  if [ -z "$app_name" ]; then
    log_debug "Warning: Empty application name, showing Desktop"
    sketchybar --set "$NAME" \
      label="Desktop" \
      icon.background.image="" \
      label.color=$WORKSPACE_INACTIVE
  else
    # Set the app name and icon with smooth animation
    sketchybar --animate tanh 15 --set "$NAME" \
      label="$app_name" \
      icon.background.image="app.$app_name" \
      icon.background.image.scale=0.8 \
      label.color=$WHITE
    log_debug "Updated front app to: $app_name"
  fi
}

# Create icon strip for workspace
create_icon_strip() {
  local workspace="$1"
  local windows=$(get_workspace_windows "$workspace")
  local icon_strip=""
  
  if [ -n "$windows" ]; then
    while IFS= read -r app; do
      # Skip empty app names
      if [ -z "$app" ]; then
        continue
      fi
      
      # Get icon for the app with error handling
      local app_icon=$($CONFIG_DIR/plugins/icon_map.sh "$app" 2>/dev/null)
      if [ $? -ne 0 ] || [ -z "$app_icon" ]; then
        app_icon=":default:"
        log_debug "Warning: Failed to get icon for app: $app"
      fi
      
      icon_strip+=" $app_icon"
    done <<< "$windows"
  else
    icon_strip=" —"
    log_debug "No apps in workspace $workspace"
  fi
  
  echo "$icon_strip"
}

# Update workspace icon strip
update_workspace_icons() {
  local workspace="$1"
  local icon_strip=$(create_icon_strip "$workspace")
  
  # Update the space label with animation
  sketchybar --animate tanh 20 --set "space.$workspace" label="$icon_strip"
  log_debug "Updated workspace $workspace icon strip: $icon_strip"
}

# Update workspace highlighting
update_workspace_highlighting() {
  local focused_workspace="$1"
  
  # Update the focused workspace highlighting
  sketchybar --set "space.$focused_workspace" \
    icon.highlight=true \
    icon.color=$WORKSPACE_ACTIVE \
    label.highlight=true \
    label.color=$WHITE \
    background.color=$BACKGROUND_1 \
    background.border_color=$WORKSPACE_BORDER_ACTIVE \
    background.border_width=2
}

# Main event handler
case "$SENDER" in
  "front_app_switched")
    FOCUSED_WORKSPACE=$(get_focused_workspace)
    
    log_debug "Front app switched - Sender: $SENDER, Info: $INFO, Focused workspace: $FOCUSED_WORKSPACE"
    
    # Update the front app display
    update_front_app "$INFO"
    
    # Update workspace icons
    update_workspace_icons "$FOCUSED_WORKSPACE"
    
    # Update workspace highlighting
    update_workspace_highlighting "$FOCUSED_WORKSPACE"
    ;;
    
  "aerospace_workspace_change")
    # Handle workspace changes
    if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
      log_debug "Workspace changed to: $AEROSPACE_FOCUSED_WORKSPACE"
      update_workspace_icons "$AEROSPACE_FOCUSED_WORKSPACE"
      
      # Also update previous workspace if available
      if [ -n "$AEROSPACE_PREV_WORKSPACE" ] && [ "$AEROSPACE_PREV_WORKSPACE" != "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
        update_workspace_icons "$AEROSPACE_PREV_WORKSPACE"
      fi
    fi
    ;;
    
  *)
    # Handle other events or forced updates
    FOCUSED_WORKSPACE=$(get_focused_workspace)
    log_debug "Generic update - Sender: $SENDER, Focused workspace: $FOCUSED_WORKSPACE"
    update_workspace_icons "$FOCUSED_WORKSPACE"
    ;;
esac