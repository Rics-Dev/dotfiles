#!/bin/bash

# Get current date and time in more detailed format
DATE=$(date "+%a %b %d")
TIME=$(date "+%H:%M")

# Format the display
sketchybar --set "$NAME" label="$DATE $TIME"
