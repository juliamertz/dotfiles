{ pkgs, lib, ... }:
{
  # language server
  plugins.lsp.servers.ocamllsp = {
    enable = true;
    package = pkgs.ocamlPackages.ocaml-lsp;
  };

  # formatting
  plugins.conform-nvim.settings = {
    formatters_by_ft.ocaml = [ "ocamlformat" ];
    formatters.ocamlformat = {
      command = lib.getExe pkgs.ocamlformat;
      stdin = false;
      args = [
        "--inplace"
        "--enable-outside-detected-project"
        "-p"
        "janestreet"
        "$FILENAME"
      ];
    };
  };
}
