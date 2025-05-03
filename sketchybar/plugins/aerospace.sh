#!/usr/bin/env bash

# Script to handle aerospace workspace highlighting
# Make sure it's executable with:
# chmod +x /Users/ric/.dotfiles/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi