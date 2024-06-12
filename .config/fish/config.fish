source ~/.config/fish/init.fish

fish_add_path ~/.bun/bin
fish_add_path ~/.local/share/fnm
fish_add_path ~/.config/scripts/bin
fish_add_path ~/.cargo/bin

# Environment
set -U fish_greeting ""
set -g scripts ~/.config/scripts
set -g EDITOR nvim
set -g XDG_CONFIG_HOME ~/.config
set -g FZF_DEFAULT_COMMAND "fd --type directory --no-ignore --base-directory ~/projects/"
set -x BUN_INSTALL "$HOME/.bun"
set -x PATH $BUN_INSTALL/bin $PATH

fish_vi_key_bindings

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
alias vpn "protonvpn-cli"

# Appearance
# set hydro_accent_color green
# set hydro_color_pwd $hydro_accent_color
# set hydro_color_git white
# set hydro_color_error red
# set hydro_color_prompt --dim $hydro_accent_color
# set hydro_color_duration --dim $fish_color_command
fish_config theme choose "rose-pine-moon"

fnm env --log-level quiet --use-on-cd | source

if status is-interactive
    set_remote_vars
    zoxide init fish | source
end





# bun

# Created by `pipx` on 2023-11-30 20:54:29
set PATH $PATH /home/joris/.local/bin
