#!/bin/bash

echo "Setting up dynamic workspace navigation..."

# Create directories
mkdir -p ~/.config/hypr/scripts

# Check dependencies
echo "Checking dependencies..."
deps=("hyprctl" "jq")
missing_deps=()

for dep in "${deps[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        missing_deps+=("$dep")
    fi
done

if [[ ${#missing_deps[@]} -ne 0 ]]; then
    echo "Missing dependencies: ${missing_deps[*]}"
    echo "Install with: sudo pacman -S jq"
    exit 1
fi

echo "All dependencies found!"

# Make scripts executable
chmod +x ~/.config/hypr/scripts/workspace_nav.sh
chmod +x ~/.config/hypr/scripts/move_window.sh
chmod +x ~/.config/hypr/scripts/test_script.sh

echo "Scripts made executable."

# Test basic functionality
echo "Testing basic hyprctl functionality..."
if hyprctl dispatch workspace 1 >/dev/null 2>&1; then
    echo "✓ hyprctl is working"
else
    echo "✗ hyprctl is not working - check if Hyprland is running"
    exit 1
fi

# Create log file
touch ~/.config/hypr/workspace_nav.log
echo "Log file created at ~/.config/hypr/workspace_nav.log"

echo ""
echo "Setup complete! To test:"
echo "1. Save the scripts to ~/.config/hypr/scripts/"
echo "2. Add the keybindings to your hyprland.conf"
echo "3. Reload Hyprland config with: hyprctl reload"
echo "4. Test with Alt+Right/Left arrows"
echo "5. Check logs at ~/.config/hypr/workspace_nav.log"
echo ""
echo "For immediate testing, try:"
echo "~/.config/hypr/scripts/test_script.sh"
