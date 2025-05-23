# -*- coding: utf-8 -*-
import os
import sys
import pathlib

parent_dir = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(parent_dir))

import settings
import subprocess
from typing import List
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.log_utils import logger
from utils.place_floating_window import place_floating_window

@hook.subscribe.startup_once
def set_wallpaper():
    subprocess.Popen(['feh', '--bg-scale', '/home/hedwin/images/wallpapers/samurai.jpg'])

# Constants
mod = "mod4"  # Super key
terminal = guess_terminal()
home = os.path.expanduser('~')

# Colors - Nord Theme
colors = {
    "polar_night1": "#2E3440",
    "polar_night2": "#3B4252",
    "polar_night3": "#434C5E",
    "polar_night4": "#4C566A",
    "snow_storm1": "#D8DEE9",
    "snow_storm2": "#E5E9F0",
    "snow_storm3": "#ECEFF4",
    "frost1": "#8FBCBB",
    "frost2": "#88C0D0",
    "frost3": "#81A1C1",
    "frost4": "#5E81AC",
    "aurora1": "#BF616A",  # Red
    "aurora2": "#D08770",  # Orange
    "aurora3": "#EBCB8B",  # Yellow
    "aurora4": "#A3BE8C",  # Green
    "aurora5": "#B48EAD",  # Purple
}

from libqtile import hook
import subprocess

@hook.subscribe.startup_once
def set_background():
    subprocess.run(["feh", "--bg-scale", "/home/hedwin/images/wallpapers/image.jpg"])

logger.warning("warning test")

# Keybindings
keys = [
    # Window management
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),

    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "m", lazy.layout.maximize(), desc="Toggle window between minimum and maximum sizes"),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),

    # Layout management
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Toggle between layouts reverse"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),

    # Qtile management
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "space", lazy.spawn("rofi -show drun"), desc="Application launcher"),
    Key([mod, "shift"], "space", lazy.spawn("rofi -show run"), desc="Command launcher"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Launch Firefox"),
    Key([mod], "e", lazy.spawn("thunar"), desc="Launch file manager"),

    # Audio controls
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t"), desc="Toggle volume on/off."),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 10"), desc="Volume down."),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 10"), desc="Volume up."),

    # Screen brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set 10%+"), desc="Brightness up"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-"), desc="Brightness down"),

    # Screenshot
    Key(["control"], "Print", lazy.spawn("flameshot full"), desc="Take screenshot"),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Take full screenshot"),
    Key(["mod1"], "w", lazy.function(place_floating_window, h_position="left", v_position="bottom"), desc="Move and resize window under mouse"),
    Key(["mod1"], "x", lazy.function(place_floating_window, h_position="full", v_position="bottom"), desc="Move and resize window under mouse"),
    Key(["mod1"], "c", lazy.function(place_floating_window, h_position="right", v_position="bottom"), desc="Move and resize window under mouse"),
    Key(["mod1"], "q", lazy.function(place_floating_window, h_position="left", v_position="full"), desc="Move and resize window under mouse"),
    Key(["mod1"], "s", lazy.function(place_floating_window, h_position="center", v_position="center"), desc="Move and resize window under mouse"),
    Key(["mod1"], "d", lazy.function(place_floating_window, h_position="right", v_position="full"), desc="Move and resize window under mouse"),
    Key(["mod1"], "a", lazy.function(place_floating_window, h_position="left", v_position="top"), desc="Move and resize window under mouse"),
    Key(["mod1"], "z", lazy.function(place_floating_window, h_position="full", v_position="top"), desc="Move and resize window under mouse"),
    Key(["mod1"], "e", lazy.function(place_floating_window, h_position="right", v_position="top"), desc="Move and resize window under mouse"),
    Key(["mod1"], "f", lazy.function(place_floating_window, h_position="full", v_position="full"), desc="Move and resize window under mouse"),

    Key(["mod1"], 87, lazy.function(place_floating_window, h_position="left", v_position="bottom"), desc="Move and resize window under mouse"),
    Key(["mod1"], 88, lazy.function(place_floating_window, h_position="full", v_position="bottom"), desc="Move and resize window under mouse"),
    Key(["mod1"], 89, lazy.function(place_floating_window, h_position="right", v_position="bottom"), desc="Move and resize window under mouse"),
    Key(["mod1"], 83, lazy.function(place_floating_window, h_position="left", v_position="full"), desc="Move and resize window under mouse"),
    Key(["mod1"], 84, lazy.function(place_floating_window, h_position="center", v_position="center"), desc="Move and resize window under mouse"),
    Key(["mod1"], 85, lazy.function(place_floating_window, h_position="right", v_position="full"), desc="Move and resize window under mouse"),
    Key(["mod1"], 79, lazy.function(place_floating_window, h_position="left", v_position="top"), desc="Move and resize window under mouse"),
    Key(["mod1"], 80, lazy.function(place_floating_window, h_position="full", v_position="top"), desc="Move and resize window under mouse"),
    Key(["mod1"], 81, lazy.function(place_floating_window, h_position="right", v_position="top"), desc="Move and resize window under mouse"),

    Key(["mod1"], "Up", lazy.function(place_floating_window, h_position="full", v_position="top"), desc="Move and resize window under mouse"),
    Key(["mod1"], "Left", lazy.function(place_floating_window, h_position="left", v_position="full"), desc="Move and resize window under mouse"),
    Key(["mod1"], "Down", lazy.function(place_floating_window, h_position="full", v_position="bottom"), desc="Move and resize window under mouse"),
    Key(["mod1"], "Right", lazy.function(place_floating_window, h_position="right", v_position="full"), desc="Move and resize window under mouse"),
]

