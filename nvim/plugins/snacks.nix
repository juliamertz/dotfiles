{
  pkgs,
  lib,
  vimPlugins,
  config,
  ...
}:
{
  plugins.trouble = {
    enable = true;
    settings = {
      auto_close = true;
      modes = {
        symbols = {
          desc = "document symbols";
          mode = "lsp_document_symbols";
          focus = true;
          win = {
            position = "right";
            size = 0.4;
          };
        };
      };
    };
  };

  plugins.snacks = {
    enable = true;
    settings = {
      notifier.enabled = true;
      image.enabled = true;
      bigfile.enabled = true;
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

  keymaps = lib.optionals config.plugins.trouble.enable [
    {
      key = "<leader>pr";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      key = "<leader>vrr";
      action = "<cmd>Trouble lsp_references toggle<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      key = "<leader>td";
      action = "<cmd>Trouble todo toggle<cr>";
      options.desc = "Symbols (Trouble)";
    }
  ];
}
