{
  emacs,
  wrapPackage,
  ...
}: let
  emacsPackages = epkgs:
    with epkgs; [
      use-package
      general
      evil
      evil-collection
      evil-markdown
      catppuccin-theme
      magit

      # language support
      markdown-mode
      lsp-mode
      lsp-ui
      rustic
      nix-mode
      nixfmt
    ];
in
  wrapPackage {
    package = emacs.pkgs.withPackages emacsPackages;
    extraFlags = [
      "--load ${./init.el}"
    ];
  }
