{
  pkgs,
  lib,
  runCommandNoCC,
  ...
}:
let
  combineDerivations =
    name: derivations:
    let
      copy =
        der: # sh
        "cp -r ${der} $out/${der.repo}";
      commands = map copy derivations;
    in
    runCommandNoCC name { } ''
      mkdir $out
      ${lib.concatStringsSep "\n" commands}
    '';
in
rec {
  combined = combineDerivations "plugins" [
    tpm
    tmux-sensible
    tmux-yank
    tmux-fzf
    tmux-rosepine
  ];

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
}
