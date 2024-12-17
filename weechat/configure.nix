{ pkgs, ... }:
with pkgs;
{
  # script from rwxrobs github dot-template
  twitch = writeShellScriptBin "weechat-configure-twitch" ''
    #!/usr/bin/env bash

    tokenurl=https://antiscuff.com/oauth

    mkdir -p ~/.weechat
    fifo=~/.weechat/fifo

    if [[ ! -p "$fifo" ]]; then
    	echo "Is weechat running? Start first in another window."
    	exit 1
    fi

    read -rp "Twitch user name: " user
    echo "Generate your OAuth token here: $tokenurl"
    read -rp "Open in your web browser? [y|N]" resp
    [[ ''${resp,,} == y ]] && open $tokenurl
    read -rp "Paste (starting with 'oauth:', empty keeps current): " token

    cat <<EOF >"$fifo"
    */server add twitch irc.chat.twitch.tv/6667 -ssl
    */set irc.server.twitch.username "$user"
    */set irc.server.twitch.tls off
    */set irc.server.twitch.autoconnect on
    */filter add hide_quit irc.* irc_quit *
    */filter add hide_part irc.* irc_part *
    */save
    EOF

    if test -n "$token"; then
    	cat <<EOF >"$fifo"
    */set irc.server.twitch.password "$token"
    */save
    EOF
    fi
  '';
}
