#!/bin/bash

# Get the directory where this script lives (where the config is stored)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source files
SOURCE_SETTINGS_FILE="$SCRIPT_DIR/User/settings.json"
SOURCE_KEYBINDINGS_FILE="$SCRIPT_DIR/User/keybindings.json"

# Detect the correct VS Code config directory
if [[ -d "$HOME/.config/Code" ]]; then
    DEST_USER_DIR="$HOME/.config/Code/User"
    echo "Using VS Code directory: $DEST_USER_DIR"
elif [[ -d "$HOME/.config/Code - OSS" ]]; then
    DEST_USER_DIR="$HOME/.config/Code - OSS/User"
    sudo cp $SCRIPT_DIR/code-icon.svg /usr/lib/code/out/media/code-icon.svg
    echo "Using VS Code - OSS directory: $DEST_USER_DIR"
else
    echo "✗ Neither 'Code' nor 'Code - OSS' directories found in $HOME/.config"
    exit 1
fi

echo "Importing specific VS Code configuration to: $DEST_USER_DIR"

# Copy settings.json if it exists
if [[ -f "$SOURCE_SETTINGS_FILE" ]]; then
    cp -f "$SOURCE_SETTINGS_FILE" "$DEST_USER_DIR/settings.json"
    echo "✓ Restored settings.json"
else
    echo "✗ settings.json not found in $SOURCE_SETTINGS_FILE"
fi

# Copy keybindings.json if it exists
if [[ -f "$SOURCE_KEYBINDINGS_FILE" ]]; then
    cp -f "$SOURCE_KEYBINDINGS_FILE" "$DEST_USER_DIR/keybindings.json"
    echo "✓ Restored keybindings.json"
else
    echo "✗ keybindings.json not found in $SOURCE_KEYBINDINGS_FILE"
fi

echo "Done."
