#!/usr/bin/env sh

xrandr --output HDMI-0  \
       --rotate left    \
       --mode 2560x1440 \
       --rate 74.92     \
       --pos 0x0

xrandr --output DP-0    \
       --rotate normal  \
       --mode 2560x1440 \
       --rate 164.83    \
       --pos 1440x388   \
       --primary 

feh --bg-fill /home/joris/.config/background &

pgrep -x picom > /dev/null || picom -b
# Brightness / temperature control
pgrep -x gummy > /dev/null || gummy start &
# not quite sure why this is in here again
/usr/lib/xfce-polkit/xfce-polkit > /dev/null & 
# Fix cross mouse cursor in bspwm
xsetroot -cursor_name left_ptr &
# Needed for proton vpn
nm-applet &

xinput set-prop 'Logitech USB Receiver Mouse' 'libinput Accel Speed' -1

