{ pkgs, ... }:
let
  inherit (pkgs) fetchFromGitHub tree-sitter;

  grammar = tree-sitter.buildGrammar {
    language = "qbe";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "bitterbloom";
      repo = "tree-sitter-qbe";
      rev = "20d1d194ee81c1a08d6681919d3cf09656c83b83";
      hash = "sha256-8bXG24VWqbY+Q3SWEzZeHMStQ091tY1YQNvkrhLvTEA=";
    };
    meta.homepage = "https://github.com/bitterbloom/tree-sitter-qbe";
  };
in
{
  plugins.treesitter = {
    languageRegister.qbe = "qbe";
    grammarPackages = [ grammar ];
  };

  extraFiles = {
    "queries/qbe/highlights.scm".text = builtins.readFile "${grammar}/queries/highlights.scm";
  };

  extraConfigLua = ''
    local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
    parser_config.qbe = { filetype = "qbe" }
  '';
}
