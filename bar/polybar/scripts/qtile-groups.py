#!/usr/bin/env python3

import subprocess
import json

def get_qtile_groups():
    # Use qtile cmd-obj to get information about groups
    result = subprocess.run(['qtile', 'cmd-obj', '-o', 'cmd', '-f', 'get_groups'], stdout=subprocess.PIPE)
    groups_info = json.loads(result.stdout)

    # Extract group names and status
    groups = []
    for name, group in groups_info.items():
        groups.append({
            'name': group['label'],  # Use 'label' as the display name
            'focused': group.get('screen') is not None,  # Check if the group is focused
            'occupied': len(group.get('windows', [])) > 0  # Check if the group has windows
        })

    return groups

def format_groups_for_polybar(groups):
    # Format the group information for Polybar
    output = ""
    for group in groups:
        if group['focused']:
            output += f"{{F#2E3440}}[{group['name']}]{{F-}} "  # Focused group
        elif group['occupied']:
            output += f"{{F#88C0D0}}({group['name']}){{F-}} "  # Occupied group
        else:
            output += f"{group['name']} "  # Inactive group

    return output.strip()

def main():
    groups = get_qtile_groups()
    formatted_groups = format_groups_for_polybar(groups)
    print(formatted_groups)

if __name__ == "__main__":
    main()