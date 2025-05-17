#!/usr/bin/env bash
 
# Add debugging to see what's happening
echo "AEROSPACE_PREV_WORKSPACE: $AEROSPACE_PREV_WORKSPACE, \
 AEROSPACE_FOCUSED_WORKSPACE: $AEROSPACE_FOCUSED_WORKSPACE \
 SELECTED: $SELECTED \
 SENDER: $SENDER \
 NAME: $NAME" >> /tmp/sketchybar_debug.log

source "$CONFIG_DIR/colors.sh"

AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSAPCE_WORKSPACE_FOCUSED_MONITOR=$(aerospace list-workspaces --monitor focused --empty no)
AEROSPACE_EMPTY_WORKESPACE=$(aerospace list-workspaces --monitor focused --empty)

# Improved function to reload workspace icons
reload_workspace_icon() {
  workspace=$1
  echo "Reloading icons for workspace: $workspace" >> /tmp/sketchybar_debug.log
  
  # Get apps in the workspace
  apps=$(aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  echo "Apps in workspace $workspace: $apps" >> /tmp/sketchybar_debug.log

  icon_strip=""
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      # Get icon for each app
      app_icon=$($CONFIG_DIR/plugins/icon_map.sh "$app")
      echo "App: $app, Icon: $app_icon" >> /tmp/sketchybar_debug.log
      icon_strip+=" $app_icon"
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi

  # Update the space label with animation
  echo "Setting icon strip for workspace $workspace: $icon_strip" >> /tmp/sketchybar_debug.log
  sketchybar --animate sin 10 --set space.$workspace label="$icon_strip"
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Reload icons for both previous and current workspace
  reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
  reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"

  # Highlight the current workspace
  sketchybar --set space.$AEROSPACE_FOCUSED_WORKSPACE icon.highlight=true \
                         label.highlight=true \
                         background.border_color=$GREY

  # Remove highlight from previous workspace
  sketchybar --set space.$AEROSPACE_PREV_WORKSPACE icon.highlight=false \
                         label.highlight=false \
                         background.border_color=$BACKGROUND_2

  # Update visibility of workspaces
  for i in $AEROSAPCE_WORKSPACE_FOCUSED_MONITOR; do
    sketchybar --set space.$i display=$AEROSPACE_FOCUSED_MONITOR
  done

  for i in $AEROSPACE_EMPTY_WORKESPACE; do
    sketchybar --set space.$i display=0
  done

  sketchybar --set space.$AEROSPACE_FOCUSED_WORKSPACE display=$AEROSPACE_FOCUSED_MONITOR
fi
