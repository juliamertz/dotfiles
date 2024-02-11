#!/usr/bin/env sh

killall -q polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

declare layout
gap_state=$(/home/joris/.config/bspwm/gaps status)

if [[ $gap_state == "enabled" ]]; then
    layout="gaps"
elif [[ $gap_state == "disabled" ]]; then
    layout="nogaps"
elif [[ $gap_state == "" ]]; then
    layout="gaps"
fi

polybar $layout -r -c ~/.config/polybar/config.ini &