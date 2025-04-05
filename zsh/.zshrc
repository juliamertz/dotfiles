autoload -Uz compinit && compinit

export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}
export ZPLUGINDIR=${ZPLUGINDIR:-$HOME/.local/share/zsh/plugins}
export SCRIPTS_DIR=${SCRIPTS_DIR:-$HOME/dotfiles/scripts}

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
add_path $SCRIPTS_DIR
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
alias man='BAT_THEME="rose-pine-moon" batman'
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
  alias sctl='sudo systemctl'
fi

# Use Neovim as manpager when available
if command -v nvim > /dev/null; then
  export MANPAGER='nvim +Man!'
fi

# Initialize prompt
source $ZDOTDIR/prompt.zsh
