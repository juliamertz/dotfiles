fish_add_path ~/.bun/bin
fish_add_path ~/.local/share/fnm
fish_add_path ~/.config/scripts/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/go/bin

# Environment
set -U fish_greeting ""
set -g scripts ~/.config/scripts
set -g EDITOR nvim
set -g XDG_CONFIG_HOME ~/dotfiles
set -g FZF_DEFAULT_COMMAND "fd --type directory --no-ignore --base-directory ~/projects/"

fish_vi_key_bindings

# Aliases
alias cat "bat -pp"
alias lg lazygit
alias sctl "sudo systemctl"
alias spt "spotify_player"

fish_config theme choose "rose-pine-moon"

if status is-interactive
    set_remote_vars
    # zoxide init fish | source
end
