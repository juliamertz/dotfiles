if status is-interactive
  fish_vi_key_bindings
  fish_config theme choose "Tomorrow Night Bright"
end

set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_STATE_HOME ~/.local/state

set -gx KERNEL (uname -s)
set -gx SHELL (status current-command)
set -gx BROWSER librewolf
set -gx EDITOR nvim

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin

if test "$KERNEL" = "Darwin"
  fish_add_path /sbin
end

eval "$(zoxide init fish)"
eval "$(direnv hook fish)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(atuin init fish --disable-up-arrow)"
eval "$(starship init fish)"

alias cat='bat -pp'
alias md='mkdir -p'
alias vim='nvim'
alias lg='lazygit'
alias spt='spotify_player'
alias ..='cd ..'
alias ...='cd ../..'
alias hist='atuin search -i'
alias grep='grep --colour=auto'
alias sqlite='litecli'
alias k='kubectl'
alias tg='terragrunt'
alias ls='eza'
alias ll='ls -lh'
alias la='ls -la'
alias du='dust'

if test "$KERNEL" = "Linux"
  alias sctl 'sudo systemctl'
end

if type -q nvim
  set -gx MANPAGER 'nvim +Man!'
end
