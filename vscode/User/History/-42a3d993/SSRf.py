#!/home/hedwin/computing/home_venv/bin/python
import argparse
import os
from PIL import Image

def calculate_padded_size(target_size, padding_percentage):
    padding = int(target_size * padding_percentage / 100)
    new_size = target_size - padding
    return new_size, padding

def process_icon_with_padding(img, target_size, padding_percentage):
    new_size, padding = calculate_padded_size(target_size[0], padding_percentage)
    resized_img = img.resize((new_size, new_size), Image.Resampling.LANCZOS)
    
    # Create a transparent image
    final_img = Image.new("RGBA", target_size, (0, 0, 0, 0))
    position = (padding // 2, padding // 2)
    final_img.paste(resized_img, position, resized_img if resized_img.mode == 'RGBA' else None)
    
    return final_img

def verify_and_copy_icon(icon_path, new_name, target_dir, padding_percentage):
    if not os.path.isfile(icon_path):
        print(f"Icon not found: {icon_path}")
        return
    
    try:
        img = Image.open(icon_path).convert("RGBA")
    except Exception as e:
        print(f"Error opening image: {e}")
        return
    
    if img.size[0] < 512 or img.size[1] < 512:
        print(f"Invalid image size: {img.size}, expected (512, 512) or bigger.")
        return
    
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
    
    for folder, size in TARGET_SIZES.items():
        folder_path = os.path.join(target_dir, folder, 'apps')
        os.makedirs(folder_path, exist_ok=True)
        output_path = os.path.join(folder_path, new_name)
        
        if os.path.exists(output_path):
            os.remove(output_path)
            print(f"Removed existing icon: {output_path}")
        
        final_img = process_icon_with_padding(img, size, padding_percentage)
        final_img.save(output_path, format='PNG')
        print(f"Saved {output_path}")
    
    print("Icon processed successfully.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Resize and add padding to an icon.")
    parser.add_argument("-p", "--padding", type=int, default=0, help="Padding percentage")
    parser.add_argument("-n", "--names", nargs='+', help="One or more icon names to process")
    args = parser.parse_args()
    
    home_dir = os.path.expanduser("~")
    download_dir = os.path.join(home_dir, "Téléchargements")
    files = [f for f in os.listdir(download_dir) if os.path.isfile(os.path.join(download_dir, f))]
    
    for idx, file in enumerate(files, 1):
        print(f"{idx} - {file}")
    
    try:
        choice = int(input("Select a file number: "))
        if choice < 1 or choice > len(files):
            raise ValueError
    except ValueError:
        print("Invalid choice.")
        exit()
    
    icon_path = os.path.join(download_dir, files[choice - 1])
    target_dir = os.path.expanduser("~") + "/.local/share/icons/hbicons"
    # If no names are provided, ask the used to enter one.
    if not args.names:
        new_name_with_extension = input("Enter the new icon name (WITHOUT EXTENSION): ") + ".png"
        verify_and_copy_icon(icon_path, new_name_with_extension, target_dir, args.padding)
    else:
        for new_name in args.names:
            new_name_with_extension = new_name + ".png"
            verify_and_copy_icon(icon_path, new_name_with_extension, target_dir, args.padding)
