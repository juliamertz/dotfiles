#!/usr/bin/env bash

Xephyr :1 -ac -br -noreset -screen 1280x720 -dpi 96 &
sleep 1
DISPLAY=:1.0 awesome -c ~/.config/awesome/rc.lua &
instance=$!

while inotifywait -r -e close_write ~/.config/awesome; do
	kill -s SIGHUP $instance
done
