# == during install, chroot ==
# update packages
pacman -Syu


# == networking ==
# install network packages
pacman -S dhcpcd

# start network service
sudo systemctl enable dhcpcd
sudo systemctl enable iwd


# == post install ==

# == yay ==
# clone yay binary
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

# return to main directory
cd ..


# === customization ===
# install required packages
pacman -S git neofetch base-devel polybar rofi python python-pywal calc ranger w3m imlib2 mpv rxvt-unicode

# == ranger setup ==
# scripts need to be changed to allow ranger to utilize w3m correctly (iirc??)
echo "You may need to change ranger's default scripts in order to utilize w3m correctly"
ranger --copy-config=all


# install necessary fonts
git clone https://aur.archlinux.org/nerd-fonts-git.git
cd nerd-fonts-git
makepkg -si

# return to main directory
cd ..

# == polybar ==
# download polybar themes
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
cd polybar-themes

# make polybar setup executable
chmod +x setup.sh

# run setup
./setup.sh

# return to main directory
cd ..

# == wallpapers ==
git clone https://github.com/EternalDusk/wallpapers.git


# === programs ===
# == pavucontrol (audio mixer/audio management) ==
sudo pacman -S pavucontrol

# == web browser (firefox for themeing) ==
# install firefox
sudo pacman -S firefox

yay -S python-pywalfox

echo "You'll need to download the pywalfox extension from here:"
echo "https://addons.mozilla.org/en-US/firefox/addon/pywalfox/"


# == discord ==
# install discord
sudo pacman -S discord

# install betterdiscord
yay betterdiscordctl

# install discord themeing
yay pywal-discord

# == libreoffice ==
sudo pacman -S libreoffice-still

# == ffmpeg ==
sudo pacman -S ffmpeg

# == smplayer (video player) ==
sudo pacman -S smplayer
sudo pacman -S smplayer-skins
sudo pacman -S smplayer-themes

# == tailscale (home network tunneling) ==
sudo pacman -S tailscale
sudo systemctl start tailscaled
sudo systemctl enable tailscaled

# == obsidian (second brain) ==
sudo pacman -S obsidian

# == font manager ==
sudo pacman -S font-manager

# == atom-bin code editor ==
yay -s atom-bin

# NEED to set up
# spicetify
# bluetooth

# === Cleanup and Customization ===
# == Removal of sidebars ==
#echo "URxvt.scrollBar: false" >> ~/.Xresources
#xrdb ~/.Xresources

# == NOTES ==
clear
echo "You'll need to run these commands after these scripts finish: "
echo "discord (and let update)"
echo "betterdiscordctl install"
echo "tailscale -up"
