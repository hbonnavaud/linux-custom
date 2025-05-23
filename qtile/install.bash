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

rm -f "$user_home/.config/picom/picom.conf"
ln -s "$script_dir/picom.conf" "$user_home/.config/picom/picom.conf"

rm -f "$user_home/.config/qtile/autostart.sh"
ln -s "$script_dir/autostart.sh" "$user_home/.config/qtile/autostart.sh"

rm -f "$user_home/.config/qtile/config.py"
ln -s "$script_dir/config_files/config.py" "$user_home/.config/qtile/config.py"
