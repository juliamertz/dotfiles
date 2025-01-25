{
  # extraFiles = {
  #   "queries/nu/highlights.scm" = builtins.readFile "${tree-sitter-nu}/queries/highlights.scm";
  #   "queries/nu/injections.scm" = builtins.readFile "${tree-sitter-nu}/queries/injections.scm";
  # };

  plugins.lsp.servers.nil_ls = {
    enable = true;
    package = null;
    settings = {
      nix = {
        flake = {
          autoArchive = true;
        };
      };
    };
  };
}
