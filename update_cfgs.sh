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

echo "Updating Nushell and Starship configs..."

# Function to update configs
update_configs() {
    local target_home=$1
    local target_user=$2
    local config_dir="$target_home/.config/nushell"
    local starship_dir="$target_home/.config"

    echo "Updating configs for $target_user..."

    sudo mkdir -p "$config_dir"
    sudo cp "$script_dir/env.nu" "$config_dir/"
    sudo cp "$script_dir/config.nu" "$config_dir/"

    sudo mkdir -p "$starship_dir"
    sudo cp "$script_dir/starship.toml" "$starship_dir/"

    sudo chown -R "$target_user:$target_user" "$target_home/.config"
    echo "✔ Updated configs for $target_user"
}

# Update configs for current user
update_configs "$user_home" "$username"

# Update configs for root
update_configs /root root

echo
echo "Config update complete!"
