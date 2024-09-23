#!/bin/bash

# Ensure the script is run with sudo or as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as sudo from the home directory, NOT AS ROOT" 
   exit 1
fi

LOGFILE="install.log"
exec > >(tee -i ${LOGFILE})
exec 2>&1


# ====== HELPER FUNCTIONS ======
Help()
{
	echo "Welcome to Dusk's arch install script (v3)";
	echo "This tool will help you on your journey to installing all the software I use daily!";
	echo "Simply run installScript.sh to start!";
}

function install_all
{
	install_required
	install_i3
	install_customization
	install_software
	update_config

	echo "< ! > Install Finished!";
}

function cpy() {
  if ! [ -d "$HOME/.config/$2" ]; then
    mkdir "$HOME/.config/$2"
  fi
  if [ -f "$HOME/.config/$2/$1" ]; then
    mv "$HOME/.config/$2/$1" "$HOME/.config/$2/$1.old"
  fi
  cp "$2/$1" "$HOME/.config/$2/"
}

update_config() {
	cd .config
	cpy alacritty.yml alacritty
	cpy config i3
	cpy picom.conf picom

	echo "Moving configuration files..."
}


install_pacman() {
    local package=$1
    
    # Check if package name is provided
    if [ -z "$package" ]; then
        echo "No package specified. Skipping installation."
        return 1
    fi
    
    echo "Installing $package..."
    
	# TODO check if --needed affects anything
    if pacman -S "$package" --noconfirm --needed; then
        echo "$package installed successfully."
    else
        echo "Failed to install $package."
    fi
}


# ====== REQUIRED PACKAGES ======
# pacman -Syu, make, git, github-cli, yay, dhcpcd, iwd
# neofetch, rofi, python, calc, w3m, imlib2, mpv, htop
# ranger, thunar, gvfs, pavucontrol

function install_required
{
	echo "Installing and updating base packages..."
	{
		pacman -Syu
		pacman -S base-devel --noconfirm
	} || echo "Failed to install base packages."

	install_pacman make

	# Need to add github-desktop as well
	install_pacman git
	install_pacman github-cli

	echo "Installing yay package manager..."
	{
		cd ~
		su -c "git clone https://aur.archlinux.org/yay-bin.git"
		cd yay-bin
		su -c "makepkg -si"
		cd ..
	} || echo "Failed to install yay package manager."

	echo "Installing networking services and starting them..."
	{
		install_pacman dhcpcd
		install_pacman iwd

		systemctl enable dhcpcd
		systemctl enable iwd
		systemctl start dhcpcd
		systemctl start iwd
	} || echo "Failed to install or start networking services."

	echo "Installing necessary packages... (This might take a while)"
	{
		# We iterate through each in case one throws errors
		for pkg in neofetch rofi python calc w3m imlib2 mpv htop; do
			install_pacman $pkg
		done
	} || echo "Failed to install necessary packages."

	echo "Installing and setting up ranger..."
	{
		install_pacman ranger
		# ENSURE THIS WORKS!
		ranger --copy-config=all
		sed -i '/set preview_images false/c\set preview_images true' ~/.config/ranger/rc.conf
	} || echo "Failed to set up ranger."

	# File Browser
	install_pacman thunar

	# Auto-mounting USBs and external storage
	install_pacman gvfs

	# Audio Mixer/Management
	install_pacman pavucontrol

	# Terminal
	install_pacman alacritty
	install_pacman fish
	echo cat \~/.cache/wal/sequences >> ~./config/fish/fish.conf
	echo source ~/.cache/wal/colors-tty.sh >> ~./config/fish/fish.conf
}


# ====== i3 PACKAGES ======
# xorg-apps, numlockx, lxappearance, arc-gtk-theme, papirus-icon-theme
# URxvt.scrollbar fix

function install_i3
{
	# removed i3-gaps, i3blocks, i3lock, xorg-server, xorg-xinit, assuming desktop i3-wm install. Might add back later
	install_pacman xorg-apps
	install_pacman numlockx

	# removed lightdm and lightdm-gtk-greeter, assuming desktop i3-wm install. Might add back later
	install_pacman lxappearance
	install_pacman arc-gtk-theme
	install_pacman papirus-icon-theme

	# Removed lightdm service, assuming desktop i3-wm install

	echo "Applying xorg customizations..."
	{
		echo "URxvt.scrollBar: false" >> ~/.Xresources
		xrdb ~/.Xresources
	} || echo "Failed to apply xorg customizations."
}


