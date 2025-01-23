#!/usr/bin/env bash

export PLUGINDIR=${PLUGINDIR:-$HOME/.local/share/zsh/plugins}
export DIR=$DOTDIR
export KERNEL=$(uname -s)

source "$DIR/tools.bash" # Helpers functions such as add_path, try_hook, plugin etc..

add_path "$RUNTIMEDEPS"
add_path "$HOME/.cargo/bin"
add_path "$HOME/.local/bin"

try_hook fzf --bash
try_hook starship init bash
try_hook zoxide init bash
try_hook direnv hook bash
try_hook atuin init bash --disable-up-arrow
[[ $KERNEL == "Darwin" ]] && try_hook /opt/homebrew/bin/brew shellenv

# Plugins
source "$(bash "$RUNTIMEDEPS"/blesh-share)/ble.sh" # bash line editor

# Aliases
alias cat='bat -pp'
alias md='mkdir -p'
alias ll='ls -l'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias hist='atuin search -i'
alias grep='grep --colour=auto'
alias mkexe='chmod +x'
alias mkmine='chown $(whoami) -R'
alias lg='lazygit'
alias spt='spotify_player'
alias sqlite='litecli'

# Linux specific aliases
if [[ $KERNEL == "Linux" ]]; then
  alias open='xdg-open'
  alias sctl='sudo systemctl'
fi

# Use Neovim as manpager when available
if command -v nvim > /dev/null; then
  export MANPAGER='nvim +Man!'
fi
