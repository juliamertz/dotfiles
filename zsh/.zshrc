autoload -Uz compinit && compinit

export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}
export ZPLUGINDIR=${ZPLUGINDIR:-$HOME/.local/share/zsh/plugins}

export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

export KERNEL=$(uname -s)
export SHELL="$0"
export BROWSER=${BROWSER:-"librewolf"}
export EDITOR=${EDITOR:-"nvim"}

source $ZDOTDIR/tools.zsh

# Append to $PATH
add_path $HOME/.cargo/bin
add_path $HOME/.local/bin
add_path $ZRUNTIMEDEPS
add_path /run/current-system/sw/bin

# Initialize plugins
plugin jeffreytse/zsh-vi-mode
plugin zsh-users/zsh-syntax-highlighting
plugin zsh-users/zsh-autosuggestions
plugin Aloxaf/fzf-tab
plugin zsh-users/zsh-completions

# Shell integration hooks
try_hook fzf --zsh
try_hook zoxide init zsh
try_hook direnv hook zsh
try_hook /opt/homebrew/bin/brew shellenv
try_hook atuin init zsh --disable-up-arrow

# Key bindings
bindkey '^r' search-hist

# Aliases
alias cat='bat -pp'
alias man='batman'
alias md='mkdir -p'
alias vim='nvim'
alias vi='nvim'
alias ls='ls --color=always'
alias ll='ls -l'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias hist='atuin search -i'
alias grep='grep --colour=auto'
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

# Initialize prompt
source $ZDOTDIR/prompt.zsh
