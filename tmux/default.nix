{
  pkgs,
  lib,
  callPackage,
  wrapPackage,
  runCommandNoCC,
  writeText,
  ...
}:
let
  tmux = wrapPackage {
    name = "tmux";
    package = pkgs.tmux;
    # If config home isn't set to the config most plugins won't work
    # this is overriden back to the users home after initializaiton
    extraArgs = "--set XDG_CONFIG_HOME '${config}'";
    extraFlags = "-f ${config}/tmux/tmux.conf";
    dependencies = with pkgs; [ fzf ];
  };
  plugins = callPackage ./plugins.nix { };

  # scripts
  sessionizer = callPackage ./sessionizer.nix { };

  # configuration
  tmuxConf =
    writeText "tmux.conf" # sh
      ''
        source-file ${./tmux.reset.conf}

        set -g @sessionx-zoxide-mode 'on'
        set -g prefix ^A

        bind-key -r f run-shell "tmux neww ${lib.getExe sessionizer}"

        # Plugins
        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'tmux-plugins/tmux-sensible'
        set -g @plugin 'tmux-plugins/tmux-yank'
        set -g @plugin 'sainnhe/tmux-fzf'
        set -g @plugin 'rose-pine/tmux'

        # Theme
        set -g @rose_pine_variant 'moon'
        set -g @rose_pine_bar_bg_disable 'on'
        set -g @rose_pine_bar_bg_disabled_color_option 'default'
        set -g status-bg default
        set -g status-style bg=default

        set-environment -g TMUX_PLUGIN_MANAGER_PATH '${plugins.combined}'
        run '${plugins.tpm}/tpm'

        set-environment -g XDG_CONFIG_HOME "$HOME/.config"
      '';

  config =
    runCommandNoCC "tmux-conf" { } # sh
      ''
        mkdir -p $out/tmux
        cp -r ${tmuxConf} $out/tmux/tmux.conf
        cp -r ${./tmux.reset.conf} $out/tmux

        mkdir $out/tmux/plugins
        cp -r ${plugins.combined}/* $out/tmux/plugins
      '';
in
tmux
