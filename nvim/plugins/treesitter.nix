{ vimPlugins, ... }:
{
  plugins.treesitter = {
    enable = true;
    # grammarPackages = config.plugins.treesitter.package.passthru.allGrammars;
    grammarPackages = with vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      json
      lua
      make
      markdown
      nix
      regex
      toml
      vimdoc
      xml
      yaml
      zig
      rust
      javascript
      python
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
