{ mkScript, ... }:
mkScript "hass"
<|
  # sh
  ''
    BASE_URL=''${BASE_URL:-"192.168.0.100:8123"}

    if test ! -v HASS_TOKEN  && test ! -f /run/secrets/hass_token; then
      echo HASS_TOKEN not provided
      exit 1
    else
      HASS_TOKEN=''${HASS_TOKEN:-$(cat /run/secrets/hass_token)}
    fi

    call_api() {
      curl  \
        -H "Authorization: Bearer $HASS_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$2" "$BASE_URL$1" #> /dev/null
    }

    case $1 in
      dim)
        call_api "/api/services/light/turn_on" \
          "{\"entity_id\": \"light.all\", \"brightness_pct\": $2 }" 
        ;;
      cycle)
        call_api "/api/services/input_select/select_$2" \
          '{"entity_id": "input_select.scene_entities"}'

        call_api "/api/services/script/turn_on" \
          '{"entity_id": "script.apply_cycle_scene"}'
        ;;
      *)
        printf "unknown subcommand: %s" "$1"
        exit 1
        ;;
    esac
  ''
