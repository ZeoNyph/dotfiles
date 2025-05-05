#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPRLAND="$HOME/.config/hypr/hyprland.conf"
WALLPAPERS=$(ls $WALLPAPER_DIR)

sddm_change()
{
    SDDM_THEME_DIR=/usr/share/sddm/themes/corners
    cp "$1" "$SDDM_THEME_DIR"/backgrounds/
    sed -i -e "s%BgSource=.*%BgSource=\"backgrounds/$(basename "$1")\"%g" "$SDDM_THEME_DIR/theme.conf"
    sed -i -e "s%UserBorderColor=.*%UserBorderColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%InputTextColor=.*%InputTextColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%InputBorderColor=.*%InputBorderColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%LoginButtonColor=.*%LoginButtonColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%PopupColor=.*%PopupColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%SessionButtonColor=.*%SessionButtonColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%PowerButtonColor=.*%PowerButtonColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%DateColor=.*%DateColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%TimeColor=.*%TimeColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%UserColor=.*%UserColor=\"$background\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%InputTextColor=.*%InputTextColor=\"$color5\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%LoginButtonTextColor=.*%LoginButtonTextColor=\"$background\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%PopupActiveColor=.*%PopupActiveColor=\"$background\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%SessionIconColor=.*%SessionIconColor=\"$background\"%g" "$SDDM_THEME_DIR"/theme.conf
    sed -i -e "s%PowerIconColor=.*%PowerIconColor=\"$background\"%g" "$SDDM_THEME_DIR"/theme.conf

}

WALLPAPER_O=$(for a in $WALLPAPER_DIR/*; do echo -en "img:"$a"\n" ; done | wofi -dmenu -p "" -D "orientation=vertical" -D "image_size=200" -D "halign=center" -D "valign=center" -D "hide_search=true" -allow-images --lines 4  --allow-markup)
WALLPAPER=$(basename "$WALLPAPER_O")
echo $WALLPAPER
if [ -z "$WALLPAPER" ]; then
    exit 0
else
    wp="$WALLPAPER_DIR/$WALLPAPER"
    swww img "$wp" --transition-type=grow --transition-duration=1.5 --transition-pos=0.89,0.975 && wal -i "$wp" -n -e && pywalfox update && swaync-client -rs
    convert -scale 10% -blur 0x3 -resize 1000% "$wp" ~/.config/wlogout/bg.png   
    mv ~/.cache/wal/colors-spicetify.ini ~/.config/spicetify/Themes/Pywal/color.ini
    cp ~/.cache/wal/colors-waybar.css ~/.config/wlogout/colors.css
    source ~/.cache/wal/colors.sh
    spicetify refresh
    mv ~/.cache/wal/pywal.kvconfig ~/.config/Kvantum/pywal/pywal.kvconfig
    sed -i -e "s#swww img .*#swww img $wp#g" "$HYPRLAND"
    sddm_change "$wp"
fi

