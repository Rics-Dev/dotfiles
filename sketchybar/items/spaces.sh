#!/bin/sh

# Initialize events
sketchybar --add event aerospace_workspace_change \
           --add event window_focus \
           --add event application_launched \
           --add event application_terminated \
           --add event application_activated

# Base space configuration
space_config() {
  local sid=$1
  local display=$2
  local space=(
    space="$sid"
    icon="$sid"
    icon.color=$WORKSPACE_INACTIVE
    icon.highlight_color=$WORKSPACE_ACTIVE
    icon.padding_left=10
    icon.padding_right=10
    display="$display"
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
  echo "${space[@]}"
}

# Process each monitor and its workspaces
for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor "$m"); do
    # Create and configure space
    eval "space=($(space_config "$i" "$m"))"
    
    sketchybar --add space "space.$i" left \
               --set "space.$i" "${space[@]}" \
               --subscribe "space.$i" mouse.clicked aerospace_workspace_change window_focus application_launched application_terminated application_activated

    # Set initial app icons
    apps=$(aerospace list-windows --workspace "$i" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
    icon_strip=" "
    if [ -n "${apps}" ]; then
      while IFS= read -r app; do
        [ -n "$app" ] && icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi
    sketchybar --set "space.$i" label="$icon_strip"
  done
done

# Initial workspace setup
focused_workspace=$(aerospace list-workspaces --focused)
if [ -n "$focused_workspace" ]; then
  for m in $(aerospace list-monitors | awk '{print $1}'); do
    # Hide empty workspaces
    for i in $(aerospace list-workspaces --monitor "$m" --empty); do
      sketchybar --set "space.$i" display=0
    done
    
    # Highlight focused workspace
    sketchybar --set "space.$focused_workspace" \
               display="$m" \
               icon.color=$WORKSPACE_ACTIVE \
               label.color=$WHITE \
               background.drawing=on \
               background.border_color=$WORKSPACE_BORDER_ACTIVE \
               background.border_width=2 \
               background.color=$BACKGROUND_1
  done
fi

# Configure space creator
sketchybar --add item space_creator left \
           --set space_creator "${space_creator[@]}" \
           --subscribe space_creator aerospace_workspace_change
