#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

WALLPAPERS=$(ls $WALLPAPER_DIR)

#WALLPAPER=$(printf "$ROFI_STR"| rofi -dmenu -i -p "Wallpaper")
WALLPAPER=$(for a in $WALLPAPER_DIR/*.png; do echo -en "$(basename "$a")\0icon\x1f$a\n" ; done | rofi -config $HOME/.local/share/rofi/themes/cat_wp.rasi -dmenu)
if [ -z "$WALLPAPER" ]; then
    exit 0
else 
    hyprctl hyprpaper reload ,"$WALLPAPER_DIR/$WALLPAPER"
fi

# Set the wallpaper using hyprpaper
