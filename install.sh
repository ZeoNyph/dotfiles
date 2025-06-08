#!/bin/bash

# Author: ZeoNyph
# This script is meant to be run on a minimal Arch Linux installation.

echo "export CLICOLOR=1" >> ~/.bashrc

cat << "EOF"
.___                 __         .__  .__          __  .__               
|   | ____   _______/  |______  |  | |  | _____ _/  |_|__| ____   ____  
|   |/    \ /  ___/\   __\__  \ |  | |  | \__  \\   __\  |/  _ \ /    \ 
|   |   |  \\___ \  |  |  / __ \|  |_|  |__/ __ \|  | |  (  <_> )   |  \
|___|___|  /____  > |__| (____  /____/____(____  /__| |__|\____/|___|  /
         \/     \/            \/               \/                    \/ 
         
EOF

if [ $(id -u) == 0 ]
    then echo -e "\033[31mWARNING:\033[0m You are running this as root. Please run this as a non-root user."
    exit
fi

SCRIPT_DIR=$(dirname "$(realpath $0)")

echo -e "\033[32mRunning ZeoNyph's dotfiles install script...\033[0m"

# System update + Install yay 

echo -e "\033[32mUpdating system using pacman...\033[0m"
sudo pacman -Syu

sleep .5
clear
if ! command -v yay &> /dev/null; then
    echo -e "\033[32""m Installing yay...\033[0m"
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git ~/yay && cd ~/yay && makepkg -si
    sudo rm ~/yay -r
else
    echo -e "\033[33""mYay already installed, skipping...\033[0m"
fi

# Install dependencies

sleep 1
clear
echo -e "\033[32""mInstalling packages...\033[0m"
yay -S --needed - < "$SCRIPT_DIR/deps.txt"

# Install GPU drivers

sleep .5
clear
echo -e "\033[32m""Installing base GPU drivers...\033[0m"
yay -S --needed mesa
if lspci -k -d ::03xx | grep -q "Intel"; then
    echo -e "\033[32m""Installing Intel GPU drivers...\033[0m"
    yay -S --needed vulkan-intel
fi
if lspci -k -d ::03xx | grep -q "NVIDIA"; then
    echo -e "\033[32""mInstalling NVIDIA GPU drivers...\033[0m"
    yay -S --needed nvidia-open nvidia-utils nvidia-settings
elif lspci -k -d ::03xx | grep -q "AMD"; then
    echo -e "\033[32m""Installing AMD GPU drivers...\033[0m"
    yay -S --needed mesa vulkan-radeon
    
fi   

# Set shell and prompt (zsh, oh-my-zsh, powerlevel10k)

sleep .5
clear
if echo $SHELL | grep -q "zsh"; then
    echo -e "\033[33""mzsh already set as default shell, skipping...\033[0m"
else
    echo -e "\033[32""mSetting zsh as default shell...\033[0m"
    chsh -s /usr/bin/zsh
fi

sleep .5
clear
if test -d ~/.oh-my-zsh; then
    echo -e "\033[33""mOh My Zsh already installed, skipping...\033[0m"
else
    echo -e "\033[32""mInstalling Oh My Zsh...\033[0m"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

sleep .5
clear
if grep -q "powerlevel10k" ~/.zshrc; then 
    echo -e "\033[33""mPowerlevel10k already installed, skipping...\033[0m"
else
    echo -e "\033[32""mInstalling Powerlevel10k...\033[0m"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi

# Install SDDM theme

sleep .5
clear
echo -e "\033[32""mInstalling SDDM theme...\033[0m"
sudo mkdir -p /etc/sddm.conf.d
yay -S sddm-theme-corners-git
echo -e "\033[32""mEditing SDDM config...\033[0m"
sudo echo -e "[Theme]\nCurrent=corners" | sudo tee -a /etc/sddm.conf.d/default.conf > /dev/null

# Copy configs, scripts and wallpapers

sleep .5
clear
echo -e "\033[32""mCopying dotfiles...\033[0m"
mkdir -p ~/.config/ && cp -r "$SCRIPT_DIR/.config/"* ~/.config/

echo -e "\033[32""mCopying scripts...\033[0m"
mkdir -p ~/Scripts && cp -r "$SCRIPT_DIR/Scripts/"* ~/Scripts/

echo -e "\033[32""mCopying wallpapers...\033[0m"
mkdir -p ~/Pictures/Wallpapers && cp -r "$SCRIPT_DIR/Wallpapers/"* ~/Pictures/Wallpapers/

# Final steps

sleep .5
clear
echo -e "\033[32""mSetting up systemd services...\033[0m"
sudo systemctl enable --now NetworkManager bluetooth hostapd dnsmasq polkit udisks2 acpid
systemctl enable --user waybar
sudo systemctl enable sddm # done separately to avoid sudden SDDM bootup

clear
echo -e "\033[32""mDone! Reboot to see your changes.\033[0m"
exit 0
