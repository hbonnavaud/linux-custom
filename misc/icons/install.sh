#!/bin/bash

# Define source and destination directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICONS_SRC="$SCRIPT_DIR/icons"
ICONS_DEST="$HOME/.local/share/icons"

# Check if the icons directory exists
if [[ ! -d "$ICONS_SRC" ]]; then
    echo "Error: '$ICONS_SRC' directory not found."
    exit 1
fi

# Get the list of icon themes
icon_sets=("$ICONS_SRC"/*)

# Check if there are any icon themes
if [[ ${#icon_sets[@]} -eq 0 ]]; then
    echo "No icon themes found in 'icons' directory."
    exit 1
fi

echo "Found ${#icon_sets[@]} icon themes. Installing..."

# Loop through each icon set
mkdir -p ~/.local/share/icons/
for icon_set in "${icon_sets[@]}"; do
    if [[ -d "$icon_set" ]]; then
        icon_name=$(basename "$icon_set")
        dest_path="$ICONS_DEST/$icon_name"

        echo "Installing '$icon_name'..."

        # Remove existing directory if it exists
        if [[ -d "$dest_path" ]]; then
            echo "Warning: '$icon_name' already exists in $ICONS_DEST. Replacing it..."
            rm -rf "$dest_path"
        fi

        # Copy the new icon set
        cp -r "$icon_set" "$dest_path"

        echo "✔ Installed: $icon_name"
    fi
done

# Update the icon cache
echo -e "\nUpdating icon cache..."
for dir in ~/.local/share/icons/*; do
    if [[ -d "$dir" ]]; then
        gtk-update-icon-cache -f -t "$dir"
    fi
done

sudo cp add_icon.sh "$ICONs_DEST/."

echo "✅ Icon installation complete!"
