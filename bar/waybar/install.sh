#!/bin/bash

# Waybar Symlink Setup Script
# Creates a symbolic link from ~/.config/waybar to linux-custom/waybar

SOURCE_DIR=$(dirname "$(realpath "$0")")
TARGET_DIR="$HOME/.config/waybar"

echo "Setting up waybar configuration symlink..."

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist!"
    echo "Please create the directory first or check the path."
    exit 1
fi

# Check if target directory already exists
if [ -e "$TARGET_DIR" ]; then
    echo "Warning: '$TARGET_DIR' already exists."

    # Check if it's already a symlink
    if [ -L "$TARGET_DIR" ]; then
        echo "It's already a symbolic link pointing to: $(readlink -f "$TARGET_DIR")"
        read -p "Do you want to replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$TARGET_DIR"
            echo "Removed existing symlink."
        else
            echo "Operation cancelled."
            exit 0
        fi
    else
        echo "It's a regular directory/file."
        read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create backup
            backup_name="${TARGET_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$TARGET_DIR" "$backup_name"
            echo "Backed up existing directory to: $backup_name"
        else
            echo "Operation cancelled."
            exit 0
        fi
    fi
fi

# Create the ~/.config directory if it doesn't exist
mkdir -p "$(dirname "$TARGET_DIR")"

# Create the symbolic link
ln -s "$SOURCE_DIR" "$TARGET_DIR"

if [ $? -eq 0 ]; then
    echo "✅ Successfully created symbolic link:"
    echo "   $TARGET_DIR -> $SOURCE_DIR"
    echo ""
    echo "Verification:"
    ls -la "$TARGET_DIR"
else
    echo "❌ Failed to create symbolic link!"
    exit 1
fi

echo ""
echo "Setup complete! Your waybar configuration is now linked to your code directory."
