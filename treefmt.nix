{
  system,
  inputs,
  ...
}: {
  projectRootFile = "flake.nix";

  programs = {
    taplo.enable = true;

    mdformat.enable = true;

    shfmt.enable = true;

    alejandra = {
      enable = true;
      package = inputs.alejandra.packages.${system}.default;
    };

    stylua = {
      enable = true;
      settings = {
        quote_style = "AutoPreferSingle";
        call_parentheses = "None";
      };
    };
  };
}
