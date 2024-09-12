# Dusk's i3 Dotfiles


## Description

A script to easily and quickly replicate my setup as I move from computer to computer.

## Getting Started

### Dependencies

* Fresh arch install running pipewire audio
* Preinstalled i3 (optional)

### Executing install script

```bash
sudo wget -O - https://raw.githubusercontent.com/EternalDusk/dotfiles/main/installScript.sh | bash
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
* [ ] libreoffice-fresh (microsoft suite alternative)
* [ ] telegram-desktop (messenger)
* [ ] kando (pie menu)