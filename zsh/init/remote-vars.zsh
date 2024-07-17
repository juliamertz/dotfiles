#/usr/bin/env zsh

function set_remote_vars() {
  local remotes=$(cat ~/.config/.sharedsecrets | jq '.remotes')

  local names=($(echo $remotes | jq -r 'keys_unsorted[]'))
  local hosts=($(cat ~/.config/.sharedsecrets | jq -r '.remotes[].host'))
  local users=($(cat ~/.config/.sharedsecrets | jq -r '.remotes[].user'))

  local i=1
  for _ in $names; do
    local name=${names[$i]}
    local user=${users[$i]}
    local host=${hosts[$i]}

    export $name="$user@$host"
    ((i++))
  done
}

set_remote_vars
