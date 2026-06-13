#!/usr/bin/env bash

theme="$1"

unlink ~/dotfiles/ghostty/themes/current        ; ln -sf "$HOME/dotfiles/ghostty/themes/$theme"         ~/dotfiles/ghostty/themes/current
unlink ~/dotfiles/alacritty/themes/current.toml ; ln -sf "$HOME/dotfiles/alacritty/themes/$theme.toml"  ~/dotfiles/alacritty/themes/current.toml
unlink ~/dotfiles/helix/themes/current.toml     ; ln -sf "$HOME/dotfiles/helix/themes/$theme.toml"      ~/dotfiles/helix/themes/current.toml
unlink ~/dotfiles/nvim/lua/themes/current       ; ln -sf "$HOME/dotfiles/nvim/lua/themes/$theme"        ~/dotfiles/nvim/lua/themes/current

echo "Theme switched to $theme"

