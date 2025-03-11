{
  pkgs,
  lib,
  system,
  inputs,
  ...
}:
{
  # language server
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

  # formatting
  plugins.conform-nvim.settings = {
    formatters_by_ft.nix = [ "nixfmt" ];
    formatters.nixfmt = {
      command = lib.getExe pkgs.nixfmt-rfc-style;
    };
  };

  # utilities
  userCommands.Nurl = {
    command = "read !${lib.getExe pkgs.nurl} <args> 2>/dev/null";
    nargs = "*";
  };
}
