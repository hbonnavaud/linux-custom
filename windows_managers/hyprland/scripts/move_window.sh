#!/bin/bash

# Move window to adjacent workspace script
# Usage: ./move_window.sh [next|prev]

get_current_workspace() {
    hyprctl activewindow -j | jq -r '.workspace.id' 2>/dev/null || echo "1"
}

get_all_workspaces() {
    hyprctl workspaces -j | jq -r '.[].id' | sort -n
}

get_max_workspace() {
    get_all_workspaces | tail -1
}

get_min_workspace() {
    get_all_workspaces | head -1
}

workspace_exists() {
    local ws_id=$1
    hyprctl workspaces -j | jq -e ".[] | select(.id == $ws_id)" >/dev/null 2>&1
}

move_window_next() {
    local current_ws=$(get_current_workspace)
    local max_ws=$(get_max_workspace)
    local next_ws=$((current_ws + 1))
    
    if [[ "$current_ws" == "$max_ws" ]]; then
        # Create new workspace and move window there
        hyprctl dispatch movetoworkspace "$next_ws"
        hyprctl dispatch workspace "$next_ws"
    else
        # Move to existing next workspace
        hyprctl dispatch movetoworkspace "$next_ws"
        hyprctl dispatch workspace "$next_ws"
    fi
}

move_window_prev() {
    local current_ws=$(get_current_workspace)
    local min_ws=$(get_min_workspace)
    local prev_ws=$((current_ws - 1))
    
    if [[ "$current_ws" == "$min_ws" ]]; then
        # We're on first workspace, move to last
        local max_ws=$(get_max_workspace)
        hyprctl dispatch movetoworkspace "$max_ws"
        hyprctl dispatch workspace "$max_ws"
    else
        # Move to previous workspace
        if workspace_exists "$prev_ws"; then
            hyprctl dispatch movetoworkspace "$prev_ws"
            hyprctl dispatch workspace "$prev_ws"
        fi
    fi
}

# Main logic
case "$1" in
    "next")
        move_window_next
        ;;
    "prev")
        move_window_prev
        ;;
    *)
        echo "Usage: $0 [next|prev]"
        exit 1
        ;;
esac
