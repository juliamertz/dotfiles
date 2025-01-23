{
  tmux,
  tmuxPlugins,
  wrapPackage,
  runCommandNoCC,
  writeText,
  callPackage,
  lib,
  ...
}:
let
  sourcePlugin = p: "run-shell ${p}/share/tmux-plugins/${p.pluginName}/${p.pluginName}.tmux";
  tmuxSessionizer = callPackage ../scripts/tmux-sessionizer.nix { } |> lib.getExe;

  tmuxConf =
    writeText "tmux.conf" # sh
      ''
        source-file ${./tmux.reset.conf}

        set -g default-shell /run/current-system/sw/bin/zsh
        set -g @sessionx-zoxide-mode 'on'
        set -g prefix ^A

        bind-key -r f run-shell "tmux neww ${tmuxSessionizer}"

        set -g @rose_pine_variant 'moon'
        set -g @rose_pine_bar_bg_disable 'on'
        set -g @rose_pine_bar_bg_disabled_color_option 'default'
        set -g status-bg default
        set -g status-style bg=default

        ${sourcePlugin tmuxPlugins.sensible}
        ${sourcePlugin tmuxPlugins.yank}
        ${sourcePlugin tmuxPlugins.rose-pine}

        set-environment -g XDG_CONFIG_HOME "$HOME/.config"
      '';

  config = runCommandNoCC "tmux-conf" { } ''
    mkdir -p $out/tmux
    cp -r ${tmuxConf} $out/tmux/tmux.conf
  '';
in
wrapPackage {
  package = tmux;
  # If config home isn't set to the config most plugins won't work
  # this should overriden back to the users home after initializaiton
  extraArgs = "--set XDG_CONFIG_HOME '${config}'";
  extraFlags = "-f ${config}/tmux/tmux.conf";
}
