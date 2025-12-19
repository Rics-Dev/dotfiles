#!/usr/bin/env bash

workspace=$(hyprctl activewindow -j | jq -r '.workspace' | jq -r '.name')

if [[ "$workspace" == "special:magic" ]]; then
  echo '{"text":"","class":"special","tooltip":"Special Workspace"}'
else
  echo '{"text":"","class":"not-special"}'
fi
