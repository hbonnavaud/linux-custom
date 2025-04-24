#!/bin/bash

# Install qtile dependencies
pacman -S --noconfirm python-xlib python-psutil

# Get the user home directory
if [ -n "$SUDO_USER" ]; then
    user_home=$(eval echo ~$SUDO_USER)
else
    user_home="$HOME"
fi

# List of config files to copy
file_paths=(
    "$user_home/.config/picom/picom.conf"
    "$user_home/.config/qtile/autostart.sh"
    "$user_home/.config/qtile/config.py"
)

# Get the directory where the script is located
script_dir=$(dirname "$(realpath "$0")")

# Iterate through the list of file paths
for file_path in "${file_paths[@]}"; do
    # Remove the file if it exists, ignore if it doesn't
    rm -f "$file_path"

    # Create a symlink to the file in the script's directory
    ln -s "$script_dir/$(basename "$file_path")" "$file_path"
    echo "Created symlink at $file_path pointing to $script_dir/$(basename "$file_path")"
done
