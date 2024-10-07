#!/opt/homebrew/bin/fish

set MULTI_ICONS true

set apps            \
    "Alacritty"     \
    "Code"          \
    "Brave Browser" \
    "Spotify"       \
    "Figma"         \
    "Chromium"	    \
    "Obsidian"      \

set icons           \
    "􀩼"             \
    "􁚛"             \
    "􀎭"             \
    "􀑪"             \
    "􀤑"             \
    "􀎭"	            \
    "􀓕"             \ 

set spaceIndex (string split . $NAME)[2]
set query (yabai -m query --windows --space $spaceIndex | jq .[].app)

for app in $query
    set app $(echo $app | xargs)
    if contains $app $apps
        if set -q MULTI_ICONS
            set LABEL[(count $LABEL +)] $icons[(contains -i $app $apps)]
            # set LABEL (random)
        else
            set LABEL $icons[(contains -i $app $apps)]
            break
        end
    end
end

if not set -q LABEL
    sketchybar --set $NAME background.drawing=$SELECTED align="center" icon="$spaceIndex" icon.padding_left=7 icon.padding_right=8
else 
    sketchybar --set $NAME background.drawing=$SELECTED align="center" icon="$LABEL"
end
