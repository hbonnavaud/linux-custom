#!/bin/bash

# Dynamic workspace management script for Hyprland
# Usage: ./workspace_manager.sh [next|prev] for workspace switching

# Enable debugging
set -e
ENABLE_LOG_FILE="false"
LOG_FILE="$HOME/.config/hypr/workspace_nav.log"

log_message() {
    if [ $ENABLE_LOG_FILE = "true" ];
    then
        # exit 0  # Comment this to enable debugging
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    fi
}

get_current_workspace() {
    local current=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null)
    if [[ -z "$current" || "$current" == "null" ]]; then
        current="1"
    fi
    echo "$current"
}

get_workspace_windows() {
    local ws_id=$1
    local windows=$(hyprctl workspaces -j 2>/dev/null | jq -r ".[] | select(.id == $ws_id) | .windows" 2>/dev/null)
    if [[ -z "$windows" || "$windows" == "null" ]]; then
        windows="0"
    fi
    echo "$windows"
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

create_workspace() {
    local ws_id=$1
    hyprctl dispatch workspace "$ws_id" >/dev/null 2>&1
}

remove_empty_workspace() {
    local ws_id=$1
    local windows=$(get_workspace_windows "$ws_id")
    if [[ "$windows" == "0" ]]; then
        # Switch away from the workspace before removing it
        hyprctl dispatch workspace 1 >/dev/null 2>&1
        sleep 0.1
        # The workspace will be automatically removed when empty and not active
    fi
}

navigate_next() {
    # log_message "Navigating to next workspace"
    local current_ws=$(get_current_workspace)
    local max_ws=$(get_max_workspace)
    local next_ws=$((current_ws + 1))

    log_message "\n[NEXT] Current: $current_ws, Max: $max_ws, Next: $next_ws"

    if [[ "$current_ws" == "$max_ws" ]]; then
        # We're on the last workspace
        local current_windows=$(get_workspace_windows "$current_ws")
        # log_message "On last workspace, windows: $current_windows"

        if [[ "$current_windows" != "0" ]]; then
            # Current workspace has windows, create a new one
            log_message "[LAST] [NON EMPTY] Creating new workspace $next_ws"
            hyprctl dispatch workspace "$next_ws" 2>&1 | tee -a "$LOG_FILE"
        else
            # Current workspace is empty, go to first
            log_message "[LAST] [EMPTY] Empty workspace, going to workspace 1"
            hyprctl dispatch workspace 1 2>&1 | tee -a "$LOG_FILE"
        fi
    else
        # Navigate to next existing workspace
        log_message "[NOT LAST] Navigating to existing workspace $next_ws"
        hyprctl dispatch workspace "$next_ws" 2>&1 | tee -a "$LOG_FILE"
    fi
}

navigate_prev() {
    # log_message "Navigating to previous workspace"
    local current_ws=$(get_current_workspace)

    if [[ "$current_ws" == "1" ]]; then
        # We're on the first workspace
        local max_ws=$(get_max_workspace)
        local max_windows=$(get_workspace_windows "$max_ws")

        if [[ "$max_windows" == "0" ]]; then
            hyprctl dispatch workspace "$max_ws" 2>&1 | tee -a "$LOG_FILE"
        else
            # Last workspace is not empty, propose a new workspace
            hyprctl dispatch workspace "$((max_ws + 1))" 2>&1 | tee -a "$LOG_FILE"
        fi
    else
        local prev_ws=$((current_ws - 1))
        # Navigate to previous existing workspace
        if workspace_exists "$prev_ws"; then
            # log_message "Navigating to existing workspace $prev_ws"
            hyprctl dispatch workspace "$prev_ws" 2>&1 | tee -a "$LOG_FILE"
        else
            log_message "Previous workspace $prev_ws doesn't exist"
            exit 1
        fi
    fi
}

# Function to delete a workspace and renumber subsequent ones
delete_workspace() {
    local ws_to_delete=$1
    local current_ws=$(get_current_workspace)
    
    log_message "Deleting workspace $ws_to_delete (current: $current_ws)"
    
    # Get all workspaces
    local all_workspaces=($(get_all_workspaces))
    local max_ws=${all_workspaces[-1]}
    
    # Determine where to switch before deletion
    local target_ws
    if [[ "$current_ws" == "$ws_to_delete" ]]; then
        # We're on the workspace being deleted
        if [[ "$ws_to_delete" == "$max_ws" ]]; then
            # Deleting the last workspace, go to previous
            target_ws=$((ws_to_delete - 1))
        else
            # Not the last workspace, go to next (which will become current number after renumbering)
            target_ws="$ws_to_delete"
        fi
        
        # Switch away from the workspace to be deleted
        log_message "Switching to workspace $target_ws before deletion"
        hyprctl dispatch workspace "$target_ws" >/dev/null 2>&1
        sleep 0.1
    fi
    
    # Now renumber all workspaces after the deleted one
    log_message "Starting renumbering process"
    for ws in "${all_workspaces[@]}"; do
        if [[ "$ws" -gt "$ws_to_delete" ]]; then
            local new_id=$((ws - 1))
            log_message "Renaming workspace $ws to $new_id"
            
            # Move all windows from old workspace to new workspace
            local windows_info=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ws) | .address")
            
            for window in $windows_info; do
                hyprctl dispatch movetoworkspacesilent "$new_id,address:$window" >/dev/null 2>&1
            done
            
            sleep 0.05
        fi
    done
    
    log_message "Renumbering completed"
}

