{
  tmux,
  tmuxPlugins,
  wrapPackage,
  writeText,
  ...
}:
let
  tmuxConf =
    writeText "tmux.conf" # sh
      ''
        source-file ${./tmux.reset.conf}

        set -g default-shell /run/current-system/sw/bin/zsh

        set -g @sessionx-zoxide-mode 'on'
        set -g prefix ^A

        bind-key -r f run-shell "tmux neww ${../scripts/tmux-sessionizer}"

        # Plugins
        source ${tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
        source ${tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
        source ${tmuxPlugins.rose-pine}/share/tmux-plugins/rose-pine/rose-pine.tmux

        # Theme
        set -g @rose_pine_variant 'moon'
        set -g @rose_pine_bar_bg_disable 'on'
        set -g @rose_pine_bar_bg_disabled_color_option 'default'
        set -g status-bg default
        set -g status-style bg=default
      '';
in
wrapPackage {
  name = "tmux";
  package = tmux;
  extraFlags = "-f ${tmuxConf}";
}
