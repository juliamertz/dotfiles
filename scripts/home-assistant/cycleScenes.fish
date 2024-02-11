#! /usr/bin/env fish

# Usage: ./cycleScenes.fish [next|previous]

set config (cat ~/.config/.sharedsecrets | jq .home_assistant)
set token (echo $config | jq .token | tr -d '"')
set base_url (echo $config | jq .ip | tr -d '"')
echo Token: $token
echo Base URL: $base_url

set direction (echo $argv[1])

curl -X POST \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -d '{"entity_id": "input_select.scene_entities"}' \
    (echo $base_url)api/services/input_select/select_$direction

# Active new scene
curl -X POST \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -d '{"entity_id": "script.apply_cycle_scene"}' \
    (echo $base_url)api/services/script/turn_on
