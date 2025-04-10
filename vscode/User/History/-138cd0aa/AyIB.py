#!/home/hedwin/computing/home_venv/bin/python
import pathlib

# Define target sizes and folders

TARGET_SIZES = ['256x256', '256x256@2x', '128x128', '128x128@2x', '48x48', '48x48@2x', '32x32', '32x32@2x', '24x24', '24x24@2x', '22x22', '22x22@2x', '16x16@2x', '16x16',
def remove_icon(icon_name: str):
    target_dir = pathlib.Path("~").expanduser() / ".local" / "share" / "icons" / "hbicons"
    for directory in pathlib.Path(target_dir).iterdir():
        if directory.name not in TARGET_SIZES.keys():
            continue
        icon_path = directory / "apps" / icon_name
        icon_path.unlink()

parser = argparse.ArgumentParser(description="Remove an icon from its name.")
parser.add_argument("-n", "--names", nargs='+', help="One or more icon names to process")
args = parser.parse_args()

# If no names are provided, ask the used to enter one.
if not args.names:
    new_name = input("Enter the new icon name (WITHOUT EXTENSION): ") + ".png"
else:
    for new_name in args.names:
        new_name_with_extension = new_name + ".png"
        verify_and_copy_icon(icon_path, new_name_with_extension, target_dir, args.padding)

icon_name = input("Enter the new icon name (WITHOUT EXTENSION): ") + ".png"
target_dir = pathlib.Path("~").expanduser() / ".local" / "share" / "icons" / "hbicons"
for directory in pathlib.Path(target_dir).iterdir():
    if directory.name not in TARGET_SIZES.keys():
        continue
    icon_path = directory / "apps" / icon_name
    icon_path.unlink()
