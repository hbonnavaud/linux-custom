#!/bin/bash

# Get the directory where this script lives (where the config is stored)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source directories
SOURCE_EXT_FILE="$SCRIPT_DIR/extensions.txt"

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
