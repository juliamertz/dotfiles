{
  pkgs,
  lib,
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

  # plugins
  tpm = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "7bdb7ca33c9cc6440a600202b50142f401b6fe21";
    sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
  };
  tmux-sensible = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-sensible";
    rev = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
    sha256 = "sha256-sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
  };
  tmux-yank = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-yank";
    rev = "acfd36e4fcba99f8310a7dfb432111c242fe7392";
    sha256 = "sha256-/5HPaoOx2U2d8lZZJo5dKmemu6hKgHJYq23hxkddXpA=";
  };
  tmux-fzf = pkgs.fetchFromGitHub {
    owner = "sainnhe";
    repo = "tmux-fzf";
    rev = "1547f18083ead1b235680aa5f98427ccaf5beb21";
    sha256 = "sha256-dMqvr97EgtAm47cfYXRvxABPkDbpS0qHgsNXRVfa0IM=";
  };
  tmux-rosepine = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "tmux";
    rev = "5bf885fe2e181e9763d92d9c522b0526e901e449";
    hash = "sha256-YnpWvW0iWANB0snVhLKBTnOXlD3LQfbeoSFeae7SJ0c=";
  };

  # scripts
  sessionizer = pkgs.callPackage ./sessionizer.nix { };

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
        set -g status-bg default
        set -g status-style bg=default

        set-environment -g TMUX_PLUGIN_MANAGER_PATH '${plugins}'
        run '${tpm}/tpm'

        set-environment -g XDG_CONFIG_HOME "$HOME"
      '';

  combineDerivations =
    name: derivations:
    let
      copy = der: "cp -r ${der} $out/${der.pname}";
      commands = map copy derivations;
    in
    runCommandNoCC name { } ''
      mkdir $out
      ${lib.concatStringsSep "\n" commands}
    '';

  plugins =
    runCommandNoCC "tmux-plugins" { } # sh
      ''
        mkdir $out
        cp -r ${tpm} $out/tpm
        cp -r ${tmux-sensible} $out/tmux-sensible
        cp -r ${tmux-yank} $out/tmux-yank
        cp -r ${tmux-fzf} $out/tmux-fzf
        cp -r ${tmux-rosepine} $out/tmux
      '';

  config =
    runCommandNoCC "tmux-conf" { } # sh
      ''
        mkdir -p $out/tmux
        cp -r ${tmuxConf} $out/tmux/tmux.conf
        cp -r ${./tmux.reset.conf} $out/tmux

        mkdir $out/tmux/plugins
        cp -r ${plugins} $out/tmux/plugins
      '';
in
tmux
