#!/bin/bash

# Path to exported keybindings file
KEYBINDINGS_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/keybindings.conf"

# Check if the file exists
if [ ! -f "$KEYBINDINGS_FILE" ]; then
    echo "❌ Error: Keybindings file not found at $KEYBINDINGS_FILE"
    exit 1
fi

# Import the keybindings using dconf
dconf load / < "$KEYBINDINGS_FILE"

echo "✅ Custom GNOME keybindings have been imported successfully!"

