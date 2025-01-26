{
  extraFiles = {
    "queries/go/injections.scm".text = builtins.readFile ../queries/go/injections.scm;
  };

  plugins.lsp.servers.gopls.enable = true;
}
