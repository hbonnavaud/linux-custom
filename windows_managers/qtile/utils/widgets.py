
from libqtile import bar, layout, hook, qtile
from libqtile.config import Screen
from libqtile.widget import base
from qtile_extras.widget.decorations import RectDecoration
from qtile_extras import widget
import subprocess
import pathlib, os, sys
parent_dir = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(parent_dir))
# from nvidia_sensor_widget import NvidiaSensors2
# from cpu_widget import CPU3
import psutil
import settings


def group_decoration(padding=4):
    return {
        "padding": 4,
        "decorations": [
            RectDecoration(
                colour=settings.colors["bar_groups_background"], 
                radius=10, 
                filled=True, 
                padding_y=3, 
                group=True
            )
        ]
    }


def separator(width=10):
    return widget.TextBox(text="", width=10, **group_decoration())


def init_widgets_list():
    return [

        ###########################
        #       -----------       #
        #    Left widget group    #
        ###########################
        widget.GroupBox(
            highlight_method="block", 
            this_current_screen_border="#81a1c1",
            padding_x = 10 if settings.group_label_type == "icon" else None,
            padding_y = 6 if settings.group_label_type == "icon" else None,
            fontsize=15,
            center_aligned=True,  # <--- This is KEY for horizontal alignment
            disable_drag=True,
        **group_decoration()
        ),

        ###########################
        #       WIDE SPACER       #
        #   Center widget group   #
        ###########################

        widget.Spacer(length=bar.STRETCH),  # Stretch widgets to reate left, center, and right widget sections
        separator(5),  # Empty text widget to add some left padding
        widget.Clock(
            format="%a %d %b %Y - %H:%M",
            **group_decoration()
        ),
        separator(5),  # Empty text widget to add some right padding


        ##########################
        #      WIDE SPACER       #
        #   Right widget group   #
        ##########################

        widget.Spacer(length=bar.STRETCH),  # Stretch widgets to reate left, center, and right widget sections
        separator(5),  # Empty text widget to add some left padding
        widget.TextBox(
            text="", 
            font="JetBrainsMono Nerd Font", 
            fontsize=16,
            width=22,
            foreground=settings.colors["memory_foreground"],
            **group_decoration()
        ),
        widget.Memory(
            format="{MemUsed:.0f}G", 
            measure_mem="G", 
            foreground=settings.colors["memory_foreground"],
            **group_decoration()
        ),
        separator(),  # Empty text widget to space widgets subgroups
        widget.TextBox(
            text="", 
            font="JetBrainsMono Nerd Font", 
            fontsize=16,
            width=22,
            foreground=settings.colors["cpu_foreground"],
            **group_decoration()
        ),
        widget.CPU(
            format="{load_percent}%", 
            foreground=settings.colors["cpu_foreground"],
            **group_decoration()
        ),
        separator(),  # Empty text widget to space widgets subgroups
        widget.TextBox(
            text="󰾲",
            font="JetBrainsMono Nerd Font", 
            fontsize=25, 
            width=26,
            foreground=settings.colors["gpu_foreground"],
            **group_decoration()
        ),
        widget.GPU(
            foreground=settings.colors["gpu_foreground"],
            **group_decoration()
        ),
        separator(),  # Empty text widget to space widgets subgroups
        widget.TextBox(
            text="", 
            font="JetBrainsMono Nerd Font", 
            fontsize=16,
            width=23,
            foreground=settings.colors["volume_foreground"],
            **group_decoration()
        ),
        widget.Volume(
            fmt="{}", 
            foreground=settings.colors["volume_foreground"],
            **group_decoration()
        ),
        separator(),  # Empty text widget to space widgets subgroups
        widget.TextBox(
            text="",
            fontsize=16,
            foreground=settings.colors["system_foreground"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("reboot")
            },
            tooltip="Shutdown",
            **group_decoration()
        ),
        # widget.ScriptExit(
        #     default_text="",
        #     fontsize=16,
        #     foreground=settings.colors["system_foreground"],
        #     mouse_callbacks={
        #         "Button1": lambda: qtile.cmd_spawn("reboot")
        #     },
        #     tooltip="Shutdown",
        #     **group_decoration()
        # ),
        separator(),  # Empty text widget to space widgets subgroups
        widget.TextBox(
            text="⏻",
            fontsize=14,
            foreground=settings.colors["system_foreground"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("shutdown now")
            },
            tooltip="Shutdown",
            **group_decoration()
        ),
        separator(),  # Empty text widget to space widgets subgroups

    ]
