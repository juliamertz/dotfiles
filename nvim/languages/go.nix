{
  extraFiles = {
    "queries/go/injections.scm" = builtins.readFile ../queries/go/injections.scm;
  };

  plugins.lsp.servers.gopls.enable = true;
}
