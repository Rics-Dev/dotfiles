#!/bin/bash

# ======================================================
# Enhanced WiFi Plugin
# ======================================================
# Features:
# - Dynamic signal strength indicators
# - Shows SSID when connected
# - Shows connection status (on/off)
# - Click to toggle WiFi
# ======================================================

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Get current WiFi information
AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
WIFI_INFO=$($AIRPORT -I)
SSID=$(echo "$WIFI_INFO" | awk -F:  '($1 ~ "^ *SSID$"){print $2}' | xargs)
RSSI=$(echo "$WIFI_INFO" | awk -F:  '($1 ~ "^ *agrCtlRSSI$"){print $2}' | xargs)

# Function to update the WiFi icon
update_wifi() {
  # Check if WiFi is enabled
  if [ -z "$SSID" ]; then
    # WiFi is off or disconnected
    sketchybar --set $NAME icon=$WIFI_DISCONNECTED \
                          icon.color=$GREY \
                          label="Disconnected"
    return
  fi

  # WiFi is on - determine signal strength
  if [ "$RSSI" -gt -50 ]; then
    # Strong signal
    ICON=$WIFI_HIGH
    COLOR=$NORMAL
  elif [ "$RSSI" -gt -70 ]; then
    # Medium signal
    ICON=$WIFI_MEDIUM
    COLOR=$WARNING
  else
    # Weak signal
    ICON=$WIFI_LOW
    COLOR=$CRITICAL
  fi

  # Update the item with all information
  sketchybar --set $NAME icon=$ICON \
                        icon.color=$COLOR \
                        label="$SSID"
}

# Handle click events
handle_click() {
  if [ "$BUTTON" = "right" ]; then
    # Right-click: Open Network Preferences
    open /System/Library/PreferencePanes/Network.prefPane
  else
    # Left-click: Toggle WiFi
    if [ -z "$SSID" ]; then
      # WiFi is off, turn on
      networksetup -setairportpower en0 on
    else
      # WiFi is on, toggle
      if [ "$MODIFIER" = "shift" ]; then
        # With Shift key pressed, turn off
        networksetup -setairportpower en0 off
      else
        # Without Shift, just show available networks
        networksetup -setairportpower en0 off
        sleep 1
        networksetup -setairportpower en0 on
      fi
    fi
  fi
}

case "$SENDER" in
  "wifi_change") update_wifi ;;
  "system_woke") update_wifi ;;
  "mouse.clicked") handle_click ;;
  *) update_wifi ;;
esac
