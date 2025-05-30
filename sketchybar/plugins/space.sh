#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Store the previous focused workspace to track changes
PREV_FOCUSED=""

update_space_highlighting() {
    # Extract workspace name from NAME (format: space.X)
    WORKSPACE_ID=${NAME#*.}

    # Get the currently focused workspace (refreshed)
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

    if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
        # This is the active workspace - always highlight it correctly
        sketchybar --set $NAME \
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
        # Check if this workspace has windows
        HAS_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE_ID" | wc -l | xargs)

        if [ "$HAS_WINDOWS" -gt 0 ]; then
            # This workspace has windows - show it with inactive styling
            sketchybar --set $NAME \
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
            # This workspace is empty and not focused - hide it
            sketchybar --set $NAME \
                display=0 \
                icon.highlight=false \
                icon.color=$WORKSPACE_INACTIVE
        fi
    fi
}

mouse_clicked() {
    WORKSPACE_ID=${NAME#*.}

    if [ "$BUTTON" = "right" ]; then
        # Right click - could add context menu here
        echo "Right clicked workspace $WORKSPACE_ID"
    else
        if [ "$MODIFIER" = "shift" ]; then
            # Shift+click to rename workspace
            SPACE_LABEL="$(osascript -e "return (text returned of (display dialog \"Give a name to workspace $WORKSPACE_ID:\" default answer \"\" with icon note buttons {\"Cancel\", \"Continue\"} default button \"Continue\"))")"
            if [ $? -eq 0 ]; then
                if [ "$SPACE_LABEL" = "" ]; then
                    sketchybar --set $NAME icon="$WORKSPACE_ID"
                else
                    sketchybar --set $NAME icon="$WORKSPACE_ID ($SPACE_LABEL)"
                fi
            fi
        else
            # Normal click - switch to workspace
            aerospace workspace $WORKSPACE_ID
        fi
    fi
}

update_all_workspaces() {
    # Refresh focused workspace info
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

    # First, handle the previously focused workspace if it exists and is different
    if [ -n "$PREV_FOCUSED" ] && [ "$PREV_FOCUSED" != "$FOCUSED_WORKSPACE" ]; then
        # Check if previous workspace has windows
        PREV_HAS_WINDOWS=$(aerospace list-windows --workspace "$PREV_FOCUSED" | wc -l | xargs)

        if [ "$PREV_HAS_WINDOWS" -eq 0 ]; then
            # Previous workspace was empty, hide it now that we've switched away
            sketchybar --set space.$PREV_FOCUSED \
                display=0 \
                icon.highlight=false \
                icon.color=$WORKSPACE_INACTIVE \
                label.highlight=false
        else
            # Previous workspace has windows, just make it inactive
            sketchybar --set space.$PREV_FOCUSED \
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

    # Update all workspaces visibility based on window content
    for ws in $(aerospace list-workspaces); do
        if [ "$ws" != "$FOCUSED_WORKSPACE" ]; then
            # Check if this workspace has windows
            HAS_WINDOWS=$(aerospace list-windows --workspace "$ws" | wc -l | xargs)

            if [ "$HAS_WINDOWS" -gt 0 ]; then
                # This workspace has windows - show it with inactive styling
                sketchybar --set space.$ws \
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
                # This workspace is empty and not focused - hide it
                sketchybar --set space.$ws display=0
            fi
        fi
    done

    # Always show the currently focused workspace with proper highlighting
    sketchybar --set space.$FOCUSED_WORKSPACE \
        display=1 \
        icon.highlight=true \
        icon.color=$WORKSPACE_ACTIVE \
        label.highlight=true \
        label.color=$WHITE \
        background.color=$BACKGROUND_1 \
        background.border_color=$WORKSPACE_BORDER_ACTIVE \
        background.border_width=2 \
        background.drawing=on

    # Store current workspace as previous for next event
    PREV_FOCUSED=$FOCUSED_WORKSPACE
}

case "$SENDER" in
    "mouse.clicked") 
        mouse_clicked
        ;;
    "aerospace_workspace_change")
        # Update all workspaces when switching workspaces
        update_all_workspaces
        update_space_highlighting
        ;;
    "window_focus"|"application_launched"|"application_terminated"|"application_activated")
        # Update all workspaces when window state changes
        update_all_workspaces
        update_space_highlighting
        ;;
    "forced"|"space_change"|*)
        update_space_highlighting
        ;;
esac

