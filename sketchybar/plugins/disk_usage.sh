#!/bin/sh

diskUsage=$(/usr/local/bin/diskspace -Hi)

sketchybar --set $NAME icon="$ICON" label="DISK: $diskUsage"
