#!/usr/bin/sh

FILE=$(fzf -i --walker-root="/home/zeonyph") 
if [ ! -z $FILE ]; then
    nvim "$FILE"
fi;
