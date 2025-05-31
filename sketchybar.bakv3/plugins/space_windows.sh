#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Cache frequently used values
AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSPACE_FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Log for debugging
echo "[$(date +%H:%M:%S)] space_windows.sh - SENDER: $SENDER, FOCUSED: $AEROSPACE_FOCUSED_WORKSPACE, PREV: $PREV_WORKSPACE" >> /tmp/sketchybar_debug.log

# Reload workspace icons
reload_workspace_icon() {
  local workspace="$1"
  local apps=$(aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  local icon_strip=" "
  
  if [ -n "${apps}" ]; then
    while IFS= read -r app; do
      [ -n "$app" ] && icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi
  sketchybar --animate sin 10 --set "space.$workspace" label="$icon_strip"
}

# Update workspace highlighting
update_workspace_highlighting() {
  local focused="$1"
  local previous="$2"
  
  # Highlight focused workspace
  if [ -n "$focused" ]; then
    local focused_has_windows=$(aerospace list-windows --workspace "$focused" | wc -l | xargs)
    if [ "$focused_has_windows" -gt 0 ]; then
      sketchybar --set "space.$focused" \
                 icon.highlight=true \
                 icon.color=$WORKSPACE_ACTIVE \
                 label.highlight=true \
                 label.color=$WHITE \
                 background.color=$BACKGROUND_1 \
                 background.border_color=$WORKSPACE_BORDER_ACTIVE \
                 background.drawing=on \
                 background.border_width=2 \
                 display=$AEROSPACE_FOCUSED_MONITOR
    else
      sketchybar --set "space.$focused" display=0
    fi
  fi
  
  # Update previous workspace
  if [ -n "$previous" ] && [ "$previous" != "$focused" ]; then
    local prev_has_windows=$(aerospace list-windows --workspace "$previous" | wc -l | xargs)
    if [ "$prev_has_windows" -gt 0 ]; then
      sketchybar --set "space.$previous" \
                 icon.highlight=false \
                 icon.color=$WORKSPACE_INACTIVE \
                 label.highlight=false \
                 label.color=$WORKSPACE_INACTIVE \
                 background.color=$TRANSPARENT \
                 background.border_color=$WORKSPACE_BORDER_INACTIVE \
                 background.border_width=1 \
                 display=$AEROSPACE_FOCUSED_MONITOR
    else
      sketchybar --set "space.$previous" display=0
    fi
  fi

  # Update all other workspaces
  for workspace in $(aerospace list-workspaces); do
    if [ "$workspace" != "$focused" ] && [ "$workspace" != "$previous" ]; then
      local ws_has_windows=$(aerospace list-windows --workspace "$workspace" | wc -l | xargs)
      if [ "$ws_has_windows" -gt 0 ]; then
        sketchybar --set "space.$workspace" \
                   icon.highlight=false \
                   icon.color=$WORKSPACE_INACTIVE \
                   label.highlight=false \
                   label.color=$WORKSPACE_INACTIVE \
                   background.color=$TRANSPARENT \
                   background.border_color=$WORKSPACE_BORDER_INACTIVE \
                   background.border_width=1 \
                   display=$AEROSPACE_FOCUSED_MONITOR
      else
        sketchybar --set "space.$workspace" display=0
      fi
    fi
  done
}

# Update workspace visibility
update_workspace_visibility() {
  local focused_monitor=$AEROSPACE_FOCUSED_MONITOR
  local workspaces=$(aerospace list-workspaces --monitor focused --empty no)
  local empty_workspaces=$(aerospace list-workspaces --monitor focused --empty)

  # Show non-empty workspaces
  for workspace in $workspaces; do
    sketchybar --set "space.$workspace" display="$focused_monitor"
  done

  # Show/hide focused workspace based on content
  if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    local focused_has_windows=$(aerospace list-windows --workspace "$AEROSPACE_FOCUSED_WORKSPACE" | wc -l | xargs)
    sketchybar --set "space.$AEROSPACE_FOCUSED_WORKSPACE" display=$([ "$focused_has_windows" -gt 0 ] && echo "$focused_monitor" || echo 0)
  fi

  # Hide empty workspaces
  for workspace in $empty_workspaces; do
    sketchybar --set "space.$workspace" display=0
  done
}

# Event handler
case "$SENDER" in
  "aerospace_workspace_change"|"forced")
    [ -n "$PREV_WORKSPACE" ] && reload_workspace_icon "$PREV_WORKSPACE"
    [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ] && reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"
    update_workspace_highlighting "$AEROSPACE_FOCUSED_WORKSPACE" "$PREV_WORKSPACE"
    update_workspace_visibility
    sketchybar --set space_creator icon.color=$(aerospace list-workspaces --monitor focused --empty no | grep -q . && echo "$WORKSPACE_ACTIVE" || echo "$WORKSPACE_INACTIVE")
    ;;
  "window_focus"|"application_activated"|"application_terminated"|"application_launched")
    for workspace in $(aerospace list-workspaces); do
      reload_workspace_icon "$workspace"
    done
    update_workspace_highlighting "$AEROSPACE_FOCUSED_WORKSPACE" "$PREV_WORKSPACE"
    update_workspace_visibility
    ;;
  *)
    [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ] && reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"
    update_workspace_highlighting "$AEROSPACE_FOCUSED_WORKSPACE" ""
    ;;
esac
