#!/bin/bash

# ======================================================
# Enhanced Battery Plugin
# ======================================================
# Features:
# - Improved battery level indicators with smooth color transitions
# - Better charging animation
# - Critical battery alerts
# - Desktop computer detection
# - Click to show detailed battery information
# ======================================================

source "$CONFIG_DIR/colors.sh"

# Get battery information
PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"
TIME_REMAINING="$(pmset -g batt | grep -Eo "\d+:\d+")"

# If no battery is found (e.g., desktop Mac), show desktop icon instead
if [ "$PERCENTAGE" = "" ]; then
  sketchybar --set "$NAME" icon="􀙧" label="Desktop" icon.color=$NORMAL
  exit 0
fi

# More granular battery level indicators with improved colors and icons
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
    # Add pulsing visual alert for very low battery
    sketchybar --set "$NAME" background.color=0x55ff0000 background.border_color=$RED
    sleep 0.3
    sketchybar --set "$NAME" background.color=$TRANSPARENT background.border_color=$TRANSPARENT
    sleep 0.3
    sketchybar --set "$NAME" background.color=0x55ff0000 background.border_color=$RED
    sleep 0.3
    sketchybar --set "$NAME" background.color=$TRANSPARENT background.border_color=$TRANSPARENT
    ;;
esac

# Enhanced charging animation
if [[ "$CHARGING" != "" ]]; then
  # Change color to indicate charging
  ICON_COLOR=$YELLOW
  
  # Alternate between two charging icons for animation effect
  if [[ $((PERCENTAGE % 2)) -eq 0 ]]; then
    ICON="􀢋"
  else
    ICON="􀢌"
  fi
fi

# Format label with percentage and time if available
if [[ "$TIME_REMAINING" != "" && "$CHARGING" == "" && "$PERCENTAGE" -lt 100 ]]; then
  LABEL="${PERCENTAGE}% (${TIME_REMAINING})"
else
  LABEL="${PERCENTAGE}%"
fi

# Update the battery item with all the information
sketchybar --set "$NAME" icon="$ICON" label="$LABEL" icon.color=${ICON_COLOR}

# Add click action to show battery info popup
sketchybar --set "$NAME" click_script="
  BATTERY_INFO=\$(pmset -g batt)
  PERCENTAGE=\$(echo \"\$BATTERY_INFO\" | grep -Eo \"\\d+%\" | cut -d% -f1)
  CHARGING=\$(echo \"\$BATTERY_INFO\" | grep 'AC Power')
  
  if [ \"\$CHARGING\" != \"\" ]; then
    CHARGING_STATUS=\"Charging\"
  else
    CHARGING_STATUS=\"Battery\"
  fi
  
  TIME_LEFT=\$(echo \"\$BATTERY_INFO\" | grep -Eo \"\\d+:\\d+\")
  if [ \"\$TIME_LEFT\" != \"\" ]; then
    if [ \"\$CHARGING\" != \"\" ]; then
      TIME_INFO=\"Time to full: \$TIME_LEFT\"
    else
      TIME_INFO=\"Time left: \$TIME_LEFT\"
    fi
  else
    TIME_INFO=\"\"
  fi
  
  CYCLES=\$(system_profiler SPPowerDataType | grep 'Cycle Count' | awk '{print \$3}')
  
  sketchybar --set \"\$NAME\" popup.drawing=toggle
  
  sketchybar --remove '/battery.details.*/'
  
  sketchybar --add item battery.details.percentage popup.\$NAME \
             --set battery.details.percentage label=\"Battery: \$PERCENTAGE%\" \
             --add item battery.details.status popup.\$NAME \
             --set battery.details.status label=\"Status: \$CHARGING_STATUS\" 
             
  if [ \"\$TIME_INFO\" != \"\" ]; then
    sketchybar --add item battery.details.time popup.\$NAME \
               --set battery.details.time label=\"\$TIME_INFO\"
  fi
  
  if [ \"\$CYCLES\" != \"\" ]; then
    sketchybar --add item battery.details.cycles popup.\$NAME \
               --set battery.details.cycles label=\"Cycle count: \$CYCLES\"
  fi
"
