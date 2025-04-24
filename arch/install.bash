#!/bin/bash

### Install screen saver
# Step 1: Install dependencies
echo "Installing betterlockscreen and xss-lock..."
sudo pacman -S --noconfirm betterlockscreen xss-lock

# Step 2: Set up betterlockscreen service
echo "Setting up systemd service for betterlockscreen..."

# Create user systemd directory if it doesn't exist
mkdir -p ~/.config/systemd/user

# Create the service file
cat > ~/.config/systemd/user/betterlockscreen-suspend.service <<EOL
[Unit]
Description=Lock screen before suspend
Before=suspend.target

[Service]
Type=exec
ExecStart=/usr/bin/betterlockscreen -l
Environment=DISPLAY=:0
Environment=XAUTHORITY=/tmp/xauth_$(whoami)
Environment=PATH=/usr/local/bin:/usr/bin:/bin

[Install]
WantedBy=suspend.target
EOL

# Step 3: Reload systemd, enable and start the service
echo "Enabling and starting betterlockscreen service..."
systemctl --user daemon-reload
systemctl --user enable betterlockscreen-suspend.service
systemctl --user start betterlockscreen-suspend.service

# Step 4: Verify the setup
echo "Verifying betterlockscreen is ready..."
betterlockscreen -u ~/Pictures/wallpaper.jpg  # Add your wallpaper path here

echo "All done! Your screen will now lock before suspend."

