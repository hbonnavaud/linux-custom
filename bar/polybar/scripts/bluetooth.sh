#!/bin/bash
# Bluetooth Status Script for Polybar

# Check if bluetooth service is running
if systemctl is-active --quiet bluetooth; then
    # Check if bluetooth is powered on
    if bluetoothctl show | grep -q "Powered: yes"; then
        # Check for connected devices
        connected_devices=$(bluetoothctl devices Connected | wc -l)
        
        if [ "$connected_devices" -gt 0 ]; then
            echo "%{F#5E81AC} ${connected_devices}%{F-}"
        else
            echo "%{F#81A1C1}%{F-}"
        fi
    else
        echo "%{F#4C566A}%{F-}"
    fi
else
    echo "%{F#BF616A}%{F-}"
fi
