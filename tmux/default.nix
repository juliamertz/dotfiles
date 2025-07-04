{
  lib,
  tmuxPlugins,
  callPackage,
  packages,
  ...
}: let
  builder = callPackage ./builder.nix {};
  shell = lib.getExe packages.zsh;
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
    extraConfig = let
      popup = cmd: w: h: "tmux popup -w ${w} -h ${h} -x C -y C '${cmd} && tmux display-popup -C'; exit 0";
      sessionizerPopup = popup "${packages.scripts}/bin/sessionizer" "80%" "80%";
    in
      # sh
      ''
        bind-key -r f run-shell "${sessionizerPopup}"
      '';
  }
