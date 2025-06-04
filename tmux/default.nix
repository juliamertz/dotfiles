{
  lib,
  tmuxPlugins,
  callPackage,
  packages,
  ...
}: let
  builder = callPackage ./builder.nix {};
  shell = lib.getExe packages.fish;
in
  builder.makeTmuxBin {
    sourceFiles = [./tmux.conf];

    globals = {
      default-shell = shell;
      default-command = shell;
    };

    plugins = with tmuxPlugins; [
      sensible
      yank
      rose-pine
    ];
    pluginOptions = {
      rose_pine_variant = "moon";
      rose_pine_bar_bg_disable = "on";
      rose_pine_bar_bg_disabled_color_option = "default";
      sessionx-zoxide-mode = "on";
    };

    patchXdgConfig = true;
    extraConfig =
      # sh
      ''
        bind-key -r f run-shell "tmux neww ${packages.scripts}/bin/sessionizer"
      '';
  }
