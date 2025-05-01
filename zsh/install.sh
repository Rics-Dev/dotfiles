#!/bin/bash

# Fish to Zsh Configuration Installation Script

echo "Installing Zsh configuration..."

# Create directories if they don't exist
mkdir -p ~/.dotfiles/zsh

# Copy configuration files
cp -v "$(dirname "$0")/.zshrc" ~/.dotfiles/zsh/
cp -v "$(dirname "$0")/aliases.zsh" ~/.dotfiles/zsh/

# Create symlink to .zshrc
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc

# Check for required dependencies
echo "\nChecking for required dependencies..."

dependencies=("zsh" "starship" "zoxide" "atuin" "eza" "fzf" "bat" "fd" "ripgrep")
missing_deps=()

for dep in "${dependencies[@]}"; do
  if ! command -v "$dep" &> /dev/null; then
    missing_deps+=("$dep")
  else
    echo "✓ $dep is installed"
  fi
done

if [ ${#missing_deps[@]} -ne 0 ]; then
  echo "\nThe following dependencies are missing:"
  for dep in "${missing_deps[@]}"; do
    echo "- $dep"
  done
  echo "\nYou can install them with Homebrew:"
  echo "brew install ${missing_deps[*]}"
fi

echo "\nZsh configuration has been installed."
echo "To use Zsh as your default shell, run: chsh -s $(which zsh)"
echo "To load the new configuration, restart your terminal or run: source ~/.zshrc"