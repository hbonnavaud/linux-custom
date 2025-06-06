#!/bin/bash
# WiFi Status Script for Polybar

# Check if WiFi is connected
if iwconfig 2>/dev/null | grep -q "ESSID:"; then
    # Get SSID name
    ssid=$(iwconfig 2>/dev/null | grep "ESSID:" | sed 's/.*ESSID:"\(.*\)".*/\1/')
    if [ "$ssid" != "" ] && [ "$ssid" != "off/any" ]; then
        echo "WIFI: $ssid"
    else
        echo "WIFI: Connected"
    fi
else
    # Check with nmcli if available
    if command -v nmcli &> /dev/null; then
        if nmcli -t -f active,ssid dev wifi | grep -q "^yes:"; then
            ssid=$(nmcli -t -f active,ssid dev wifi | grep "^yes:" | cut -d: -f2)
            echo "WIFI: $ssid"
        else
            echo "WIFI: Disconnected"
        fi
    else
        echo "WIFI: Unknown"
    fi
fi