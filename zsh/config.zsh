CONFIG_PATH=$HOME/.config/
INIT_PATH=$CONFIG_PATH/zsh/init

source $INIT_PATH/prompt.zsh
source $INIT_PATH/tools.zsh
source $INIT_PATH/zinit.zsh

# Aliases
alias ls='nerd-ls -iR'
alias vim='nvim'
alias cat='bat -pp'
alias lg='lazygit'
alias turbo='npx turbo'
alias neofetch='neofetch --ascii_colors 4 2' 
alias ls='nerd-ls -iR'
alias la='nerd-ls -iaR'
alias sctl='sudo systemctl'
alias vpn='protonvpn-cli'
alias sqlite='litecli'

# Plugins
plugin 'jeffreytse/zsh-vi-mode'
plugin 'romkatv/powerlevel10k'
plugin 'zsh-users/zsh-syntax-highlighting'
plugin 'zsh-users/zsh-completions'
plugin 'zsh-users/zsh-autosuggestions'
plugin 'Aloxaf/fzf-tab'
plugin 'hlissner/zsh-autopair'

add_path $HOME/.config/zsh/scripts
add_path $HOME/.cargo/bin
add_path $HOME/.local/bin
add_path $HOME/.local/share/gem/ruby/3.0.0/bin

source $INIT_PATH/cleanup.zsh
