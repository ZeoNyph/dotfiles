#!/usr/bin/sh

if sudo -l | grep -q "NOPASSWD: ALL" ; then
    yay -Sy --sudoloop --noconfirm
    YAY_PACKAGE_COUNT=$(yay -Qu --ignore webots-bin --sudoloop | wc -l)
    if [ "$YAY_PACKAGE_COUNT" -gt 0 ]; then
        USER_CHOICE=$(notify-send "Updates available!" "You have $YAY_PACKAGE_COUNT packages that need to be updated." --icon "download" --action=update="Update packages")
        if [ "$USER_CHOICE" == "update" ]; then
            kitty --hold sh -c "clear; yay -Syu --noconfirm --ignore webots-bin --ignore mysql --ignore mysql-clients --ignore libmysqlclient" &
        fi
    fi
fi

