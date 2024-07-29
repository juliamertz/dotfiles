# Enable instant prompt, source this at beginning of ~/.zshrc
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

if [[ -r "$CACHE_DIR/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$CACHE_DIR/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $CONFIG_DIR/zsh/init/p10k.zsh
