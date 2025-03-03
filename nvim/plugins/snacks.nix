{
  pkgs,
  lib,
  vimPlugins,
  config,
  ...
}:
{
  plugins.snacks = {
    enable = true;
    settings = {
      notifier.enabled = true;
      image.enabled = true;
      bigfile.enabled = true;
      picker.enabled = true;
    };

    package = vimPlugins.snacks-nvim.overrideAttrs (prev: {
      nvimSkipModule = prev.nvimSkipModule ++ [ "snacks.image.convert" ];
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "07f4b9adff7af45a7e0eb22d85a422e32ed4b1ca";
        hash = "sha256-EOo2ADp8CM09MQdIsd5FASGkqR/wH25zIt4Zq8woTpQ=";
      };
    });
  };

  extraPackages =
    let
      snacks = config.plugins.snacks;
    in
    lib.optionals (snacks.enable && snacks.settings.image.enabled) [ pkgs.imagemagick ];
}
