#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPRLAND="$HOME/.config/hypr/hyprland.conf"
WALLPAPERS=$(ls $WALLPAPER_DIR)

WALLPAPER=$(for a in $WALLPAPER_DIR/*.png; do echo -en "$(basename "$a")\0icon\x1f$a\n" ; done | rofi -config $HOME/.local/share/rofi/themes/cat_wp.rasi -dmenu)
if [ -z "$WALLPAPER" ]; then
    exit 0
else
    wp="$WALLPAPER_DIR/$WALLPAPER"
    swww img "$wp" --transition-type=grow --transition-duration=1.5 --transition-pos=0.89,0.975  
    sed -i -e "s#swww img .*#swww img $wp#g" "$HYPRLAND"
fi

