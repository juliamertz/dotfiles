
set -U fish_greeting ""

fish_add_path ~/.bun/bin
fish_add_path ~/.local/share/fnm
fish_add_path ~/.config/scripts/bin
fish_add_path ~/.cargo/bin

export XDG_CONFIG_HOME="$HOME/.config"
export FZF_DEFAULT_COMMAND="fd --type directory --no-ignore --base-directory ~/projects/"
# export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# export PUPPETEER_EXECUTABLE_PATH=(which chromium)

set EDITOR nvim

# Aliases
alias icat "wezterm imgcat"
alias cat "bat -pp"
alias rmf "rm -rf"
alias vim nvim
alias gts "git status"
alias lg lazygit
alias cb "cd ../"
alias pb "kitty +kitten clipboard"
alias turbo "npx turbo"
alias neofetch "neofetch --ascii_colors 4 2" 
alias ls "nerd-ls -iR"
alias la "nerd-ls -iaR"
alias sctl "sudo systemctl"
alias spcm "sudo pacman"

function open_new_tab_here
    kitty -d $(pwd) &> /dev/null &
end

# Quick project folder fuzzy finder shortcut
bind \et open_new_tab_here


set -g scripts ~/.config/scripts

fish_config theme choose "Rosé Pine Moon"

set hydro_accent_color green

set hydro_color_pwd $hydro_accent_color
set hydro_color_git white
set hydro_color_error red
set hydro_color_prompt --dim $hydro_accent_color
set hydro_color_duration --dim $fish_color_command

fnm env --log-level quiet --use-on-cd | source

if status is-interactive
    set_remote_vars
    zoxide init fish | source
end





# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Created by `pipx` on 2023-11-30 20:54:29
set PATH $PATH /home/joris/.local/bin
