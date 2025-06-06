# -*- coding: utf-8 -*-

#########################################################
###                      IMPORTS                      ###
#########################################################

import os
import sys
import pathlib
import subprocess
from typing import List
from libqtile import bar, layout, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.log_utils import logger
from libqtile.utils import send_notification
from qtile_extras.widget.decorations import RectDecoration
from qtile_extras import widget
# logger.warning("This is a warning log from config.py")

parent_dir = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(parent_dir))

from utils.floating_windows import place_floating_window
from utils.groups import close_window, next_group, previous_group, switch_to_group, update_group_icon
from utils.widgets import init_widgets_list

########################################################
###                     SETTINGS                     ###
########################################################

mod = "mod4"  # Super key
from utils import settings

#########################################################
###                  FEH (WALLPAPER)                  ###
#########################################################

@hook.subscribe.startup_once
def set_wallpaper():
    subprocess.Popen(['feh', '--bg-scale', '/home/hedwin/images/wallpapers/samurai.jpg'])

#########################################################
###                   BASE KEYBINDS                   ###
#########################################################

keys = [
    # Window management
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Up", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Down", lazy.layout.up(), desc="Move focus up"),

    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "Up", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Down", lazy.layout.grow_up(), desc="Grow window up"),

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
    Key([mod], "space", lazy.spawn("rofi -show drun"), desc="Application launcher"),

    # Audio controls
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t"), desc="Toggle volume on/off."),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 10"), desc="Volume down."),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 10"), desc="Volume up."),

    # Screen brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set 10%+"), desc="Brightness up"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-"), desc="Brightness down"),

    # Screenshot
    Key(["control"], 118, lazy.spawn("flameshot full"), desc="Take screenshot"),
    Key([], 118, lazy.spawn("flameshot gui"), desc="Take full screenshot"),
    Key(["mod1"], "w", lazy.function(place_floating_window, h_position="left", v_position="bottom", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "x", lazy.function(place_floating_window, h_position="full", v_position="bottom", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "c", lazy.function(place_floating_window, h_position="right", v_position="bottom", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "q", lazy.function(place_floating_window, h_position="left", v_position="full", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "s", lazy.function(place_floating_window, h_position="center", v_position="center", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "d", lazy.function(place_floating_window, h_position="right", v_position="full", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "a", lazy.function(place_floating_window, h_position="left", v_position="top", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "z", lazy.function(place_floating_window, h_position="full", v_position="top", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "e", lazy.function(place_floating_window, h_position="right", v_position="top", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], "f", lazy.function(place_floating_window, h_position="full", v_position="full", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),

    Key(["mod1"], 87, lazy.function(place_floating_window, h_position="left", v_position="bottom", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 88, lazy.function(place_floating_window, h_position="full", v_position="bottom", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 89, lazy.function(place_floating_window, h_position="right", v_position="bottom", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 83, lazy.function(place_floating_window, h_position="left", v_position="full", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 84, lazy.function(place_floating_window, h_position="center", v_position="center", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 85, lazy.function(place_floating_window, h_position="right", v_position="full", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 79, lazy.function(place_floating_window, h_position="left", v_position="top", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 80, lazy.function(place_floating_window, h_position="full", v_position="top", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse"),
    Key(["mod1"], 81, lazy.function(place_floating_window, h_position="right", v_position="top", windows_margin=settings.windows_margin, windows_border_width=settings.windows_border_width), desc="Move and resize window under mouse")
]


########################################################
###                   APPLICATIONS                   ###
########################################################

def open_or_focus(qtile, command):
    app_name = command.split()[0].lower()
    logger.warning(f"[DEBUG] open_or_focus called with: {command}")

    for window in qtile.windows_map.values():
        wm_class = window.get_wm_class()
        if wm_class and app_name in [cls.lower() for cls in wm_class]:
            logger.warning(f"[DEBUG] Found window: {window.name}, WM_CLASS: {wm_class}")
            group = window.group
            if group:
                logger.warning(f"[DEBUG] Found group: {group.name}, focusing it.")
                qtile.current_screen.set_group(group)
                group.focus(window, warp=True)
            return

    logger.warning(f"[DEBUG] App not found, spawning: {command}")
    qtile.cmd_spawn(command)


# keys += [
#     # Custom launch shortcut
#     Key(["control", "mod1"], "e", lazy.spawn("thunar"), desc="Launch explorer."),
#     Key(["control", "mod1"], "c", lazy.spawn("code"), desc="Launch ide."),
#     Key(["control", "mod1"], "f", lazy.function(open_or_focus, command="firefox"), desc="Launch firefox."),
#     Key(["control", "mod1"], "z", lazy.function(open_or_focus, command="zed"), desc="Launch zed."),
#     Key(["control", "mod1"], "d", lazy.function(open_or_focus, command="discord"), desc="Launch discord."),
#     Key(["control", "mod1"], "s", lazy.function(open_or_focus, command="slack"), desc="Launch slack."),
#     Key(["control", "mod1"], "t", lazy.spawn("terminator"), desc="Launch terminator."),
#     Key(["control", "mod1"], "m", lazy.function(open_or_focus, command="thunderbird"), desc="Launch thunderbird."),
#     Key(["control", "mod1"], "n", lazy.spawn("nautilus"), desc="Open file navigator"),
#     Key(["control", "mod1"], "p", lazy.function(open_or_focus, command="pycharm-professional"), desc="Open pycharm"),
# ]

keys += [
    # Custom launch shortcut
    Key(["control", "mod1"], "e", lazy.spawn("thunar"), desc="Launch explorer."),
    Key(["control", "mod1"], "c", lazy.spawn("code"), desc="Launch ide."),
    Key(["control", "mod1"], "f", lazy.spawn("firefox"), desc="Launch firefox."),
    Key(["control", "mod1"], "z", lazy.spawn("zed"), desc="Launch zed."),
    Key(["control", "mod1"], "d", lazy.spawn("discord"), desc="Launch discord."),
    Key(["control", "mod1"], "s", lazy.spawn("slack"), desc="Launch slack."),
    Key(["control", "mod1"], "t", lazy.spawn("terminator"), desc="Launch terminator."),
    Key(["control", "mod1"], "m", lazy.spawn("thunderbird"), desc="Launch thunderbird."),
    Key(["control", "mod1"], "n", lazy.spawn("nautilus"), desc="Open file navigator"),
    Key(["control", "mod1"], "p", lazy.spawn("pycharm-professional"), desc="Open pycharm"),
]

########################################################
###                      GROUPS                      ###
########################################################

# Create a default group
groups = [Group(name="1", label="◉", layout="monadtall", persist=True)]

for i in range(1, 10):
    keys.extend([
        Key(["mod4"], 9 + i, lazy.function(switch_to_group, group_name=str(i), window=False), desc=f"Switch to group {i}"),
        Key(["mod4", "shift"], 9 + i, lazy.function(switch_to_group, group_name=str(i), window=True), desc=f"Switch to & move focused window to group {i}"),
    ])

# Add group management shortcuts
keys += [
    Key([mod], "d", lazy.function(close_window), desc="Close the focused window."),
    Key(["mod1", "shift"], "Tab", lazy.function(previous_group), desc="Go to previous group."),
    Key(["mod1"], "Left", lazy.function(previous_group), desc="Go to previous group."),
    Key(["mod1"], "Tab", lazy.function(next_group), desc="Go to next group."),
    Key(["mod1"], "Right", lazy.function(next_group), desc="Go to next group."),
]

if settings.group_label_type == "ball":
    @hook.subscribe.setgroup
    def setgroup():
        for group in qtile.groups:
            group.label = "○"
        qtile.current_group.label = "◉"
elif settings.group_label_type == "icon":

    @hook.subscribe.client_new
    def on_window_open(window):
        max_retries = 5
        retry_delay = 0.05  # seconds

        def update_later(attempt=1):
            if window.group:
                update_group_icon(window.group)
            elif attempt < max_retries:
                qtile.call_later(retry_delay, lambda: update_later(attempt + 1))

        if window.group:
            update_group_icon(window.group)
        else:
            qtile.call_later(retry_delay, update_later)


#########################################################
###                      LAYOUTS                      ###
#########################################################

# float_rules = [
#     Match(wm_class="thunar"),
#     Match(title="nautilus"),
# ]
layout_theme = {
    "border_width": settings.windows_border_width,
    "margin": settings.windows_margin,
    "border_focus": settings.colors["frost3"],
    "border_normal": settings.colors["polar_night2"],
}

# layouts = [
#     layout.MonadTall(float_rules=float_rules, **layout_theme),
#     layout.MonadWide(float_rules=float_rules, **layout_theme),
#     layout.Max(float_rules=float_rules, **layout_theme),
#     layout.Stack(float_rules=float_rules, num_stacks=2, **layout_theme),
#     layout.Bsp(float_rules=float_rules, **layout_theme),
#     layout.Floating(float_rules=float_rules, **layout_theme),
# ]

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Max(**layout_theme),
    layout.Stack(num_stacks=2, **layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
]

# Widget
widget_defaults = dict(
    font="JetBrains Mono Nerd Font",
    fontsize=12,
    padding=3,
    foreground=settings.colors["snow_storm3"],
)
extension_defaults = widget_defaults.copy()

#########################################################
###                      WIDGETS                      ###
#########################################################

logger.warning(f"[DEBUG] top_bar_margin {settings.top_bar_margin}")
screens = [
    Screen(
        top=bar.Bar(
            init_widgets_list(),
            background="#00000000",
            size=28,
            margin=settings.top_bar_margin,  # Top, Right, Bottom, Left
        ),
    )
]

# Mouse configuration
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    # Click([mod], "Button2", lazy.window.bring_to_front()),
    # Drag([], "Button2", lazy.window.set_position_floating(), start=lazy.window.get_position())
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

#########################################################
###                     AUTOSTART                     ###
#########################################################

@hook.subscribe.startup_once
def autostart():
    subprocess.Popen([settings.home + '/.config/qtile/autostart.sh'])
