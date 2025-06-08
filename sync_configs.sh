#!/bin/sh

SCRIPT_DIR=$(dirname "$(realpath $0)")

get_sync_choice()
{
    echo -e "How would you like to sync your config?\n1: Repository > Local\n2: Local > Repository"
    read -p "Option (1,2): " SYNC_OPTION
    case $SYNC_OPTION in
        1)
            return 1
            ;;
        2)
            return 2
            ;;
        *)
            return 0
            ;;
    esac 
}

copy_to_repo()
{
    echo -e "Copying .config folders to repository..."
    for a in "$SCRIPT_DIR"/.config/*; do
        DIR=~/.config/$(basename "$a")
        cp -r "$DIR" "$SCRIPT_DIR/.config/"
        echo "Copied $(basename "$a") to repo"
    done

    echo -e "Copying wallpapers to repository..."
    WALLPAPER_DIR=~/Pictures/Wallpapers
    REPO_WALLPAPER_DIR="$SCRIPT_DIR/Wallpapers"
    mkdir -p "$REPO_WALLPAPER_DIR"
    cp -r "$WALLPAPER_DIR"/* "$REPO_WALLPAPER_DIR/"
    echo "Wallpapers copied to repo"

    echo -e "Copying scripts to repository..."
    SCRIPTS_DIR=~/Scripts
    REPO_SCRIPTS_DIR="$SCRIPT_DIR/Scripts"
    mkdir -p "$REPO_SCRIPTS_DIR"
    cp -r "$SCRIPTS_DIR"/*.sh "$REPO_SCRIPTS_DIR/"
    echo "Shell scripts copied to repo"

    echo -e "Done!"
}

copy_from_repo()
{
    echo -e "Copying .config folders..."
    for a in "$SCRIPT_DIR"/.config/*; do
        cp -r "$SCRIPT_DIR/.config/" ~/.config/
        echo "Copied $(basename "$a")"
    done

    echo -e "Copying wallpapers from repository..."
    WALLPAPER_DIR=~/Pictures/Wallpapers
    REPO_WALLPAPER_DIR="$SCRIPT_DIR/Wallpapers"
    mkdir -p "$WALLPAPER_DIR"
    cp -r "$REPO_WALLPAPER_DIR"/* "$WALLPAPER_DIR/"
    echo "Wallpapers copied from repo"

    echo -e "Copying scripts from repository..."
    SCRIPTS_DIR=~/Scripts
    REPO_SCRIPTS_DIR="$SCRIPT_DIR/Scripts"
    mkdir -p "$SCRIPTS_DIR"
    cp -r "$REPO_SCRIPTS_DIR"/*.sh "$SCRIPTS_DIR/"
    echo "Shell scripts copied from repo"

    echo -e "Done!"
}

cat << "EOF"
_________                _____.__           _________                    
\_   ___ \  ____   _____/ ____\__| ____    /   _____/__.__. ____   ____  
/    \  \/ /  _ \ /    \   __\|  |/ ___\   \_____  <   |  |/    \_/ ___\ 
\     \___(  <_> )   |  \  |  |  / /_/  >  /        \___  |   |  \  \___ 
 \______  /\____/|___|  /__|  |__\___  /  /_______  / ____|___|  /\___  >
        \/            \/        /_____/           \/\/         \/     \/ 
EOF


get_sync_choice
O_CODE=$?
if [ "$O_CODE" -eq "0" ]; then
    echo "Invalid input, exiting..."
elif [ "$O_CODE" -eq "1" ]; then
    copy_from_repo
else
    copy_to_repo
fi
