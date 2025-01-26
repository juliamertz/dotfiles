{
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
