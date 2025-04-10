#!/bin/bash

# Get the directory where this script lives (where the config is stored)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source directories
SOURCE_USER_DIR="$SCRIPT_DIR/User"
SOURCE_EXT_FILE="$SCRIPT_DIR/extensions.txt"

# Destination directories
DEST_USER_DIR="$HOME/.config/Code/User"

echo "Importing VS Code configuration to: $DEST_USER_DIR"

# Copy User folder
if [[ -d "$SOURCE_USER_DIR" ]]; then
    cp -r "$SOURCE_USER_DIR" "$DEST_USER_DIR"
    echo "✓ Restored User/"
else
    echo "✗ User/ folder not found in $SOURCE_USER_DIR"
fi

# Reinstall extensions
if [[ -f "$SOURCE_EXT_FILE" ]]; then
    if command -v code &> /dev/null; then
        echo "Installing extensions from extensions.txt..."
        while IFS= read -r extension; do
            code --install-extension "$extension" --force
        done < "$SOURCE_EXT_FILE"
        echo "✓ Extensions installed"
    else
        echo "✗ VS Code CLI 'code' not found — cannot install extensions"
    fi
else
    echo "✗ extensions.txt not found in $SCRIPT_DIR"
fi

echo "Done."
