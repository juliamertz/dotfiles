#!/bin/sh

date=$(date "+%d/%m/%y")

sketchybar --set $NAME icon="$ICON" label="DATE: $date"
