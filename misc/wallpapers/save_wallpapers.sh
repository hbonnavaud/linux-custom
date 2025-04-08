echo " > Copying images ..."
PICTURES_DIR=$(xdg-user-dir PICTURES)

if [ ! -d "$PICTURES_DIR" ]; then
    echo "Destination directory $PICTURES_DIR does not exist."
    exit 1
fi

WALLPAPERS_DIR=$PICTURES_DIR/wallpapers/
mkdir -p $WALLPAPERS_DIR

script_dir=$(dirname "$(realpath "$0")")
image_extensions=("jpg" "jpeg" "png" "gif" "bmp" "tiff")
video_extensions=("mp4" "mkv" "avi" "mov" "webm")
copy_files() {
    local extension=$1
    for file in "$script_dir"/*.$extension; do
        if [ -f "$file" ]; then
            echo "Copying: $file"
            cp "$file" "$WALLPAPERS_DIR"
        fi
    done
}

# Iterate over image and video extensions and copy matching files
for ext in "${image_extensions[@]}"; do
    copy_files "$ext"
done

for ext in "${video_extensions[@]}"; do
    copy_files "$ext"
done

echo "Copying completed."