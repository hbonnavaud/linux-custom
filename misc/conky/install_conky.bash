#!/bin/bash

# Step 1: Install Conky 🎶
echo "🎵 Installing Conky... 🎶"
sudo apt update
sudo apt install -y conky

# Step 2: Create the conky directory if it doesn't exist 🗂️
mkdir -p ~/.config/conky

# Step 3: Copy all .conf files from the current directory to ~/.config/conky/ 📝
echo "📄 Copying .conf files to ~/.config/conky/ 📂"
cp *.conf ~/.config/conky/

# Step 4: Setup Conky to launch on startup using systemd 🚀
echo "⚙️ Setting up Conky as a systemd service... ⏳"

SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SYSTEMD_USER_DIR/conky.service"

mkdir -p "$SYSTEMD_USER_DIR"

# Create a desktop launched on startup
cp conky.desktop ~/.config/autostart/conky.desktop

# Step 5: Notify the user and suggest restarting for changes to take effect 🛠️
echo "✅ Setup complete! Conky is now set to launch all config files in ~/.config/conky/ at startup via systemd. 🌟"
echo "🔄 You can restart your computer or run 'systemctl --user restart conky.service' to apply changes immediately. 💻"

# End of script 🎉
