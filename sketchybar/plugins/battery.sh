#!/bin/bash


source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

# If no battery is found (e.g., desktop Mac), exit gracefully
if [ "$PERCENTAGE" = "" ]; then
  # Set a desktop computer icon instead of hiding
  sketchybar --set "$NAME" icon="􀙧" label="Desktop" icon.color=$NORMAL
  exit 0
fi

# More granular battery level indicators with improved colors
case ${PERCENTAGE} in
  9[0-9]|100)
    ICON="􀛨"
    ICON_COLOR=$BATTERY_100
    ;;
  8[0-9])
    ICON="􀛨"
    ICON_COLOR=$BATTERY_75
    ;;
  7[0-9])
    ICON="􀺸"
    ICON_COLOR=$BATTERY_75
    ;;
  6[0-9])
    ICON="􀺸"
    ICON_COLOR=$BATTERY_50
    ;;
  5[0-9])
    ICON="􀺶"
    ICON_COLOR=$BATTERY_50
    ;;
  4[0-9])
    ICON="􀺶"
    ICON_COLOR=$BATTERY_50
    ;;
  3[0-9])
    ICON="􀛩"
    ICON_COLOR=$BATTERY_25
    ;;
  2[0-9])
    ICON="􀛩"
    ICON_COLOR=$BATTERY_25
    ;;
  1[0-9])
    ICON="􀛪"
    ICON_COLOR=$BATTERY_0
    ;;
  [0-9])
    ICON="􀛪"
    ICON_COLOR=$BATTERY_0
    # Add visual alert for very low battery
    sketchybar --set "$NAME" background.color=0x55ff0000 background.border_color=$RED
    sleep 0.5
    sketchybar --set "$NAME" background.color=$TRANSPARENT background.border_color=$TRANSPARENT
    ;;
esac

# Charging icon with animation
if [[ "$CHARGING" != "" ]]; then
  ICON="􀢋"
  ICON_COLOR=$YELLOW
  
  # Add a subtle charging animation
  if [[ $((PERCENTAGE % 2)) -eq 0 ]]; then
    ICON="􀢋"
  else
    ICON="􀢌"
  fi
fi

# Format label based on availability of time remaining
LABEL="${PERCENTAGE}%"

# Update the battery item with all the information
sketchybar --set "$NAME" icon="$ICON" label="$LABEL" icon.color=${ICON_COLOR}

# Add click action to show battery info popup
sketchybar --set "$NAME" click_script="
  pmset -g batt | grep -v 'Battery' | cut -c 1-60 | 
  xargs -0 notification_center post 'Battery Info' 2>/dev/null"
