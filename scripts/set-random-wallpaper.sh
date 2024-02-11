#!/bin/sh

WALLPAPER_PATH=~/.config/scripts/tmp-wallpaper

curl https://minimalistic-wallpaper.demolab.com/?random --output $WALLPAPER_PATH 
feh --bg-fill $WALLPAPER_PATH
# rm $WALLPAPER_PATH

