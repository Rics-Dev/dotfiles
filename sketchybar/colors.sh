#!/bin/bash

### Enhanced Catppuccin Theme with improved visual hierarchy
export BLACK=0xff181926
export WHITE=0xffcad3f5
export RED=0xffed8796
export GREEN=0xffa6da95
export BLUE=0xff8aadf4
export YELLOW=0xffeed49f
export ORANGE=0xfff5a97f
export MAGENTA=0xffc6a0f6
export GREY=0xff939ab7
export TRANSPARENT=0x00000000

# Enhanced background colors with improved contrast for better legibility
export BG0=0xff1e1e2e      # Solid background
export BG1=0x903c3e4f      # Semi-transparent background - increased opacity
export BG2=0x90494d64      # Semi-transparent border - increased opacity

# Additional colors for visual depth and interaction states
export HIGHLIGHT=0xff89dceb # Cyan for highlights
export SUBTLE=0xff585b70    # Subtle accent
export LAVENDER=0xffb4befe  # Lavender for special highlights
export MAROON=0xffeba0ac    # Maroon for warnings/alerts
export PEACH=0xfffab387     # Peach for notifications
export TEAL=0xff94e2d5      # Teal for success states
export MAUVE=0xffcba6f7     # Mauve for active states

# Battery indicators with improved color gradient
export BATTERY_100=0xffa6da95  # Green - full
export BATTERY_75=0xffb4befe   # Lavender - good
export BATTERY_50=0xffeed49f   # Yellow - medium
export BATTERY_25=0xfff5a97f   # Orange - low
export BATTERY_0=0xffed8796    # Red - critical

# General bar colors with improved contrast and visual appeal
export BAR_COLOR=0x801e1e2e          # Semi-transparent for cleaner look
export BAR_BORDER_COLOR=0xaa494d64   # Slightly more visible border
export BACKGROUND_1=0x903c3e4f       # Improved opacity for better contrast
export BACKGROUND_2=0x90494d64       # Improved opacity for better contrast
export ICON_COLOR=$WHITE             # Keep icons white for legibility
export LABEL_COLOR=$WHITE            # Keep labels white for legibility
export HIGHLIGHT_COLOR=$BLUE         # Color for highlighted elements
export POPUP_BACKGROUND_COLOR=0xee1e1e2e  # More opaque for better readability
export POPUP_BORDER_COLOR=$LAVENDER      # Lavender border for popups
export SHADOW_COLOR=0xaa181926           # Semi-transparent shadow

# Status indicators
export NORMAL=$GREEN
export WARNING=$YELLOW
export CRITICAL=$RED

# New themed colors for additional modules
export WEATHER_ICON_COLOR=$BLUE
export CPU_COLOR=$MAUVE
export MEMORY_COLOR=$PEACH
export NETWORK_COLOR=$TEAL
export MUSIC_COLOR=$LAVENDER
