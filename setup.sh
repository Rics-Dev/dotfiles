# Ric's setup.sh

# Function to check if a command exists
#command_exists() {
#  command -v "$1" >/dev/null 2>&1
#}

# Function to install a package using the appropriate package manager
#install_package() {
#  local package_manager="$1"
#  local package_name="$2"

#  case "$package_manager" in
#  apt-get)
#    sudo apt-get install -y "$package_name"
#    ;;
#  yum)
#    sudo yum install -y "$package_name"
#    ;;
#  pacman)
#    sudo pacman -S --noconfirm "$package_name"
#    ;;
#  *)
#    echo "Error: Package manager not found. Please install $package_name manually."
#    exit 1
#    ;;
#  esac # End of case statement
#}

# Setup fastfetch
#echo "Setting up fastfetch..."
#
#if command_exists fastfetch; then
#  echo "fastfetch is already installed."
#else
#  echo "Installing fastfetch..."
#  if command_exists apt-get || command_exists yum || command_exists pacman; then
#    install_package apt-get fastfetch || install_package yum fastfetch || install_package pacman fastfetch
#  else
#    echo "Error: Package manager not found. Please install fastfetch manually."
#    exit 1
#  fi
#
#  # Check if installation was successful
#  if ! command_exists fastfetch; then
#    echo "Error: fastfetch installation failed. Exiting."
#    exit 1
#  fi
#fi

# Setup zsh
#echo "Setting up zsh..."
#
#if command_exists zsh; then
#  echo "zsh is already installed."
#else
#  echo "Installing zsh..."
#  if command_exists apt-get || command_exists yum || command_exists pacman; then
#    install_package apt-get zsh || install_package yum zsh || install_package pacman zsh
#  else
#    echo "Error: Package manager not found. Please install zsh manually."
#    exit 1
#  fi
#
#  # Check if installation was successful
#  if ! command_exists zsh; then
#    echo "Error: zsh installation failed. Exiting."
#    exit 1
#  fi
#fi

# Create symlink for alacritty
rm -rf ~/.config/alacritty
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
echo "alacritty link created"

# create symlink for bash
rm ~/.bashrc
rm ~/.bash_profile
ln -s ~/.dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/.dotfiles/bash/.bash_profile ~/.bash_profile
echo "bash link created"

# Create symbolic link for fastfetch
rm -rf ~/.config/fastfetch
ln -s ~/.dotfiles/fastfetch ~/.config/fastfetch
echo "fastfetch link created"

# Create symbolic link for fish
rm -rf ~/.config/fish
ln -s ~/.dotfiles/fish ~/.config/fish
echo "fish link created"

# Create symbolic link for ghostty
rm -rf ~/.config/ghostty
ln -s ~/.dotfiles/ghostty ~/.config/ghostty
echo "ghostty link created"

#setup neovide
#rm -rf ~/.config/neovide
#ln -s ~/.dotfiles/neovide ~/.config/neovide
#echo "neovide link created"

#create symlink for nushell
#rm -rf ~/.config/nushell
#ln -s ~/.dotfiles/nushell ~/.config/nushell
#echo "nushell symlink created"

#setup nvim
rm -rf ~/.config/nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim
echo "neovim link created"

# Setup Starship
rm ~/.config/starship.toml
ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
echo "starship link created"

#create symlink for tmux
rm -rf ~/.config/tmux
ln -s ~/.dotfiles/tmux ~/.config/tmux
echo "tmux symlink created"

#create symlink for zellij
rm -rf ~/.config/zellij
ln -s ~/.dotfiles/zellij ~/.config/zellij
echo "zellij symlink created"
#setup symlink for vscode
# rm -rf ~/.config/Code/User/settings.json
# ln -s ~/.dotfiles/vscode/settings.json ~/.config/Code/User/settings.json

# Create symbolic link for WezTerm
rm ~/.wezterm.lua
ln -s ~/.dotfiles/wezterm/wezterm.lua ~/.wezterm.lua
echo "wezterm link created"

#create symlink for yazi
rm -rf ~/.config/yazi
ln -s ~/.dotfiles/yazi ~/.config/yazi
echo "Yazi symlink created"

#create symlink for Zed
rm -rf ~/.config/zed
ln -s ~/.dotfiles/zed ~/.config/zed
echo "Zed symlink created"

# Create symbolic link for zsh
#rm ~/.zshrc
#ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
#echo "zsh link created"
