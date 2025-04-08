
# Make sure the script run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "🔄 Adding non-free and contrib to /etc/apt/sources.list..."

# Create a temporary file to store the modified lines
temp_file=$(mktemp)
# Read the /etc/apt/sources.list file line by line
while IFS= read -r line; do
  # Check if the line starts with deb or deb-src
  if [[ $line == deb* || $line == deb-src* ]]; then
    # Extract the URL and components
    url=$(echo $line | awk '{print $1 " " $2}')
    components=$(echo $line | awk '{$1=$2=""; print $0}' | sed 's/^[ \t]*//')
    # Split components into an array
    IFS=' ' read -r -a comp_array <<< "$components"
    # Check if non-free and contrib are already in the components
    if [[ ! " ${comp_array[@]} " =~ " non-free " ]]; then
      comp_array+=("non-free")
    fi
    if [[ ! " ${comp_array[@]} " =~ " contrib " ]]; then
      comp_array+=("contrib")
    fi
    # Join the components back into a string
    new_components=$(IFS=" "; echo "${comp_array[*]}")
    # Write the modified line to the temporary file
    echo "$url $new_components" >> "$temp_file"
  else
    # Write the original line to the temporary file
    echo "$line" >> "$temp_file"
  fi
done < /etc/apt/sources.list

# Replace the original file with the modified file
mv "$temp_file" /etc/apt/sources.list
echo "DONE."

echo "🔄 Updating package list..."
sudo apt update -y
sudo apt install -y ncdu wget gpg apt-transport-https python3-venv

# Remove useless games
echo "🧹️ removing useless packages ..."
sudo apt remove --purge -y \
	gnome-games \
	gnome-weather \
	gnome-music \
	evolution \
	gnome-clocks \
	gnome-maps
sudo apt autoremove -y

# Create a default python virtual env with a command to copy it  
echo "💻 Creating default virtual environment..."
python3 -m venv $HOME/home_venv
echo "✅ Default virtual environment created at $HOME/copy_venv"

# Create a script to copy a virtual environment
COPY_VENV_SCRIPT="/bin/copy_venv"

# Write the script content
sudo bash -c "cat > /bin/copy_venv" << 'EOF'
#!/bin/bash
# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: copy_venv <source_venv> <destination_venv>"
    exit 1
fi
SOURCE_VENV=$1
DEST_VENV=$2
# Copy the virtual environment
cp -r $SOURCE_VENV $DEST_VENV
echo "Virtual environment copied from $SOURCE_VENV to $DEST_VENV"
EOF
sudo chmod +x /bin/copy_venv  # Make the script executable
echo "Script installed at /bin/copy_venv"
echo "You can now use the command 'copy_venv <source_venv> <destination_venv>' to copy virtual environments."

# install docker
echo ""
echo "╔════════════════════════════════════╗"
echo "║         🚀 Installing Docker       ║"
echo "╚════════════════════════════════════╝"
echo ""
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "🔄 Updating package list..."
sudo apt update -y
echo "🐳 Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io
echo "🚀 Setting up Docker..."
sudo systemctl start docker
sudo systemctl enable docker
echo "✅ Docker installation completed!"

# install visual studio code
echo ""
echo "╔════════════════════════════════════╗"
echo "║         🚀 Installing VSCode       ║"
echo "╚════════════════════════════════════╝"
echo ""
echo "🔄 Updating package list..."
sudo apt update -y
echo "🔽 Installing dependencies..."
sudo apt install -y software-properties-common wget
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo mkdir -p /usr/share/keyrings/
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
echo "🔄 Updating package list..."
sudo apt update -y
echo "💻 Installing VSCode..."
sudo apt install -y code
echo "✅ VSCode installation completed!"

# Install Slack
echo ""
echo "╔════════════════════════════════════╗"
echo "║         🚀 Installing Slack        ║"
echo "╚════════════════════════════════════╝"
echo ""
echo "🔽 Downloading .deb"
wget https://downloads.slack-edge.com/releases/linux/4.30.165/prod/x64/slack-desktop-4.30.165-amd64.deb -O slack.deb  # Download Slack package
echo "💬 Installing Slack..."
sudo apt install -y ./slack.deb  # Install Slack package
echo "🧹️ Cleaning .deb ..."
rm slack.deb  # Clean up Slack installer
echo "✅ Slack installation completed!"

# Install Discord
echo ""
echo "╔════════════════════════════════════╗"
echo "║        🚀 Installing Discord       ║"
echo "╚════════════════════════════════════╝"
echo ""
echo "🔽 Downloading .deb"
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O discord.deb # Download Discord package
echo "🎧 Installing Discord..."
sudo apt install -y ./discord.deb  # Install Discord package
echo "🧹️ Cleaning .deb ..."
rm discord.deb  # Clean up Discord installer
echo "✅ Discord installation completed!"

# Install steam
echo ""
echo "╔════════════════════════════════════╗"
echo "║         🚀 Installing Steam        ║"
echo "╚════════════════════════════════════╝"
echo ""
echo "🔄 Updating package list..."
sudo dpkg --add-architecture i386
sudo apt update -y
sudo apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo dpkg -i steam.deb
sudo apt-get install -f
echo "✅ Steam installation completed!"

# Install Thunderbird
echo ""
echo "╔════════════════════════════════════╗"
echo "║      🚀 Installing Thunderbird     ║"
echo "╚════════════════════════════════════╝"
echo ""
echo "🔄 Updating package list..."
sudo apt update -y
echo "🎮 Installing thunderbird ..."
sudo apt install -y thunderbird
echo "✅ Thunderbird installation completed!"

# Install Gimp
echo ""
echo "╔════════════════════════════════════╗"
echo "║         🚀 Installing Gimp         ║"
echo "╚════════════════════════════════════╝"
echo ""
echo "🔄 Updating package list..."
sudo apt update -y
echo "🎮 Installing gimp..."
sudo apt install -y gimp
echo "✅ Gimp installation completed!"
echo ""
echo "╔════════════════════════════════════╗"
echo "║        🚀 Setup new installs       ║"
echo "╚════════════════════════════════════╝"
echo ""
echo " > launching steam update ..."
sudo steam &
echo " > launching slack ..."
sudo slack &
