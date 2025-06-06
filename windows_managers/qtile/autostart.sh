#!/bin/bash

picom --config ~/.config/picom/picom.conf &
feh --bg-scale ~/Images/wallpapers/lake-reflection_2000x1334.jpg &

# Start gnome-keyring daemon
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export SSH_AUTH_SOCK
