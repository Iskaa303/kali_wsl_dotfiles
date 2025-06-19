#!/bin/bash

# Get username
if [ $# -eq 0 ]; then
    read -p "Enter username: " username
else
    username=$1
fi

# Verify user exists
if ! id "$username" &>/dev/null; then
    echo "Error: User '$username' does not exist"
    exit 1
fi

# Get script directory
script_dir="$(pwd)"

# Verify config files exist
for file in env.nu config.nu starship.toml; do
    if [ ! -f "$script_dir/$file" ]; then
        echo "Error: Missing required file $file in script directory"
        exit 1
    fi
done

echo "Starting installation..."
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

# Setup configuration function
setup_configs() {
    local user_home=$1
    local user_name=$2
    local config_dir="$user_home/.config/nushell"
    
    echo "Configuring for $user_name..."
    
    # Create directories
    mkdir -p "$config_dir"
    mkdir -p "$user_home/.config"
    
    # Copy config files
    cp "$script_dir/env.nu" "$config_dir/"
    cp "$script_dir/config.nu" "$config_dir/"
    cp "$script_dir/starship.toml" "$user_home/.config/"
    
    # Set ownership (only if not the current user)
    if [ "$user_name" != "$USER" ]; then
        sudo chown -R "$user_name:$user_name" "$user_home/.config"
    fi
}

# Setup for root
sudo bash -c "$(declare -f setup_configs); setup_configs /root root"

# Setup for user
user_home=$(eval echo ~$username)
setup_configs "$user_home" "$username"

echo "Installation complete!"
echo "Set default shell with:"
echo "  chsh -s /usr/bin/nu"
echo "  sudo chsh -s /usr/bin/nu $username"
echo "Log out and log back in for changes to take effect"