# Custom keybinding

def delete_group(qtile, group):

    # Don't delete if the group is currently visible
    for screen in qtile.screens:
        if screen.group.name == group_name:
            print(f"Group '{group_name}' is currently visible — can't delete")
            return

    # Move windows to some fallback group if needed
    for w in group.windows:
        w.togroup(qtile.groups[0].name)

    # Now remove the group from Qtile
    qtile.groups.remove(group)
    del qtile.groups_map[group_name]
    print(f"Group '{group_name}' deleted.")

def next_group(qtile):
    groups = qtile.groups
    current_group = qtile.current_group
    index = groups.index(current_group)

    next_index = (index + 1) % len(groups)  # wrap around
    next_group = groups[next_index]

    qtile.groups_map[next_group.name].toscreen()

def remove_group(qtile):
    current = qtile.current_group

def new_group(qtile):
    Group("n", layout="monadtall")

def remove_focused_window(qtile):
    window = qtile.current_window
    if window is not None:
        group = window.group
        window.kill()
        if not group.windows:
            delete_group(qtile, group)

keys += [
    # Custom launch shortcut
    Key(["control", "mod1"], "f", lazy.spawn("firefox"), desc="Launch firefox."),
    Key(["control", "mod1"], "z", lazy.spawn("zed"), desc="Launch zed."),
    Key(["control", "mod1"], "d", lazy.spawn("discord"), desc="Launch discord."),
    Key(["control", "mod1"], "s", lazy.spawn("slack"), desc="Launch slack."),
    Key(["control", "mod1"], "t", lazy.spawn("terminator"), desc="Launch terminator."),
    Key(["control", "mod1"], "m", lazy.spawn("thunderbird"), desc="Launch thunderbird."),
    Key(["control", "mod1"], "n", lazy.spawn("nautilus"), desc="Open file navigator"),
    Key(["control", "mod1"], "p", lazy.spawn("pycharm-professional"), desc="Open pycharm"),
    # Key(["control", "mod1"], "", lazy.spawn(""), desc="Launch "),
    Key(["mod1"], "Tab", lazy.screen.next_group(), desc="Next group."),
    Key(["mod1"], 10, lazy.function(new_group), desc="Add new group."),
    Key(["control"], "d", lazy.function(remove_focused_window), desc="Remove the window curently focused."),
]

# Workspaces
group_names = [("1", {"layout": "monadtall"}), ("2", {"layout": "monadtall"})]
groups = [Group(name, **kwargs) for name, kwargs in group_names]
for i, (name, kwargs) in enumerate(group_names, 1):
    keys.extend([
        Key([mod], 9+i, lazy.group[name].toscreen(), desc=f"Switch to group {name}"),
        Key([mod, "shift"], 9+i, lazy.window.togroup(name, switch_group=True), desc=f"Switch to & move focused window to group {name}"),
    ])

