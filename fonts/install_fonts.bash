#!/bin/bash

# Step 1: Create the fonts directory if it doesn't exist
echo "📂 Creating ~/.local/share/fonts directory if it doesn't exist..."
mkdir -p ~/.local/share/fonts

# Step 2: Install fonts from .zip files
echo "📦 Installing fonts from .zip files..."

for zip_file in *.zip; do
    # Skip if no zip files are found
    if [ ! -f "$zip_file" ]; then
        echo "⚠️ No .zip files found in the current directory."
        break
    fi

    # Step 3: Extract the font name (without .zip extension)
    font_dir="${zip_file%.zip}"

    # Step 4: Create a directory for the font
    echo "🗂️ Creating directory for font: $font_dir"
    mkdir -p "$HOME/.local/share/fonts/$font_dir"

    # Step 5: Extract the .zip file into the newly created directory
    echo "📤 Extracting $zip_file into $font_dir..."
    unzip -q "$zip_file" -d "$HOME/.local/share/fonts/$font_dir"
done

# Step 7: Refresh font cache (important to apply changes)
echo "🔄 Refreshing font cache..."
fc-cache -fv

# Step 8: Notify the user
echo "✅ Fonts installed successfully! 🎉"
echo "Fonts are now available in ~/.local/share/fonts."
echo "You can use them in your applications or restart your session to apply them."
