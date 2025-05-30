#!/bin/sh

# Enhanced spaces.sh with improved aerospace integration
# Uses improved color scheme and dynamically updates workspace icons

# Add events for aerospace integration
sketchybar --add event aerospace_workspace_change
sketchybar --add event window_focus
sketchybar --add event application_launched
sketchybar --add event application_terminated
sketchybar --add event application_activated

# Create workspace items for each monitor
for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $m); do
    sid=$i
    space=(
      space="$sid"
      icon="$sid"
      icon.color=$WORKSPACE_INACTIVE
      icon.highlight_color=$WORKSPACE_ACTIVE
      icon.padding_left=10
      icon.padding_right=10
      display=$m
      padding_left=2
      padding_right=2
      label.padding_right=20
      label.color=$WORKSPACE_INACTIVE
      label.highlight_color=$WHITE
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      background.color=$TRANSPARENT
      background.border_color=$WORKSPACE_BORDER_INACTIVE
      background.border_width=1
      background.corner_radius=6
      script="$PLUGIN_DIR/space.sh"
      click_script="aerospace workspace $sid"
    )

    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}" \
               --subscribe space.$sid mouse.clicked aerospace_workspace_change window_focus application_launched application_terminated application_activated

    # Initial population of app icons
    apps=$(aerospace list-windows --workspace $sid | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app
      do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi

    sketchybar --set space.$sid label="$icon_strip"
  done

  # Only show occupied workspaces or focused empty workspace
  focused_workspace=$(aerospace list-workspaces --focused)

  # First hide all empty workspaces
  for i in $(aerospace list-workspaces --monitor $m --empty); do
    sketchybar --set space.$i display=0
  done

  # Then show the focused workspace even if it's empty
  if [ -n "$focused_workspace" ]; then
    sketchybar --set space.$focused_workspace \
      display=$m \
      icon.color=$WORKSPACE_ACTIVE \
      label.color=$WHITE \
      background.drawing=on \
      background.border_color=$WORKSPACE_BORDER_ACTIVE \
      background.border_width=2 \
      background.color=$BACKGROUND_1
  fi
done

# Create + button for creating new workspaces
space_creator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  click_script="aerospace create-workspace && sketchybar --update"
  background.color=$TRANSPARENT
  background.corner_radius=6
  background.border_width=1
  background.border_color=$WORKSPACE_BORDER_INACTIVE
)

sketchybar --add item space_creator left               \
           --set space_creator "${space_creator[@]}"   \
           --subscribe space_creator aerospace_workspace_change

# Highlight the initially active workspace
current_workspace=$(aerospace list-workspaces --focused)
if [ -n "$current_workspace" ]; then
  sketchybar --set space.$current_workspace \
    icon.highlight=true \
    icon.color=$WORKSPACE_ACTIVE \
    label.highlight=true \
    label.color=$WHITE \
    background.color=$BACKGROUND_1 \
    background.border_color=$WORKSPACE_BORDER_ACTIVE \
    background.drawing=on \
    background.border_width=2
fi
