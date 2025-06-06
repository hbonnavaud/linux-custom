#!/bin/bash
# Power Menu Script for Polybar

# Options
shutdown="⏻ Shutdown"
reboot="↻ Reboot"
logout="⇠ Logout"
lock="🔒 Lock"
cancel="✕ Cancel"

# Show rofi menu
chosen=$(echo -e "$lock\n$logout\n$reboot\n$shutdown\n$cancel" | rofi -dmenu -i -p "Power Menu")

case $chosen in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$logout")
        qtile cmd-obj -o cmd -f shutdown
        ;;
    "$lock")
        # Use your preferred screen locker (i3lock, betterlockscreen, etc.)
        if command -v betterlockscreen &> /dev/null; then
            betterlockscreen -l
        elif command -v i3lock &> /dev/null; then
            i3lock -c 2E3440
        else
            xlock
        fi
        ;;
    "$cancel")
        exit 0
        ;;
esac
