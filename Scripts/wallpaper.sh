#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPRLAND="$HOME/.config/hypr/hyprland.conf"
WALLPAPERS=$(ls $WALLPAPER_DIR)

WALLPAPER_O=$(for a in $WALLPAPER_DIR/*; do echo -en "img:"$a"\n" ; done | wofi -dmenu -p "" -D "orientation=vertical" -D "image_size=200" -D "halign=center" -D "valign=center" -D "hide_search=true" -allow-images --lines 4  --allow-markup)
WALLPAPER=$(basename "$WALLPAPER_O")
echo $WALLPAPER
if [ -z "$WALLPAPER" ]; then
    exit 0
else
    wp="$WALLPAPER_DIR/$WALLPAPER"
    swww img "$wp" --transition-type=grow --transition-duration=1.5 --transition-pos=0.89,0.975 && wal -i "$wp" -n -e && pywalfox update && swaync-client -rs
    mv ~/.cache/wal/colors-spicetify.ini ~/.config/spicetify/Themes/Pywal/color.ini
    spicetify refresh
    sed -i -e "s#swww img .*#swww img $wp#g" "$HYPRLAND"
fi

