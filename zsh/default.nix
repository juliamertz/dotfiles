{
  pkgs,
  callPackage,
  packages,
  ...
}: let
  plugins = callPackage ./pins.nix {};
  builder = callPackage ./builder.nix {};

  categoryDefinitions = {
    pluginPackages = with plugins.sources; {
      general = [
        zsh-syntax-highlighting
      ];
      completion = [
        ez-compinit
        zsh-completions
        zsh-autosuggestions
      ];
      extra_completion = [
        zsh-autocomplete
      ];
      fzf = [
        fzf-tab
      ];
      vim = [
        zsh-vi-mode
      ];
    };

    runtimeDeps = with pkgs; {
      atuin = [atuin];
      prompt = [packages.starship];
      zoxide = [zoxide];
      fzf = [fzf];
      rust_coreutils = [
        uutils-coreutils-noprefix
        eza # ls replacement
        dust # du replacement
      ];
      general = [bat];
    };

    environmentVariables = {
      general = {
        SCRIPTS_DIR = packages.scripts;
      };
    };
  };

  packageDefinitions = {
    categories = {
      general = true;
      have_nerd_font = true;

      highlight = true;
      extra_completion = false;
      completion = true;
      fzf = false;
      vim = true;
      atuin = true;
      prompt = true;
      zoxide = true;
      rust_coreutils = true;
    };
  };
in
  builder.buildShell {
    inherit categoryDefinitions packageDefinitions;
    configDir = ./.;
  }
