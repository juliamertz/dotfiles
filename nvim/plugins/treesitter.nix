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
      yuck

      # scripting
      bash
      make
      regex

      # web
      html
      css
      scss

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
