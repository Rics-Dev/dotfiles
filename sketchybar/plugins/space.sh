#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Global variable for previous focused workspace
PREV_FOCUSED=""

# Update highlighting for a single workspace
update_space_highlighting() {
  local workspace_id=${NAME#*.}
  local focused_workspace=$(aerospace list-workspaces --focused)
  local has_windows=$(aerospace list-windows --workspace "$workspace_id" | wc -l | xargs)

  if [ "$workspace_id" = "$focused_workspace" ]; then
    if [ "$has_windows" -gt 0 ]; then
      sketchybar --set "$NAME" \
                 icon.highlight=true \
                 icon.color=$WORKSPACE_ACTIVE \
                 label.highlight=true \
                 label.color=$WHITE \
                 background.color=$BACKGROUND_1 \
                 background.border_color=$WORKSPACE_BORDER_ACTIVE \
                 background.border_width=2 \
                 background.drawing=on \
                 display=1
    else
      sketchybar --set "$NAME" \
                 display=0 \
                 icon.highlight=false \
                 icon.color=$WORKSPACE_INACTIVE
    fi
  else
    if [ "$has_windows" -gt 0 ]; then
      sketchybar --set "$NAME" \
                 icon.highlight=false \
                 icon.color=$WORKSPACE_INACTIVE \
                 label.highlight=false \
                 label.color=$WORKSPACE_INACTIVE \
                 background.color=$TRANSPARENT \
                 background.border_color=$WORKSPACE_BORDER_INACTIVE \
                 background.border_width=1 \
                 background.drawing=on \
                 display=1
    else
      sketchybar --set "$NAME" \
                 display=0 \
                 icon.highlight=false \
                 icon.color=$WORKSPACE_INACTIVE
    fi
  fi
}

# Handle mouse click events
mouse_clicked() {
  local workspace_id=${NAME#*.}
  if [ "$BUTTON" = "right" ]; then
    echo "Right clicked workspace $workspace_id"
  else
    if [ "$MODIFIER" = "shift" ]; then
      SPACE_LABEL=$(osascript -e "return (text returned of (display dialog \"Give a name to workspace $workspace_id:\" default answer \"\" with icon note buttons {\"Cancel\", \"Continue\"} default button \"Continue\"))" 2>/dev/null)
      if [ $? -eq 0 ]; then
        sketchybar --set "$NAME" icon="${SPACE_LABEL:-$workspace_id}"
      fi
    else
      aerospace workspace "$workspace_id"
    fi
  fi
}

# Update all workspaces' appearance
update_all_workspaces() {
  local focused_workspace=$(aerospace list-workspaces --focused)
  
  # Update previous workspace if it exists and is different
  if [ -n "$PREV_FOCUSED" ] && [ "$PREV_FOCUSED" != "$focused_workspace" ]; then
    local prev_has_windows=$(aerospace list-windows --workspace "$PREV_FOCUSED" | wc -l | xargs)
    if [ "$prev_has_windows" -eq 0 ]; then
      sketchybar --set "space.$PREV_FOCUSED" \
                 display=0 \
                 icon.highlight=false \
                 icon.color=$WORKSPACE_INACTIVE \
                 label.highlight=false
    else
      sketchybar --set "space.$PREV_FOCUSED" \
                 icon.highlight=false \
                 icon.color=$WORKSPACE_INACTIVE \
                 label.highlight=false \
                 label.color=$WORKSPACE_INACTIVE \
                 background.color=$TRANSPARENT \
                 background.border_color=$WORKSPACE_BORDER_INACTIVE \
                 background.border_width=1 \
                 background.drawing=on
    fi
  fi

  # Update all non-focused workspaces
  for ws in $(aerospace list-workspaces); do
    if [ "$ws" != "$focused_workspace" ]; then
      local has_windows=$(aerospace list-windows --workspace "$ws" | wc -l | xargs)
      if [ "$has_windows" -gt 0 ]; then
        sketchybar --set "space.$ws" \
                   display=1 \
                   icon.highlight=false \
                   icon.color=$WORKSPACE_INACTIVE \
                   label.highlight=false \
                   label.color=$WORKSPACE_INACTIVE \
                   background.color=$TRANSPARENT \
                   background.border_color=$WORKSPACE_BORDER_INACTIVE \
                   background.border_width=1 \
                   background.drawing=on
      else
        sketchybar --set "space.$ws" display=0
      fi
    fi
  done

  # Update focused workspace
  local focused_has_windows=$(aerospace list-windows --workspace "$focused_workspace" | wc -l | xargs)
  if [ "$focused_has_windows" -gt 0 ]; then
    sketchybar --set "space.$focused_workspace" \
               display=1 \
               icon.highlight=true \
               icon.color=$WORKSPACE_ACTIVE \
               label.highlight=true \
               label.color=$WHITE \
               background.color=$BACKGROUND_1 \
               background.border_color=$WORKSPACE_BORDER_ACTIVE \
               background.border_width=2 \
               background.drawing=on
  else
    sketchybar --set "space.$focused_workspace" display=0
  fi

  PREV_FOCUSED="$focused_workspace"
}

# Event handler
case "$SENDER" in
  "mouse.clicked")
    mouse_clicked
    ;;
  "aerospace_workspace_change"|"window_focus"|"application_launched"|"application_terminated"|"application_activated")
    update_all_workspaces
    update_space_highlighting
    ;;
  "forced"|"space_change"|*)
    update_space_highlighting
    ;;
esac
