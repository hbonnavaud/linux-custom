#!/home/hedwin/computing/home_venv/bin/python
import pathlib

# Define target sizes and folders
TARGET_SIZES = {
    '256x256': (256, 256),
    '256x256@2x': (512, 512),
    '128x128': (128, 128),
    '128x128@2x': (256, 256),
    '48x48': (48, 48),
    '48x48@2x': (96, 96),
    '32x32': (32, 32),
    '32x32@2x': (64, 64),
    '24x24': (24, 24),
    '24x24@2x': (48, 48),
    '22x22': (22, 22),
    '22x22@2x': (44, 44),
    '16x16@2x': (32, 32),
    '16x16': (16, 16)
}

parser = argparse.ArgumentParser(description="Remove an icon from its name.")
parser.add_argument("-n", "--names", nargs='+', help="One or more icon names to process")

icon_name = input("Enter the new icon name (WITHOUT EXTENSION): ") + ".png"
target_dir = pathlib.Path("~").expanduser() / ".local" / "share" / "icons" / "hbicons"
for directory in pathlib.Path(target_dir).iterdir():
    if directory.name not in TARGET_SIZES.keys():
        continue
    icon_path = directory / "apps" / icon_name
    icon_path.unlink()
