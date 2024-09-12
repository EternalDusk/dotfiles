#!/bin/bash

# Ensure the script is run with sudo or as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

LOGFILE="install.log"
exec > >(tee -i ${LOGFILE})
exec 2>&1

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
}

function install_required
{
	echo "Installing and updating base packages..."
	{
		pacman -Syu
		pacman -S base-devel --noconfirm
	} || echo "Failed to install base packages."

	echo "Installing make..."
	{
		pacman -S make --noconfirm
	} || echo "Failed to install make."

	# Need to add github-desktop as well
	echo "Installing git..."
	{
		pacman -S git github-cli --noconfirm
	} || echo "Failed to install git."

	echo "Installing yay package manager..."
	{
		su -c "git clone https://aur.archlinux.org/yay-bin.git"
		cd yay-bin
		su -c "makepkg -si"
		cd ..
	} || echo "Failed to install yay package manager."

	echo "Installing networking services and starting them..."
	{
		pacman -S dhcpcd iwd --noconfirm
		systemctl enable dhcpcd
		systemctl enable iwd
		systemctl start dhcpcd
		systemctl start iwd
	} || echo "Failed to install or start networking services."

	echo "Installing necessary packages... (This might take a while)"
	{
		# We iterate through each in case one throws errors
		for pkg in neofetch rofi python calc w3m imlib2 mpv htop; do
			pacman -S $pkg --noconfirm || echo "Failed to install $pkg."
		done
	} || echo "Failed to install necessary packages."

	echo "Installing and setting up ranger..."
	{
		pacman -S ranger --noconfirm
		ranger --copy-config=all
		sed -i '/set preview_images false/c\set preview_images true' ~/.config/ranger/rc.conf
	} || echo "Failed to set up ranger."

	echo "Installing thunar and gvfs (for auto-mounting and file browsing)..."
	{
		pacman -S thunar gvfs --noconfirm
	} || echo "Failed to install thunar and gvfs."

	echo "Installing pavucontrol (audio mixer/management)..."
	{
		pacman -S pavucontrol --noconfirm
	} || echo "Failed to install pavucontrol."
}

function install_i3
{
	echo "Installing XORG (display server)..."
	{
		# removed i3-gaps, i3blocks, i3lock, xorg-server, xorg-xinit, assuming desktop i3-wm install. Might add back later
		pacman -S xorg-apps numlockx --noconfirm
	} || echo "Failed to install XORG and i3 gaps."

	echo "Installing LightDM (display manager) appearance and themes..."
	{
		# removed lightdm and lightdm-gtk-greeter, assuming desktop i3-wm install. Might add back later
		pacman -S lxappearance arc-gtk-theme papirus-icon-theme --needed --noconfirm
	} || echo "Failed to install LightDM."

	# Removed lightdm service, assuming desktop i3-wm install

	echo "Applying xorg customizations..."
	{
		echo "URxvt.scrollBar: false" >> ~/.Xresources
		xrdb ~/.Xresources
	} || echo "Failed to apply xorg customizations."
}

function install_customization
{
	read -p "Do you want to install fonts packages? (y/n): " install_fonts
	if [[ $install_fonts == "y" ]]; then
		echo "Installing fonts packages..."
		{
			pacman -S noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont ttf-liberation ttf-droid ttf-roboto terminus-font rxvt-unicode --noconfirm
		} || echo "Failed to install fonts packages."
	fi

	echo "Installing font manager..."
	{
		pacman -S font-manager --noconfirm
	} || echo "Failed to install font manager."

	echo "Installing polybar and polybar themes..."
	{
		pacman -S polybar --noconfirm
		git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
		cd polybar-themes
		chmod +x setup.sh
		./setup.sh
		cd ..
	} || echo "Failed to install polybar and polybar themes."

	echo "Installing pywal..."
	{
		pacman -S python-pywal --noconfirm
	} || echo "Failed to install pywal."
	
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

function install_software
{
	echo "Installing firefox..."
	{
		pacman -S firefox --noconfirm
	} || echo "Failed to install firefox."

	echo "Installing discord, betterdiscordctl..."
	{
		pacman -S discord --noconfirm
		yay -S betterdiscordctl
	} || echo "Failed to install discord, betterdiscordctl."

	echo "Installing libreoffice..."
	{
		pacman -S libreoffice-still --noconfirm
	} || echo "Failed to install libreoffice."

	echo "Installing ffmpeg and smplayer (video player)..."
	{
		pacman -S ffmpeg smplayer smplayer-skins smplayer-themes --noconfirm
	} || echo "Failed to install ffmpeg and smplayer."

	echo "Installing obsidian..."
	{
		pacman -S obsidian --noconfirm
	} || echo "Failed to install obsidian."

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
	echo "5) Install all";
	echo "Option (e.g., 2, 4, 3): ";

	read options
	for option in $options; do
		case $option in
			1) install_i3 ;;
			2) install_required ;;
			3) install_software ;;
			4) install_customization ;;
			5) install_all ;;
		esac
	done
}

menu_screen
