autoload -Uz compinit && compinit

source "$INIT_PATH/remote-vars.zsh"

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(fnm env --use-on-cd)"


# Utility functions
function add_path() {
  if [[ -d $1 ]] && [[ ! $PATH =~ $1 ]]; then
    export PATH=$PATH:$1
  fi
}

function plugin() {
  zinit light $1
}
