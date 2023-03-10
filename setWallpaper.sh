#!/bin/bash

# available polybar themes:
# blocks, colorblocks, grayblocks
# forest, shades, shapes
# cuts, hack

# unavaiable polybar themes:
# material, docky

BAR=hack

# check if first variable was given
if [ -z "$1" ]; then
	echo "No file was given!"
else
	# check wallpaper directory
	if [ -f "$1" ]; then
		# set wallpaper using wal
		wal -i "$1"

		# set colors from wal to discord
		pywal-discord

		# set colors from wal to firefox
		pywalfox update

		# set polybar color
		~/.config/polybar/$BAR/scripts/pywal.sh "$1"

		#relaunch polybar
		~/.config/polybar/launch.sh --$BAR
	else
		echo "File does not exist!"
	fi
fi
