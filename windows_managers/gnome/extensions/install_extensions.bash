#!/bin/bash

# 🎯 Define Backup Directory
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$BACKUP_DIR/extensions-list.txt"
SETTINGS_FILE="$BACKUP_DIR/gnome-extensions-settings.conf"

# 🚨 Check if Backup Directory Exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Backup directory not found! Make sure you copied it correctly."
    exit 1
fi

echo "🔄 Starting GNOME Extensions Restore Process..."

# 🔧 Install Required Packages
echo "📦 Installing required packages..."
sudo apt update
sudo apt install -y gnome-shell-extensions gnome-shell-extension-prefs dconf-cli

# ⚙️ Install gnome-shell-extension-installer if missing
if ! command -v gnome-shell-extension-installer &> /dev/null; then
    echo "🌍 Downloading gnome-shell-extension-installer..."
    wget -O gnome-shell-extension-installer https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer
    chmod +x gnome-shell-extension-installer
    sudo mv gnome-shell-extension-installer /usr/local/bin/
fi

# 🔄 Loop Through and Install Extensions
echo "🔌 Installing GNOME extensions..."
while read -r EXTENSION; do
    if [[ -n "$EXTENSION" ]]; then
        echo "✨ Installing: $EXTENSION"
        gnome-shell-extension-installer "$EXTENSION" --yes
        gnome-extensions enable "$EXTENSION"
    fi
done < "$EXTENSIONS_FILE"

# 🎯 Restore Extensions Settings
if [ -f "$SETTINGS_FILE" ]; then
    echo "🔧 Restoring extensions' settings..."
    dconf load /org/gnome/shell/extensions/ < "$SETTINGS_FILE"
    echo "✅ Extensions settings restored!"
else
    echo "⚠️ No settings file found. Skipping settings restore."
fi

echo "🎉 All GNOME extensions and settings have been successfully restored!"
