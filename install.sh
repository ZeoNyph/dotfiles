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
    then echo -e "\033[7:31""m WARNING:\033[0m You are running this as root. Please run this as a non-root user."
    exit
fi

echo -e "\033[7:32mRunning ZeoNyph's dotfiles install script...\033[0m"

echo -e "\033[7:32mUpdating system using pacman...\033[0m"
sudo pacman -Syu

sleep .5
if ! command -v yay &> /dev/null; then
    echo -e "\033[7:32""m Installing yay...\033[0m"
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git ~/yay && cd ~/yay && makepkg -si
    sudo rm ~/yay -r
else
    echo -e "\033[7:33""mYay already installed, skipping...\033[0m"
fi

sleep 1
echo -e "\033[7:32""mInstalling packages...\033[0m"
yay -S --needed - < ~/Repos/dotfiles/pkg.txt


sleep .5
if lspci -k -d ::03xx | grep -q "Intel"; then
    echo -e "\033[7:32m""Installing Intel GPU drivers...\033[0m"
    yay -S --needed mesa vulkan-intel
else
    echo -e "\033[7:33""mNo Intel GPU detected, skipping...\033[0m"
fi   

sleep .5
if lspci -k -d ::03xx | grep -q "NVIDIA"; then
    echo -e "\033[7:32""mInstalling NVIDIA GPU drivers...\033[0m"
    yay -S --needed nvidia-open nvidia-utils nvidia-settings
else
    echo -e "\033[7:33""mNo NVIDIA GPU detected, skipping...\033[0m"
fi   

sleep .5
if echo $SHELL | grep -q "zsh"; then
    echo -e "\033[7:33""mzsh already set as default shell, skipping...\033[0m"
else
    echo -e "\033[7:32""mSetting zsh as default shell...\033[0m"
    chsh -s /usr/bin/zsh
fi

sleep .5
if test -d ~/.oh-my-zsh; then
    echo -e "\033[7:33""mOh My Zsh already installed, skipping...\033[0m"
else
    echo -e "\033[7:32""mInstalling Oh My Zsh...\033[0m"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

sleep .5
if grep -q "powerlevel10k" ~/.zshrc; then 
    echo -e "\033[7:33""mPowerlevel10k already installed, skipping...\033[0m"
else
    echo -e "\033[7:32""mInstalling Powerlevel10k...\033[0m"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi

echo -e "\033[7:32""mInstalling SDDM theme...\033[0m"
sudo mkdir -p /etc/sddm.conf.d
yay -S sddm-theme-corners-git
sudo echo "[Theme]" >> /etc/sddm.conf.d/default.conf
sudo echo "Current=corners" >> /etc/sddm.conf.d/default.conf

echo -e "\033[7:32""mCopying dotfiles...\033[0m"
mkdir -p ~/.config/ && cp -r .config/* ~/.config/
mkdir -p ~/.config/ && cp -r .local/* ~/.local/

echo -e "\033[7:32""mCopying scripts...\033[0m"
mkdir -p ~/Scripts && cp -r Scripts/* ~/Scripts/ 

echo -e "\033[7:32""mCopying wallpapers...\033[0m"
mkdir -p ~/Pictures/Wallpapers && cp -r Wallpapers/* ~/Pictures/Wallpapers/

sleep .5
echo -e "\033[7:32""mSetting up systemd services...\033[0m"
sudo systemctl enable --now NetworkManager sddm bluetooth hostapd dnsmasq polkit udisks2 acpid power-profiles-daemon

clear
echo -e "\033[7:32""mDone! Reboot to see your changes.\033[0m"
exit 0
