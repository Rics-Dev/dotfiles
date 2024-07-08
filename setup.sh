# Ric's setup.sh

# Function to check if a command exists
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# Function to install a package using the appropriate package manager
install_package() {
	local package_manager="$1"
	local package_name="$2"

	case "$package_manager" in
	apt-get)
		sudo apt-get install -y "$package_name"
		;;
	yum)
		sudo yum install -y "$package_name"
		;;
	pacman)
		sudo pacman -S --noconfirm "$package_name"
		;;
	*)
		echo "Error: Package manager not found. Please install $package_name manually."
		exit 1
		;;
	esac # End of case statement
}

# Setup fastfetch
echo "Setting up fastfetch..."

if command_exists fastfetch; then
	echo "fastfetch is already installed."
else
	echo "Installing fastfetch..."
	if command_exists apt-get || command_exists yum || command_exists pacman; then
		install_package apt-get fastfetch || install_package yum fastfetch || install_package pacman fastfetch
	else
		echo "Error: Package manager not found. Please install fastfetch manually."
		exit 1
	fi

	# Check if installation was successful
	if ! command_exists fastfetch; then
		echo "Error: fastfetch installation failed. Exiting."
		exit 1
	fi
fi

# Create symbolic link for fastfetch
ln -s ~/.dotfiles/fastfetch ~/.config/fastfetch
echo "fastfetch link created"

# Setup zsh
echo "Setting up zsh..."

if command_exists zsh; then
	echo "zsh is already installed."
else
	echo "Installing zsh..."
	if command_exists apt-get || command_exists yum || command_exists pacman; then
		install_package apt-get zsh || install_package yum zsh || install_package pacman zsh
	else
		echo "Error: Package manager not found. Please install zsh manually."
		exit 1
	fi

	# Check if installation was successful
	if ! command_exists zsh; then
		echo "Error: zsh installation failed. Exiting."
		exit 1
	fi
fi

# Create symbolic link for .zshrc
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
echo "zsh link created"

echo "Setup complete."

#setup nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim

#setup firefox
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash