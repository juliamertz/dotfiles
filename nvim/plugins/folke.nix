{
  pkgs,
  vimPlugins,
  lib,
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
    package = vimPlugins.snacks-nvim.overrideAttrs (prev: {
      nvimSkipModule = prev.nvimSkipModule ++ [ "snacks.image.convert" ];
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "5fa93cb6846b5998bc0b4b4ac9de47108fe39ce6";
        hash = "sha256-mGGfZfLpSoyRsx/5wOF8KBmT02yQbIiHHmSOwdXA8KA=";
      };
    });
    settings = {
      notifier.enabled = true;
      image.enabled = true;
    };
  };

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