# Layouts
layout_theme = {
    "border_width": settings.windows_border_width,
    "margin": settings.windows_margin,
    "border_focus": colors["frost3"],
    "border_normal": colors["polar_night2"],
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Max(**layout_theme),
    layout.Stack(num_stacks=2, **layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
]

# Widgets
widget_defaults = dict(
    font="JetBrains Mono Nerd Font",
    fontsize=12,
    padding=3,
    foreground=colors["snow_storm3"],
)
extension_defaults = widget_defaults.copy()

def init_widgets_list():
    return [
        widget.Sep(
            linewidth=0,
            padding=6,
            background=colors["polar_night1"],
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            background=colors["polar_night1"],
        ),
        widget.GroupBox(
            active=colors["snow_storm3"],
            inactive=colors["polar_night4"],
            highlight_method="line",
            highlight_color=[colors["polar_night1"], colors["polar_night1"]],
            this_current_screen_border=colors["frost3"],
            rounded=False,
            background=colors["polar_night1"],
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            scale=0.7,
            background=colors["polar_night1"],
        ),
        widget.Prompt(
            background=colors["polar_night2"],
            prompt="run: ",
            cursor_color=colors["frost3"],
        ),
        widget.WindowName(
            background=colors["polar_night2"],
            format="{name}",
            max_chars=40,
        ),
        widget.Chord(
            chords_colors={
                "launch": (colors["aurora4"], colors["snow_storm3"]),
            },
            name_transform=lambda name: name.upper(),
            background=colors["polar_night3"],
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            background=colors["polar_night3"],
        ),
        widget.Systray(
            background=colors["polar_night3"],
            padding=5,
        ),
        widget.Sep(
            linewidth=0,
            padding=6,
            background=colors["polar_night3"],
        ),
        widget.TextBox(
            text="",
            fontsize=16,
            background=colors["polar_night3"],
            foreground=colors["aurora4"],
            padding=0,
        ),
        # widget.Net(
        #     interface="wlp2s0",
        #     format="{down} ↓↑ {up}",
        #     background=colors["polar_night3"],
        #     foreground=colors["aurora4"],
        #     padding=5,
        # ),
        widget.TextBox(
            text="",
            fontsize=16,
            background=colors["polar_night3"],
            foreground=colors["aurora3"],
            padding=0,
        ),
        widget.Memory(
            background=colors["polar_night3"],
            foreground=colors["aurora3"],
            format="{MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}",
            measure_mem="G",
            padding=5,
        ),
        widget.TextBox(
            text="",
            fontsize=16,
            background=colors["polar_night3"],
            foreground=colors["aurora5"],
            padding=0,
        ),
        widget.CPU(
            background=colors["polar_night3"],
            foreground=colors["aurora5"],
            format="{load_percent}%",
            padding=5,
        ),
        widget.TextBox(
            text="",
            fontsize=16,
            background=colors["polar_night3"],
            foreground=colors["frost2"],
            padding=0,
        ),
        widget.Volume(
            background=colors["polar_night3"],
            foreground=colors["frost2"],
            fmt="Vol: {}",
            padding=5,
        ),
        widget.TextBox(
            text="",
            fontsize=16,
            background=colors["polar_night3"],
            foreground=colors["frost3"],
            padding=0,
        ),
        widget.Battery(
            background=colors["polar_night3"],
            foreground=colors["frost3"],
            format="{percent:2.0%} {hour:d}:{min:02d}",
            padding=5,
        ),
        widget.TextBox(
            text="",
            fontsize=16,
            background=colors["polar_night3"],
            foreground=colors["frost4"],
            padding=0,
        ),
        widget.Clock(
            background=colors["polar_night3"],
            foreground=colors["frost4"],
            format="%Y-%m-%d %a %I:%M %p",
            padding=5,
        ),
    ]

def init_screens():
    return [
        Screen(
            top=bar.Bar(
                widgets=init_widgets_list(),
                opacity=0.95,
                size=24,
                background=colors["polar_night1"],
            )
        ),
    ]

screens = init_screens()

# Mouse configuration
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    # Click([mod], "Button2", lazy.window.bring_to_front()),
    Drag([], "Button2", lazy.window.set_position_floating(), start=lazy.window.get_position())
]

# General configuration
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueberry"),
        Match(wm_class="nm-connection-editor"),
    ],
    **layout_theme
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"

# Autostart
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.Popen([home + '/.config/qtile/autostart.sh'])