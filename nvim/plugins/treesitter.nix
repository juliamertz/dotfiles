{ vimPlugins, ... }:
{
  plugins.treesitter = {
    enable = true;
    grammarPackages = with vimPlugins.nvim-treesitter.builtGrammars; [
      # programming languages
      lua
      nix
      zig
      rust
      go
      javascript
      typescript
      python

      # config formats
      json
      xml
      toml
      yaml

      # scripting
      bash
      make
      regex

      markdown
      vimdoc
    ];

    nixvimInjections = true;

    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = [ ];
      };
    };
  };
}
