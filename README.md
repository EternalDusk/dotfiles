# Dusk's i3 Dotfiles


## Description

A script to easily and quickly replicate my setup as I move from computer to computer.

## Getting Started

### Dependencies

* Fresh arch install running pipewire audio
* Preinstalled desktop i3-wm

### Executing install script

**NOTE** - WGET version currently fails due to 'yay' is installed and ran to install other packages

```bash
sudo wget -O - https://raw.githubusercontent.com/EternalDusk/dotfiles/main/installScript-wget.sh | bash
```

## Authors

Just me, myself, and I (with a lot of inspiration from r/unixporn)

## Version History

* 0.3
    * Added multi-select for menu options
    * Handle package grabbing failure
    * Added more packages
    * Handles changing config files for ranger, w3m, etc.
    * Script now runs as root
    * Logs implemented
* 0.2
    * Updated default packages
    * Change from pulseaudio to pipewire (may change back in the future)
    * Added an easier to work with menu
* 0.1
    * Initial Release

## Future Packages/Features to Add

* [ ] Flameshot (screenshot manager)
* [ ] OBS (recording software)
* [X] libreoffice-still (microsoft suite alternative)
* [ ] telegram-desktop (messenger)
* [X] picom (with config)
* [X] kando (pie menu)
    * [ ] Custom kando config based off of this setup
* [ ] properly install yay package manager
    * checking if working properly
* [ ] ensure ranger setup worked properly
    * checking if working properly
* [ ] add multi-monitor automatic setup support
* [ ] wine
* [ ] mini-galaxy
* [ ] steam
* [X] needs to run all processes from '~' (ensure on script load)
* [ ] xorg scrollbar customization
    * checking if working properly
* [ ] Alacritty
* [ ] Fish