# Function to handle window close events
handle_window_close() {
    local workspace_id=$1
    log_message "\n\nWindow closed on workspace $workspace_id\n\n"
    
    # Small delay to let Hyprland update
    sleep 0.1
    
    # Check if workspace still exists and is empty
    if workspace_exists "$workspace_id"; then
        local windows=$(get_workspace_windows "$workspace_id")
        log_message "Workspace $workspace_id has $windows windows remaining"
        
        if [[ "$windows" == "0" ]] && [[ "$workspace_id" != "1" ]]; then
            log_message "Workspace $workspace_id is empty, initiating deletion"
            delete_workspace "$workspace_id"
        fi
    fi
}

listen_to_events() {
    log_message "Starting workspace manager event listener"

    if [ -f "$LISTENER_PID_FILE" ] && kill -0 "$(cat "$LISTENER_PID_FILE")" 2>/dev/null; then
        log_message "Listener already running with PID $(cat "$LISTENER_PID_FILE")"
        return
    fi
    
    # # Kill any existing instances of this script in listen mode
    # pkill -f "workspace_manager.sh listen" 2>/dev/null || true
    
    log_message "Hyprland instance: $HYPRLAND_INSTANCE_SIGNATURE"
    
    # Use XDG_RUNTIME_DIR for socket path (modern Hyprland location)
    local socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
    log_message "Socket path: $socket_path"
    
    # Check if socket exists
    if [[ ! -S "$socket_path" ]]; then
        log_message "ERROR: Hyprland socket not found at $socket_path"
        exit 1
    fi
    
    # Listen to Hyprland events
    socat -U - UNIX-CONNECT:"$socket_path" | while read -r line; do
        # Parse the event
        event_type=$(echo "$line" | cut -d'>' -f1)
        event_data=$(echo "$line" | cut -d'>' -f2-)
        
        case "$event_type" in
            "closewindow")
                # Extract workspace info from the closed window
                log_message "Window close event detected: $event_data"
                
                # Get current workspace as the window was likely on the active workspace
                current_ws=$(get_current_workspace)
                handle_window_close "$current_ws"
                ;;
            *)
                # Log all events for debugging
                log_message "Event: $event_type > $event_data"
                ;;
        esac
    done
}

# Main execution

log_message "Received $1"
case "${1:-listen}" in
    "next")
        log_message "Executing next navigation"
        navigate_next
        ;;
    "prev")
        log_message "Executing prev navigation"
        navigate_prev
        ;;
    "listen")
        log_message "Detected listen"
        listen_to_events
        ;;
    "delete")
        if [[ -n "$2" ]]; then
            delete_workspace "$2"
        else
            echo "Usage: $0 delete <workspace_id>"
            exit 1
        fi
        ;;
    "test-close")
        if [[ -n "$2" ]]; then
            handle_window_close "$2"
        else
            echo "Usage: $0 test-close <workspace_id>"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 [next|prev|listen|delete <ws_id>|test-close <ws_id>]"
        exit 1
        ;;
esac