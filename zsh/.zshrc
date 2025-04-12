CONFIG=${ZDOTDIR:-$(dirname $0)}

source "$CONFIG/utils.zsh"
setupShellCats

export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

export KERNEL="$(uname -s)"
export SHELL="$0"
export BROWSER=${BROWSER:-"librewolf"}
export EDITOR=${EDITOR:-"nvim"}

if enableForCat completion; then
  plugin mattmc3/ez-compinit
  plugin zsh-users/zsh-completions
  plugin marlonrichert/zsh-autocomplete
fi

if enableForCat fzf; then
  plugin aloxaf/fzf-tab
  try_hook fzf --zsh
fi

if enableForCat vim; then
  plugin jeffreytse/zsh-vi-mode
fi

if enableForCat highlight; then
  plugin zsh-users/zsh-syntax-highlighting
fi

if $isShellCats; then
  prepend_path "/run/current-system/sw/bin"
  append_path "$SCRIPTS_DIR"
fi

append_path "$HOME/.cargo/bin"
append_path "$HOME/.local/bin"

# Shell integration hooks
try_hook zoxide init zsh
try_hook direnv hook zsh
try_hook /opt/homebrew/bin/brew shellenv
try_hook atuin init zsh --disable-up-arrow

# Aliases
alias cat='bat -pp'
alias man='BAT_THEME="rose-pine-moon" batman'
alias md='mkdir -p'
alias vim='nvim'
alias vi='nvim'
alias ls='ls --color=always'
alias ll='ls -lh'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias hist='atuin search -i'
alias grep='grep --colour=auto'
alias lg='lazygit'
alias spt='spotify_player'
alias sqlite='litecli'

if [[ $KERNEL == "Linux" ]]; then
  alias sctl='sudo systemctl'
fi

# Use Neovim as manpager when available
if command -v nvim > /dev/null; then
  export MANPAGER='nvim +Man!'
fi

# Key bindings
bindkey '^r' search-hist

source $CONFIG/prompt.zsh
