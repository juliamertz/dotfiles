#!/bin/sh

cpuUsage=$(top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1 | sed s/\%/\/)

sketchybar --set $NAME icon="$ICON" label="CPU: $cpuUsage%"
