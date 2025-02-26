{ inputs, system, ... }:
{
  plugins.lsp.servers.nil_ls = {
    enable = true;
    package = inputs.nil.packages.${system}.default;
    settings = {
      nix = {
        flake = {
          autoArchive = true;
        };
      };
    };
  };
}
