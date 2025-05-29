from libqtile import layout, hook
from libqtile.config import Key
from libqtile.lazy import lazy
from libqtile import log_utils


def create_group(qtile, group_name, keys=None):
    qtile.add_group(group_name, layout="monadtall", persist=True)
    if group_name in [str(i) for i in range(1, 11)]:
        group_index = int(group_name)
        keys.extend([
            Key(["mod4"], 9+group_index, lazy.group[group_name].toscreen(), desc=f"Switch to group {group_name}"),
            Key(["mod4", "shift"], 9+group_index, lazy.window.togroup(group_name, switch_group=True), desc=f"Switch to & move focused window to group {group_name}"),
        ])


def delete_group(qtile, group_name):
    if len(qtile.groups) == len(qtile.screens):
        # Ignore deleteion because we need to keep at least ont group per screen
        return
    
    # Clear the group
    group = qtile.groups_map[group_name]
    if group:
        for window in list(group.windows):  # use list() to avoid modifying while iterating
            window.kill()

    # Remove the group
    qtile.delete_group(group_name)

    # Rename the following groups
    to_rename = []
    for g in qtile.groups:
        num = int(g.name)
        if num > int(group_name):
            to_rename.append((g, num))

    # Sort groups descending to avoid conflicts (e.g., rename "6" to "5" before "5" to "4")
    for group, num in sorted(to_rename, key=lambda x: x[1]):
        new_name = str(num - 1)
        qtile.groups_map.pop(group.name)
        group.name = new_name
        group.label = new_name
        qtile.groups_map[new_name] = group
    
    qtile.groups = [qtile.groups_map[name] for name in sorted(qtile.groups_map.keys(), key=int)]


def next_group(qtile, keys):
    current_group = qtile.current_group
    current_index = int(current_group.name)

    if len(qtile.groups_map.keys()) == 1 and not current_group.windows:
        return

    if current_index == len(qtile.groups_map.keys()):
        if not current_group.windows:
            qtile.current_screen.set_group(qtile.groups_map["1"], save_prev=False)
            delete_group(qtile, current_group.name)
        else:
            new_group_name = str(len(qtile.groups_map.keys()) + 1)
            create_group(qtile, new_group_name, keys)
            qtile.current_screen.set_group(qtile.groups_map[new_group_name], save_prev=False)
    else:
        next_group_name = str(current_index + 1)
        qtile.current_screen.set_group(qtile.groups_map[next_group_name], save_prev=False)

def previous_group(qtile, keys):
    current_group = qtile.current_group
    current_index = int(current_group.name)

    if len(qtile.groups_map.keys()) == 1 and not current_group.windows:
        return
        
    if current_index == 1:
        new_group_name = str(len(qtile.groups_map.keys()) + 1)
        create_group(qtile, new_group_name, keys)
        qtile.current_screen.set_group(qtile.groups_map[new_group_name], save_prev=False)
    else:
        qtile.current_screen.set_group(qtile.groups_map[str(current_index - 1)], save_prev=False)
        if current_index == len(qtile.groups_map.keys()) and not current_group.windows:
            delete_group(qtile, current_group.name)


def close_window(qtile):
    window = qtile.current_window
    if window is not None:
        group = window.group
        kill_group = len(group.windows) == 1
        # '-> If we put this in the if bellow, the if is called before the window is actually removed.
        #     We test if there is only 1 window left before, insthead of testing if there is 0 window left after.
        window.kill()
        if kill_group:
            delete_group(qtile, group.name)
    elif len(qtile.current_group.windows) == 1:
        # There is no focused window and the current group is empty
        # This elif is made so we can use the kill window shortcut to kill an empty group.
        delete_group(qtile, qtile.current_group.name)
