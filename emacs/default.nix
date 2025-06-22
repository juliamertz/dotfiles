{
  emacs,
  wrapPackage,
  ...
}: let
  emacsPackages = epkgs:
    with epkgs; [
      use-package
      magit
      evil
      evil-collection
      evil-markdown
      catppuccin-theme

      # modes
      markdown-mode
      lsp-mode
      rustic
    ];
in
  wrapPackage {
    package = emacs.pkgs.withPackages emacsPackages;
    extraFlags = [
      "--load ${./init.el}"
    ];
  }
