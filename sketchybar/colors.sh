#!/bin/bash

# Minimalist Dark Theme Color Palette
# Focus on darker tones with subtle accents

export BLACK=0xff000000
export WHITE=0xfffffffa
export RED=0xff785A5A
export GREEN=0xff5A785A
export BLUE=0xff5A5A78
export YELLOW=0xff787858
export ORANGE=0xff786E5A
export MAGENTA=0xff785A78
export GREY=0xff444444
export TRANSPARENT=0x00000000

# Dark background colors with minimal opacity
export BG0=0xff0a0a0a      # Almost black solid background
export BG1=0x60181818      # Very subtle semi-transparent background
export BG2=0x40202020      # Even more subtle borders

# Minimal accent colors
export HIGHLIGHT=0xff5A5A78 # Subtle blue for highlights
export SUBTLE=0xff333333    # Very dark subtle accent
export LAVENDER=0xff5A5A78  # Matching highlight for consistency
export MAROON=0xff785A5A    # Muted red for warnings
export PEACH=0xff786E5A     # Muted peach for notifications
export TEAL=0xff5A7870      # Muted teal for success states
export MAUVE=0xff785A78     # Muted purple for active states

# Battery indicators with more subtle colors
export BATTERY_100=0xff5A785A  # Muted green - full
export BATTERY_75=0xff5A6E78   # Muted cyan - good
export BATTERY_50=0xff787858   # Muted yellow - medium
export BATTERY_25=0xff786E5A   # Muted orange - low
export BATTERY_0=0xff785A5A    # Muted red - critical

# Bar colors with minimal approach
export BAR_COLOR=0x60050505          # Very dark semi-transparent for minimal look
export BAR_BORDER_COLOR=0x20202020   # Almost invisible border
export BACKGROUND_1=0x40181818       # Very subtle background for modules
export BACKGROUND_2=0x30202020       # Even more subtle border
export ICON_COLOR=$WHITE             # Keep icons visible but not bright
export LABEL_COLOR=$WHITE            # Keep labels visible but not bright
export HIGHLIGHT_COLOR=$BLUE         # Subtle highlight
export POPUP_BACKGROUND_COLOR=0xaa0a0a0a  # Dark popup background
export POPUP_BORDER_COLOR=0x40303030      # Subtle popup border
export SHADOW_COLOR=0x20000000            # Minimal shadow

# Status indicators with clear semantic meaning but muted colors
export NORMAL=$GREEN
export WARNING=$YELLOW
export CRITICAL=$RED

# New themed colors for additional modules
export WEATHER_ICON_COLOR=$BLUE
export CPU_COLOR=$MAUVE
export MEMORY_COLOR=$PEACH
export NETWORK_COLOR=$TEAL
export MUSIC_COLOR=$LAVENDER

# Hover and interaction state colors (more minimal)
export HOVER_BACKGROUND=0x40303030     # Very subtle hover state
export ACTIVE_BACKGROUND=0x60252525    # Subtle active/pressed state
export HOVER_BORDER=0x40404040         # Subtle hover border
export ACTIVE_BORDER=0x605A5A78        # Subtle highlight border

# Animation colors for transitions
export TRANSITION_FROM=0x00181818      # Start with transparent
export TRANSITION_TO=0x40181818        # End with subtle semi-transparent
