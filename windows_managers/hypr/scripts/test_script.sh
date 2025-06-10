#!/bin/bash

# Simple test script to verify bindings work
echo "$(date): Test script executed with args: $@" >> /tmp/hypr_test.log

# Test basic hyprctl command
if command -v hyprctl >/dev/null 2>&1; then
    echo "hyprctl found" >> /tmp/hypr_test.log
    hyprctl dispatch workspace 2 >> /tmp/hypr_test.log 2>&1
else
    echo "hyprctl NOT found" >> /tmp/hypr_test.log
fi

# Send notification if available
if command -v notify-send >/dev/null 2>&1; then
    notify-send "Test Script" "Executed at $(date)"
fi
