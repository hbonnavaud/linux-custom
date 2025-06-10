#!/bin/bash
# Save as ~/.config/waybar/scripts/power-menu.sh

# Create the menu options
options="🔌 Shutdown\n🔄 Restart\n🚪 Logout\n💤 Suspend\n🛌 Hibernate\n🔒 Lock Screen"

# Show wofi menu with custom styling
chosen=$(echo -e "$options" | wofi \
    --show dmenu \
    --width 200 \
    --xoffset -30 \
    --yoffset 40 \
    --location top_right \
    --allow-markup \
    --insensitive \
    --hide-scroll \
    --no-actions \
    --prompt="" \
    --hide_search=true \
    --style ~/.config/waybar/power-menu/style.css)

# Execute the chosen action
case $chosen in
    "🔌 Shutdown")
        shutdown -h now
        ;;
    "🔄 Restart")
        shutdown -r now
        ;;
    "🚪 Logout")
        swaymsg exit
        ;;
    "💤 Suspend")
        systemctl suspend
        ;;
    "🛌 Hibernate")
        systemctl hibernate
        ;;
    "🔒 Lock Screen")
        swaylock -f
        ;;
esac