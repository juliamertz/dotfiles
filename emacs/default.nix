{
  emacs,
  wrapPackage,
  ...
}: let
  emacsPackages = epkgs:
    with epkgs; [
      evil
      evil-collection
      use-package
      catppuccin-theme
    ];
in
  wrapPackage {
    package = emacs.pkgs.withPackages emacsPackages;
    extraFlags = [
      "--load ${./init.el}"
    ];
  }