# ====== CUSTOMIZATION PACKAGES ======
# fonts (lsited below), wallpapers (from github), font-manager, picom, polybar, polybar-themes
# python-pywal, wal, feh, copies ./setWallpaper.sh script

function install_customization
{
	read -p "Do you want to install fonts packages? (y/n): " install_fonts
	if [[ $install_fonts == "y" ]]; then
		echo "Installing fonts packages..."
		{
			pacman -S noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont ttf-liberation ttf-droid ttf-roboto terminus-font rxvt-unicode --noconfirm
		} || echo "Failed to install fonts packages."
	fi

	install_pacman font-manager

	install_pacman picom

	# Add polybar setup to i3 automatically (might need to just add an i3.config file to copy)
	echo "Installing polybar and polybar themes..."
	{
		pacman -S polybar --noconfirm
		git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
		cd polybar-themes
		chmod +x setup.sh
		./setup.sh
		cd ..
	} || echo "Failed to install polybar and polybar themes."

	install_pacman wal
	install_pacman feh
	install_pacman python-pywal
	
	read -p "Do you want to download Dusk's wallpaper repo? (y/n): " download_wallpapers
	if [[ $download_wallpapers == "y" ]]; then
		echo "Downloading Dusk's wallpaper repo..."
		{
			git clone https://github.com/EternalDusk/wallpapers.git ~/wallpapers
		} || echo "Failed to download Dusk's wallpaper repo."
	fi

	echo "Copying setWallpaper.sh script to home directory..."
	{
		cp ./setWallpaper.sh ~/
		chmod +x ~/setWallpaper.sh
	} || echo "Failed to copy setWallpaper.sh script."
}


# ====== SOFTWARE PACKAGES ======

function install_software
{
	install_pacman firefox
	install_pacman discord

	echo "Installing betterdiscordctl..."
	{
		yay -S betterdiscordctl
	} || echo "Failed to install betterdiscordctl."

	install_pacman libreoffice-still

	install_pacman ffmpeg
	install_pacman smplayer
	install_pacman smplayer-skins
	install_pacman smplayer-themes

	install_pacman obsidian

	echo "Installing pywalfox..."
	{
		yay -S kando
	} || echo "Failed to install pywalfox."

	# Only if pywal is installed
	if pacman -Qs python-pywal > /dev/null ; then
		echo "Installing pywalfox..."
		{
			yay -S python-pywalfox
		} || echo "Failed to install pywalfox."

		echo "Installing pywal-discord..."
		{
			yay -S pywal-discord
		} || echo "Failed to install pywal-discord."
	fi

}

function menu_screen
{
	cd ~
	echo "Current working directory: ~";
	echo "   ___               __          ___               __         ____             __          __   __        ____              _          __ "; 
	echo "  / _ \ __ __  ___  / /__       / _ |  ____ ____  / /        /  _/  ___   ___ / /_ ___ _  / /  / /       / __/ ____  ____  (_)   ___  / /_";
	echo " / // // // / (_-< /  '_/      / __ | / __// __/ / _ \      _/ /   / _ \ (_-</ __// _ \`/ / /  / /       _\ \  / __/ / __/ / /   / _ \/ __/";
	echo "/____/ \_,_/ /___//_/\_\      /_/ |_|/_/   \__/ /_//_/     /___/  /_//_//___/\__/ \_,_/ /_/  /_/       /___/  \__/ /_/   /_/   / .__/\__/ ";
	echo "                                                                                                                              /_/         ";

	echo "==========================================================================================================================================";
	echo "1) Install i3 additions";
	echo "2) Install required packages";
	echo "3) Install software packages";
	echo "4) Install customization packages";
	echo "5) Copy configuration files";
	echo "6) Install all";
	echo "Option (e.g., 2, 4, 3): ";

	read options
	for option in $options; do
		case $option in
			1) install_i3 ;;
			2) install_required ;;
			3) install_software ;;
			4) install_customization ;;
			5) update_config ;;
			6) install_all ;;
		esac
	done
}

menu_screen
