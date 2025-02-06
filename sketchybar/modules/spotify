#!/bin/sh

track=$(spotify status track)
status=$(spotify status)

if [[ "$status" == *"paused"* ]]; then
	ICON="􀊆"
else
	ICON="󰺢"
fi

sketchybar --set $NAME icon="$ICON" label="${track}"
