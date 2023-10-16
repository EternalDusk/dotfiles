#!/bin/bash

Help()
{
	echo "Welcome to Dusk's arch install script (v2)";
	echo "This tool will help you on your journey to installing all the software I use daily!";
	echo "Simply run archInstallScript.sh to start!";
}

function install_all
{
	install_required
	install_i3
	install_customization
	install_software
}

function install_required
{
	echo "Installing base packages...";
	pacman -Syu
	pacman -S base-devel --noconfirm

	echo "Installing yay package manager...";
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin
	makepkg -si
	cd ..

	echo "Installing networking services...";
	pacman -S dhcpcd iwd --noconfirm

	echo "Starting networking services...";
	systemctl enable dhcpcd
	systemctl enable iwd
	systemctl start dhcpcd
	systemctl start iwd
	
	echo "Installing necessary packages... (This might take a while)";
	pacman -S neofetch rofi python  calc ranger w3m imlib2 mpv --noconfirm

	echo "Setting up ranger...";
	ranger --copy-config=all
	sed -i '/set preview_images false/c\set preview_images true' ~/.config/ranger/rc.conf

	echo "Installing thunar and gvfs(for automounted file browsing)...";
	pacman -S thunar gvfs --noconfirm

	echo "Installing git...";
	pacman -S git github-cli --noconfirm

	echo "Installing pavucontrol (audio mixer/management)...";
	pacman -S pavucontrol --noconfirm
}

function install_i3
{
	echo "Installing XORG (display server) and i3 gaps (window manager)...";
	pacman -S xorg-server xorg-apps xorg-xinit i3-gaps i3blocks i3lock numlockx --noconfirm

	echo "Installing LightDM (display manager)...";
	pacman -S lightdm lightdm-gtk-greeter lxappearance arc-gtk-theme papirus-icon-theme --needed --noconfirm

	echo "Enabling LightDM service...";
	systemctl enable lightdm

	echo "Applying xorg customizations...";
	echo "URxvt.scrollBar: false" >> ~/.Xresources
	xrdb ~/.Xresources
}

function install_customization
{
	echo "Installing fonts packages...";
	pacman -S noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont ttf-liberation ttf-droid ttf-roboto terminus-font rxvt-unicode --noconfirm

	echo "Installing font manager...";
	pacman -S font-manager --noconfirm

	echo "Installing polybar and polybar themes..."
	pacman -S polybar --noconfirm
	git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
	cd polybar-themes
	chmod +x setup.sh
	./setup.sh
	cd ..

	echo "Installing pywal..."
	pacman -S python-pywal --noconfirm

	echo "Downloading Dusks's wallpaper repo...";
	git clone https://github.com/EternalDusk/wallpapers.git
	
	echo "Copying setWallpaper.sh script to home directory...";
	cp ./setWallpaper.sh ~/
	chmod +x ~/setWallpaper.sh
}

function install_software
{
	echo "Installing firefox and pywalfox...";
	pacman -S firefox --noconfirm
	yay -S python-pywalfox

	echo "Installing discord, betterdiscordctl, and pywaldiscord... (Note:betterdiscordctl and pywal-discord install using yay, you will need to confirm)";
	pacman -S discord --noconfirm
	yay -S betterdiscordctl
	yay -S pywal-discord

	echo "Installing libreoffice...";
	pacman -S libreoffice-still --noconfirm

	echo "Installing ffmpeg and smplayer (video player)...";
	pacman -S ffmpeg smplayer smplayer-skins smplayer-themes --noconfirm

	echo "Installing obsidian...";
	pacman -S obsidian --noconfirm
}



echo "   ___               __          ___               __         ____             __          __   __        ____              _          __ "; 
echo "  / _ \ __ __  ___  / /__       / _ |  ____ ____  / /        /  _/  ___   ___ / /_ ___ _  / /  / /       / __/ ____  ____  (_)   ___  / /_";
echo " / // // // / (_-< /  '_/      / __ | / __// __/ / _ \      _/ /   / _ \ (_-</ __// _ \`/ / /  / /       _\ \  / __/ / __/ / /   / _ \/ __/";
echo "/____/ \_,_/ /___//_/\_\      /_/ |_|/_/   \__/ /_//_/     /___/  /_//_//___/\__/ \_,_/ /_/  /_/       /___/  \__/ /_/   /_/   / .__/\__/ ";
echo "                                                                                                                              /_/         ";

echo "==========================================================================================================================================";
echo "1) Install i3-gaps";
echo "2) Install required packages";
echo "3) Install software packages";
echo "4) Install customization packages";
echo "5) Install all";
echo "Option: ";

read n
case $n in
	1) install_i3 ;;
	2) install_required ;;
	3) install_software ;;
	4) install_customization ;;
	5) install_all ;;
esac



