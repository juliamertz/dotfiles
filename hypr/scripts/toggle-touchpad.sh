#!/usr/bin/env sh

state_variable_name="enable_touchpad"
config_file=~/.config/hypr/hyprland.conf
regex="$state_variable_name\s=\s\(true\|false\)"

# get the current state
function get_state() {
  echo $(grep $regex $config_file | cut -d"=" -f 2 | xargs)
}

# find and replace the state variable in the config file
function set_state() {
  sed -i "s/$regex/$state_variable_name = $1/" $config_file
}

function notify() {
  notify-send -t 2000 "System" "Touchpad $1"
}

if [ $(get_state) = "true" ]; then
    set_state false
    notify disabled
else
    set_state true
    notify enabled
fi
