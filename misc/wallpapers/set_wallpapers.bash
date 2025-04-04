#!/bin/bash

# 🎨 Wallpaper Magic Script 🖼️✨
# Adds wallpapers to GNOME and sets "lake-reflection_2000x1334.jpg" if available, else picks a random one! 🎲🔀

# 📂 Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 📌 Preferred wallpaper
PREFERRED_WALLPAPER="lake-reflection_2000x1334.jpg"
PREFERRED_PATH="$SCRIPT_DIR/$PREFERRED_WALLPAPER"

# 📂 Get a list of all image files in the directory
WALLPAPERS=("$SCRIPT_DIR"/*.{jpg,jpeg,png,webp})
WALLPAPERS=("${WALLPAPERS[@]/*\**}")  # Remove wildcard if no matches

# 🛑 Check if wallpapers exist
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "🚨 Error: No wallpapers found in '$SCRIPT_DIR'! 😢"
    exit 1
fi

# 🏞️ Pick the wallpaper (preferred or random)
if [ -f "$PREFERRED_PATH" ]; then
    SELECTED_WALLPAPER="$PREFERRED_PATH"
    echo "🎯 Found preferred wallpaper! Using '$PREFERRED_WALLPAPER' 🏞️"
else
    SELECTED_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    echo "🎲 Preferred wallpaper not found, picking a random one: $(basename "$SELECTED_WALLPAPER") 🎨"
fi

# 🛠️ Apply the wallpaper
gsettings set org.gnome.desktop.background picture-uri "file://$SELECTED_WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$SELECTED_WALLPAPER"

echo "✅ Wallpaper updated successfully! 🌟 Enjoy the view! 🏞️💖"
