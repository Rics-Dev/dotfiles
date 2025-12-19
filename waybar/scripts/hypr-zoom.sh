#!/usr/bin/env bash

state=$(hyprctl activewindow -j | jq -r '.fullscreen')

if [ "$state" = "1" ]; then
  echo '{"text":"","class":"zoomed","tooltip":"Window Zoomed"}'
else
  echo '{"text":"","class":"not-zoomed"}'
fi
