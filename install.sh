#!/bin/bash

set -e

# Get current user and home directory
username=$(whoami)
user_home="$HOME"

# Get script directory
script_dir="$(pwd)"

# Check config files
for file in env.nu config.nu starship.toml; do
    if [ ! -f "$script_dir/$file" ]; then
        echo "Error: Missing required file $file in script directory"
        exit 1
    fi
done

echo "Starting installation as $username..."

# Install required packages
echo "Installing dependencies..."
sudo apt update
sudo apt install -y gpg bat fish eza

# Install Nushell
echo "Installing Nushell..."
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
sudo apt update
sudo apt install -y nushell

# Install Zoxide
echo "Installing Zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install Starship
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install Pyenv
curl -fsSL https://pyenv.run | bash

# Setup configs for given user
setup_configs() {
    local target_home=$1
    local target_user=$2
    local config_dir="$target_home/.config/nushell"

    echo "Setting up Nushell configs for $target_user..."

    sudo mkdir -p "$config_dir"
    sudo cp "$script_dir/env.nu" "$config_dir/"
    sudo cp "$script_dir/config.nu" "$config_dir/"
    sudo mkdir -p "$target_home/.config"
    sudo cp "$script_dir/starship.toml" "$target_home/.config/"

    sudo chown -R "$target_user:$target_user" "$target_home/.config"
}

# Setup for current user
setup_configs "$user_home" "$username"

# Setup for root
setup_configs /root root

# Set Nushell as default shell
echo "Setting Nushell as default shell..."

if ! getent passwd root | grep -q '/usr/bin/nu'; then
    sudo chsh -s /usr/bin/nu root
    echo "✔ Root default shell set to Nushell"
else
    echo "✔ Root already uses Nushell"
fi

if ! getent passwd "$username" | grep -q '/usr/bin/nu'; then
    sudo chsh -s /usr/bin/nu "$username"
    echo "✔ $username default shell set to Nushell"
else
    echo "✔ $username already uses Nushell"
fi

echo
echo "Shells after change:"
getent passwd root
getent passwd "$username"

echo
echo "Installation complete!"
echo "Log out and back in to see Nushell in effect."
echo "Run 'sudo nu' to use Nushell as root without changing root's default shell."
