#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Get current aerospace workspace information
AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSPACE_FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
AEROSPACE_PREV_WORKSPACE=$PREV_WORKSPACE
AEROSPACE_WORKSPACES_FOCUSED_MONITOR=$(aerospace list-workspaces --monitor focused --empty no)
AEROSPACE_EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor focused --empty)

# Debug logging
echo "[$(date +%H:%M:%S)] space_windows.sh - SENDER: $SENDER, FOCUSED: $AEROSPACE_FOCUSED_WORKSPACE, PREV: $AEROSPACE_PREV_WORKSPACE" >> /tmp/sketchybar_debug.log

# Function to reload workspace icons based on windows
reload_workspace_icon() {
    local workspace="$1"
    apps=$(aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    icon_strip=" "
    if [ -n "${apps}" ]; then
        while IFS= read -r app; do
            if [ -n "$app" ]; then
                icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
            fi
        done <<< "${apps}"
    else
        icon_strip=" —"
    fi

    sketchybar --animate sin 10 --set "space.$workspace" label="$icon_strip"
}

# Function to update workspace highlighting
update_workspace_highlighting() {
    local focused="$1"
    local previous="$2"
    
    # Update focused workspace
    if [ -n "$focused" ]; then
        sketchybar --set "space.$focused" \
            icon.highlight=true \
            icon.color=$WORKSPACE_ACTIVE \
            label.highlight=true \
            label.color=$WHITE \
            background.color=$BACKGROUND_1 \
            background.border_color=$WORKSPACE_BORDER_ACTIVE \
            background.drawing=on \
            background.border_width=2
    fi
    
    # Update previous workspace
    if [ -n "$previous" ] && [ "$previous" != "$focused" ]; then
        sketchybar --set "space.$previous" \
            icon.highlight=false \
            icon.color=$WORKSPACE_INACTIVE \
            label.highlight=false \
            label.color=$WORKSPACE_INACTIVE \
            background.color=$TRANSPARENT \
            background.border_color=$WORKSPACE_BORDER_INACTIVE \
            background.border_width=1
    fi

    # Update all other workspaces to ensure consistent state
    for workspace in $(aerospace list-workspaces); do
        if [ "$workspace" != "$focused" ] && [ "$workspace" != "$previous" ]; then
            sketchybar --set "space.$workspace" \
                icon.highlight=false \
                icon.color=$WORKSPACE_INACTIVE \
                label.highlight=false \
                label.color=$WORKSPACE_INACTIVE \
                background.color=$TRANSPARENT \
                background.border_color=$WORKSPACE_BORDER_INACTIVE \
                background.border_width=1
        fi
    done
}

# Function to update workspace visibility
update_workspace_visibility() {
    local focused_monitor=$AEROSPACE_FOCUSED_MONITOR

    # Show workspaces with windows on focused monitor
    for workspace in $AEROSPACE_WORKSPACES_FOCUSED_MONITOR; do
        sketchybar --set "space.$workspace" display=$focused_monitor
    done

    # Always show active workspace
    if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
        sketchybar --set "space.$AEROSPACE_FOCUSED_WORKSPACE" display=$focused_monitor
    fi

    # Make empty workspaces visible but with different styling
    for workspace in $AEROSPACE_EMPTY_WORKSPACES; do
        if [ "$workspace" != "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
            sketchybar --set "space.$workspace" \
                display=$focused_monitor \
                icon.color=$WORKSPACE_INACTIVE \
                label.color=$WORKSPACE_INACTIVE \
                background.drawing=off
        fi
    done
}

# Handle different events
case "$SENDER" in
    "aerospace_workspace_change"|"forced")
        # Reload icons for affected workspaces
        if [ -n "$AEROSPACE_PREV_WORKSPACE" ]; then
            reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
        fi

        if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
            reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"
        fi

        # Update highlighting
        update_workspace_highlighting "$AEROSPACE_FOCUSED_WORKSPACE" "$AEROSPACE_PREV_WORKSPACE"

        # Update visibility
        update_workspace_visibility

        # Update space creator icon color based on activity
        if [ -n "$AEROSPACE_WORKSPACES_FOCUSED_MONITOR" ]; then
            sketchybar --set space_creator icon.color=$WORKSPACE_ACTIVE
        else
            sketchybar --set space_creator icon.color=$WORKSPACE_INACTIVE
        fi
        ;;
    "window_focus"|"application_activated"|"application_terminated"|"application_launched")
        # When window focus changes, refresh the icons
        for workspace in $(aerospace list-workspaces); do
            reload_workspace_icon "$workspace"
        done
        ;;
    *)
        # Default case - just update the focused workspace
        if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
            reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"
            update_workspace_highlighting "$AEROSPACE_FOCUSED_WORKSPACE" ""
        fi
        ;;
esac

