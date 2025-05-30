import os


windows_border_width = 2
windows_margin = 8
terminal = "terminator"
home = os.path.expanduser('~')
group_label_type = "int"

# Groups  # Define how the groups appears in the top bar.
if group_label_type not in ["int", "ball"]:  # supported types
    group_label_type = "int"

# Theme colors
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