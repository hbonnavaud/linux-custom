#!/bin/bash

# Get the directory where this script lives
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# VS Code User config source directory
SOURCE_DIR="$HOME/.config/Code/User"

# Target User subdir in current script directory
TARGET_USER_DIR="$SCRIPT_DIR/User"
mkdir -p "$TARGET_USER_DIR"

echo "Exporting VS Code configuration to: $SCRIPT_DIR"

# Copy settings.json
if [[ -f "$SOURCE_DIR/settings.json" ]]; then
    cp "$SOURCE_DIR/settings.json" "$TARGET_USER_DIR/"
    echo "✓ Copied settings.json"
else
    echo "✗ settings.json not found"
fi

# Copy keybindings.json
if [[ -f "$SOURCE_DIR/keybindings.json" ]]; then
    cp "$SOURCE_DIR/keybindings.json" "$TARGET_USER_DIR/"
    echo "✓ Copied keybindings.json"
else
    echo "✗ keybindings.json not found"
fi

# Copy snippets folder
if [[ -d "$SOURCE_DIR/snippets" ]]; then
    cp -r "$SOURCE_DIR/snippets" "$TARGET_USER_DIR/"
    echo "✓ Copied snippets/"
else
    echo "✗ snippets/ folder not found"
fi

# Handle extensions.txt

EXT_FILE="$SCRIPT_DIR/extensions.txt"
SOURCE_EXT_FILE=$(dirname $SOURCE_DIR)/extensions.txt
if command -v code &> /dev/null; then
    rm $EXT_FILE
    code --list-extensions > "$EXT_FILE"
else
    if [[ -f $SOURCE_EXT_FILE ]]; then
        rm $EXT_FILE
        cp $SOURCE_EXT_FILE $EXT_FILE
    else
        echo "Can't copy extentions.txt because the file wasn't found and cannot be generated because code command has not been found."
    fi
fi

echo "Done."
