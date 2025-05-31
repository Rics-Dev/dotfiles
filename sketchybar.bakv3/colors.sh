#!/bin/bash

# Premium Dark Theme Color Palette
# Elegant dark theme with premium accents

export BLACK=0xff000000
export WHITE=0xfff7f7fa       # Brighter white for better contrast
export RED=0xffec5f67         # More vibrant red for warnings
export GREEN=0xff99c794       # Richer green for success states
export BLUE=0xff6699cc        # More saturated blue for highlights
export YELLOW=0xfff9ae58      # Brighter yellow for notifications
export ORANGE=0xfff99157      # More vibrant orange for cautions
export MAGENTA=0xffc594c5     # Vibrant purple for special states
export GREY=0xff65737e        # Slightly warmer grey
export TRANSPARENT=0x00000000

# Sophisticated background colors with subtle opacity
export BG0=0xff1b2b34         # Rich dark blue-black base
export BG1=0x701d2d3a         # Subtle semi-transparent darker background
export BG2=0x50343d46         # Elegant borders with better transparency

# Premium accent colors
export HIGHLIGHT=0xff6699cc    # Brighter blue highlight
export SUBTLE=0xff4f5b66       # Slightly lighter subtle accent
export LAVENDER=0xffa48ade     # Brighter lavender accent
export MAROON=0xffe06c75       # More vibrant red for warnings
export PEACH=0xfff99157        # Brighter peach for notifications
export TEAL=0xff5fb3b3         # More vibrant teal for success
export MAUVE=0xffc594c5        # Brighter purple for active states

# Workspace highlighting colors
export WORKSPACE_ACTIVE=0xff6699cc      # Brighter blue for active workspace
export WORKSPACE_INACTIVE=0xff4f5b66    # Slightly lighter grey for inactive workspaces
export WORKSPACE_HOVER=0xff65737e       # Medium grey with blue undertone for hover
export WORKSPACE_BORDER_ACTIVE=0xff6699cc    # Active workspace border
export WORKSPACE_BORDER_INACTIVE=0x3065737e  # Slightly more visible inactive border

# Battery indicators with premium colors
export BATTERY_100=0xff99c794  # Vibrant green - full
export BATTERY_75=0xff6699cc   # Cool blue - good
export BATTERY_50=0xfff9ae58   # Bright yellow - medium
export BATTERY_25=0xfff99157   # Vibrant orange - low
export BATTERY_0=0xffec5f67    # Vibrant red - critical

# Bar colors with premium design
export BAR_COLOR=0x801b2b34          # Rich dark blue-black semi-transparent
export BAR_BORDER_COLOR=0x30343d46   # More visible subtle border
export BACKGROUND_1=0x801d2d3a       # Slightly more opaque background for modules
export BACKGROUND_2=0x60343d46       # More visible border for better definition
export ICON_COLOR=$WHITE             # Clean white icons
export LABEL_COLOR=$WHITE            # Clean white labels
export HIGHLIGHT_COLOR=$WORKSPACE_ACTIVE    # Use workspace active color for consistency
export POPUP_BACKGROUND_COLOR=0xdd1b2b34   # Rich dark blue-black popup background
export POPUP_BORDER_COLOR=0x50343d46       # Premium popup border
export SHADOW_COLOR=0x30000000             # Subtle shadow for depth

# Status indicators with premium semantic colors
export NORMAL=$GREEN
export WARNING=$YELLOW
export CRITICAL=$RED

# Hover and interaction state colors
export HOVER_BACKGROUND=0x50343d46     # Premium hover state
export ACTIVE_BACKGROUND=0x701d2d3a    # Subtle active/pressed state
export HOVER_BORDER=0x5065737e         # Premium hover border
export ACTIVE_BORDER=0x706699cc        # Refined highlight border

# Animation colors for transitions
export TRANSITION_FROM=0x001d2d3a      # Start with transparent
export TRANSITION_TO=0x601d2d3a        # End with sophisticated semi-transparent
