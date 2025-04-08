# update
sudo pacman -Syu

# install terminator
pacman -S terminator
xdg-mime default terminator.desktop x-scheme-handler/terminal  # set terminator as the default terminal

# Install thunar file manager
pacman -S thunar thunar-volman tumbler
# Set default terminal emulator for thunar
mkdir -p $HOME/.config/xfce4
touch $HOME/.config/xfce4/helpers.rc
echo "TerminalEmulator=terminator" >> $HOME/.config/xfce4/helpers.rc
echo "TerminalEmulatorDismissed=true" >> $HOME/.config/xfce4/helpers.rc

# Install image viewer
pacman -S feh

# Install open source vscode
pacman -S code
