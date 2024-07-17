set remotes (cat ~/.config/.sharedsecrets | jq '.remotes')

set names (echo $remotes | jq 'keys_unsorted[]')
set hosts (cat ~/.config/.sharedsecrets | jq '.remotes[].host')
set users (cat ~/.config/.sharedsecrets | jq '.remotes[].user')

function set_remote_vars
    for i in (seq (count $hosts))
        set user (echo $users[$i] | tr -d '"')
        set host (echo $hosts[$i] | tr -d '"')
        set name (echo $names[$i] | tr -d '"')

        set -gx $name $user@$host
    end
end
