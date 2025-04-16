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
      prompt = [starship];
      zoxide = [zoxide];
      fzf = [fzf];
      uutils = [uutils-coreutils-noprefix];
      general = [bat];
    };

    environmentVariables = {
      general = {
        SCRIPTS_DIR = packages.scripts;
      };
      prompt = {
        STARSHIP_CONFIG = builtins.toString ../starship/prompt.toml;
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
      uutils = true;
    };
  };
in
  builder.buildShell {
    inherit categoryDefinitions packageDefinitions;
    configDir = ./.;
  }
