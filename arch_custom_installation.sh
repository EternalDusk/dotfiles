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
pacman -S --needed git neofetch nitch base-devel polybar rofi pyton python-pywal calc ranger w3m imlib2 mpv rxvt-unicode

# == ranger setup ==
# scripts need to be changed to allow ranger to utilize w3m correctly (iirc??)
echo "You may need to change ranger's default scripts in order to utilize w3m correctly"
echo "Note: ADD THIS TO SCRIPT AUTOMATION"


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

betterdiscordctl install

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


# NEED to set up
# spicetify
# bluetooth