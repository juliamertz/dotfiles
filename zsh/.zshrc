ZDOTDIR=${ZDOTDIR:-$HOME/.config}
INIT_PATH=$ZDOTDIR/init

source $INIT_PATH/prompt.zsh
source $INIT_PATH/tools.zsh
source $INIT_PATH/zinit.zsh

# Aliases
alias cat='bat -pp'
alias lg='lazygit'
alias sctl='sudo systemctl'
alias sqlite='litecli'

# Plugins
if [ -z $(env | grep NVIM=) ]; then
  plugin 'jeffreytse/zsh-vi-mode'
fi
plugin 'romkatv/powerlevel10k'
plugin 'zsh-users/zsh-syntax-highlighting'
plugin 'zsh-users/zsh-completions'
plugin 'zsh-users/zsh-autosuggestions'
plugin 'Aloxaf/fzf-tab'
plugin 'hlissner/zsh-autopair'

add_path $HOME/.cargo/bin
add_path $HOME/.local/bin
add_path $HOME/.local/share/flatpak/exports/shar
add_path /var/lib/flatpak/exports/share

source $INIT_PATH/cleanup.zsh
