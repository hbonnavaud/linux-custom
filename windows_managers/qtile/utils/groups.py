from libqtile import layout, hook
from libqtile.config import Key
from libqtile.lazy import lazy
from libqtile import log_utils
import pathlib, os, sys
parent_dir = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(parent_dir))
import settings
from libqtile.log_utils import logger

# Find icons at:
# - 
default_app_icons = {
    "discord": {"icon": "", "priority": 1},
    "slack": {"icon": "", "priority": 1},
    "pycharm": {"icon": "", "priority": 1},
    "firefox": {"icon": "", "priority": 1},
    "thunderbird": {"icon": "", "priority": 1},
    "code": {"icon": "", "priority": 1},
    "alacritty": {"icon": "", "priority": 1},
    "terminator": {"icon": "", "priority": 2},
    "thunar": {"icon": "", "priority": 2}, # ou 
    "obsidian": {"icon": "", "priority": 1},
}

def update_group_icon(group):

    logger.warning(f"[DEBUG] Updating icon of group {group.name}")
    candidate_icon = None
    candidate_priority = None
    logger.warning(f"[DEBUG] group_windows = {[w.name for w in group.windows]}")
    for window in group.windows:

        # Find window icon
        wm_class = window.get_wm_class()
        if not wm_class:
            continue
        lower_name = " ".join(wm_class).lower()

        window_icon = None
        for k, v in default_app_icons.items():
            if k in lower_name:
                window_icon = v
                break
        else:
            continue

        # Verify if this icon should be the one we keep for the group so far
        if window_icon is not None \
                and (candidate_priority is None or window_icon["priority"] < candidate_priority):
            candidate_icon = window_icon["icon"]
            candidate_priority = window_icon["priority"]
    group.label = group.label if candidate_icon is None else candidate_icon


def switch_to_group(qtile, group_name, window=False):
    """
    window is a boolean that is true if we want to move the focused window the said group, or false if we only want to switch group
    """
    # If the group does not exists, create it, except if it's id is too high to prevent mistakes.
    if group_name not in qtile.groups_map:
        if int(group_name) >= 10:
            return
        for new_group_id in range(len(qtile.groups_map.keys()) + 1, int(group_name) + 1):
            create_group(qtile, str(new_group_id))
    if window:
        current_group_name = qtile.current_group.name
        should_delete_group = len(qtile.current_group.windows) == 1
        qtile.current_group.current_window.togroup(group_name, switch_group=True)
        if should_delete_group:
            delete_group(qtile, current_group_name)
        
        # Update groups icons if groups are labelled by apps icons
        if settings.group_label_type == "icon":
            update_group_icon(qtile.groups_map[group_name])
            if not should_delete_group:
                update_group_icon(qtile.groups_map[current_group_name])
    else:
        logger.warning(f"[DEBUG] go to " + str(group_name))
        qtile.groups_map[group_name].toscreen()


def create_group(qtile, group_name):
    label = group_name
    if settings.group_label_type == 'ball':
        label = "○"
    qtile.add_group(
        name=group_name, 
        label=label, 
        layout="monadtall", 
        persist=True)


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
        if settings.group_label_type == "int":
            group.label = new_name
        qtile.groups_map[new_name] = group
    qtile.groups = [qtile.groups_map[name] for name in sorted(qtile.groups_map.keys(), key=int)]


def next_group(qtile):
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
            create_group(qtile, new_group_name)
            qtile.current_screen.set_group(qtile.groups_map[new_group_name], save_prev=False)
    else:
        next_group_name = str(current_index + 1)
        qtile.current_screen.set_group(qtile.groups_map[next_group_name], save_prev=False)

def previous_group(qtile):
    current_group = qtile.current_group
    current_index = int(current_group.name)

    if len(qtile.groups_map.keys()) == 1 and not current_group.windows:
        return
        
    if current_index == 1:
        new_group_name = str(len(qtile.groups_map.keys()) + 1)
        create_group(qtile, new_group_name)
        qtile.current_screen.set_group(qtile.groups_map[new_group_name], save_prev=False)
    else:
        qtile.current_screen.set_group(qtile.groups_map[str(current_index - 1)], save_prev=False)
        if current_index == len(qtile.groups_map.keys()) and not current_group.windows:
            delete_group(qtile, current_group.name)


def close_window(qtile):
    window = qtile.current_group.current_window
    if window is not None:
        group = window.group
        kill_group = len(group.windows) == 1
        # '-> If we put this in the if bellow, the if is called before the window is actually removed.
        #     We test if there is only 1 window left before, insthead of testing if there is 0 window left after.
        window.kill()
        if kill_group:
            delete_group(qtile, group.name)
        elif settings.group_label_type == "icon":
            update_group_icon(group)
    elif len(qtile.current_group.windows) == 0:
        # There is no focused window and the current group is empty
        # This elif is made so we can use the kill window shortcut to kill an empty group.
        delete_group(qtile, qtile.current_group.name)
