#!/bin/zsh


option_1='  Sync from OneDrive'
option_2='  Sync to OneDrive'

selected_option=$(printf "$option_1\n$option_2" | rofi -dmenu -i -p "Sync type")

case "$selected_option" in
    "$option_1")
        dunstify "  Syncing from OneDrive" -i "cloud"
        /usr/bin/rclone sync od: ~/OneDrive && dunstify "Wowo"
        dunstify "  Sync complete!" -i "cloud"
        ;;
    "$option_2")
        dunstify "  Syncing to OneDrive" -i "cloud"
        /usr/bin/rclone sync ~/OneDrive od:
        dunstify "  Sync complete!" -i "cloud"
        ;;
    *) exit 1 ;;
    esac