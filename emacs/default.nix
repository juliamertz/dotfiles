{
  emacs,
  wrapPackage,
  ...
}:
wrapPackage {
  package =
    emacs.pkgs.withPackages
    epkgs:
      with epkgs; [
        use-package
        general
        evil
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
  extraFlags = [
    "--load ${./init.el}"
    # "--init-directory=${./.}"
  ];
}
