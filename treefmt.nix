{ ... }:
{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    taplo.enable = true;
    shfmt.enable = true;
    stylua = {
      enable = true;
      settings = {
        quote_style = "AutoPreferSingle";
        call_parentheses = "None";
      };
    };
  };
}
