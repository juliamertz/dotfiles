#! /usr/bin/env fish

set config (cat ~/.config/.sharedsecrets | jq .home_assistant)
set token (echo $config | jq .token | tr -d '"')
set base_url (echo $config | jq .ip | tr -d '"')

if [ $argv[1] = up ]
    set step 20
else if [ $argv[1] = down ]
    set step -20
else
    curl --silent \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"entity_id\": \"light.all\", \"brightness_pct\": $argv[1] }" \
        (echo $base_url)api/services/light/turn_on >/dev/null
    exit
end

curl --silent \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -d "{\"entity_id\": \"light.all\", \"brightness_step_pct\": $step }" \
    (echo $base_url)api/services/light/turn_on >/dev/null
