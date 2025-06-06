#!/bin/bash

# Install qtile dependencies
pacman -S --noconfirm python-xlib python-psutil
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
yay -S qtile-extras

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
ln -s "$script_dir/config.py" "$user_home/.config/qtile/config.py"

rm -f "$user_home/.config/qtile/mypy.ini"
ln -s "$script_dir/mypy.ini" "$user_home/.config/qtile/mypy.ini"

# Update libqtile with the additional GPU widget
if [ ! -f /usr/lib/python3.13/site-packages/libqtile/widget/gpu.py ]; then
    sudo cp "$script_dir/utils/gpu_widget.py" /usr/lib/python3.13/site-packages/libqtile/widget/gpu.py

    
# Update /usr/lib/python3.13/site-packages/libqtile/widget/__init__.py
# Path to the target file
WIDGETS_INIT="/usr/lib/python3.13/site-packages/libqtile/widget/__init__.py"
NEW_LINE='"GPU": "gpu",'

# Insert only if the line doesn't exist
grep -qF "$NEW_LINE" "$WIDGETS_INIT" || sed -i '/"CPU": "cpu",/a\
    '"$NEW_LINE" "$WIDGETS_INIT"