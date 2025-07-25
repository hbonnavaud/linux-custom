#!/bin/bash

# Dependencies

if command -v apt >/dev/null 2>&1; then
    echo "Detected: apt (Debian/Ubuntu)"
    sudo apt update
    sudo apt install -y rofi fonts-noto-color-emoji inetutils
elif command -v pacman >/dev/null 2>&1; then
    echo "Detected: pacman (Arch/Manjaro)"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm rofi-emoji noto-fonts-emoji inetutils
elif command -v dnf >/dev/null 2>&1; then
    echo "Detected: dnf (Fedora/RHEL)"
    sudo dnf install -y rofi google-noto-emoji-fonts net-tools
elif command -v zypper >/dev/null 2>&1; then
    echo "Detected: zypper (openSUSE)"
    sudo zypper refresh
    sudo zypper install -y rofi noto-coloremoji-fonts net-tools
else
    echo "Unknown package manager — manual install required."
fi

#!/bin/bash

# Install the parent directory by creating a symling from ~/.config/${NAME} to this parent directory where $NAME is the name of the said directory

SOURCE_DIR=$(dirname "$(realpath "$0")")
NAME=$(basename "$SOURCE_DIR")
TARGET_DIR="$HOME/.config/${NAME}"

echo "Setting up ${NAME} configuration symlink..."

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
echo "Setup complete! Your ${NAME} configuration is now linked to your code directory."
