{
  pkgs,
  wrapPackage,
  symlinkJoin,
  combineDerivations,
  ...
}:
let
  mkPlugins = p: combineDerivations "bash-plugin-sources" p;
  mkDeps =
    deps:
    symlinkJoin {
      name = "bash-runtime-dependencies";
      paths = deps;
    };

  pluginPackages =
    with pkgs;
    mkPlugins [
      # (fetchFromGitHub {
      #   owner = "jeffreytse";
      #   repo = "zsh-vi-mode";
      #   rev = "cd730cd347dcc0d8ce1697f67714a90f07da26ed";
      #   hash = "sha256-UQo9shimLaLp68U3EcsjcxokJHOTGhOjDw4XDx6ggF4=";
      # })
      # (fetchFromGitHub {
      #   owner = "zsh-users";
      #   repo = "zsh-syntax-highlighting";
      #   rev = "5eb677bb0fa9a3e60f0eff031dc13926e093df92";
      #   hash = "sha256-KRsQEDRsJdF7LGOMTZuqfbW6xdV5S38wlgdcCM98Y/Q=";
      # })
      # (fetchFromGitHub {
      #   owner = "zsh-users";
      #   repo = "zsh-completions";
      #   rev = "c160d09fddd28ceb3af5cf80e9253af80e450d96";
      #   hash = "sha256-EG6bwbwZW9Cya/BGZ83J5YEAUdfJ0UAQC7bRG7cFL2k=";
      # })
      # (fetchFromGitHub {
      #   owner = "zsh-users";
      #   repo = "zsh-autosuggestions";
      #   rev = "0e810e5afa27acbd074398eefbe28d13005dbc15";
      #   hash = "sha256-85aw9OM2pQPsWklXjuNOzp9El1MsNb+cIiZQVHUzBnk=";
      # })
      # (fetchFromGitHub {
      #   owner = "Aloxaf";
      #   repo = "fzf-tab";
      #   rev = "6aced3f35def61c5edf9d790e945e8bb4fe7b305";
      #   hash = "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=";
      # })
    ];

  runtimeDependencies = with pkgs; [
    bat
    atuin
    starship
    blesh
    jq
    zoxide
  ];
in
wrapPackage {
  name = "bash";
  package = pkgs.bashInteractive;
  extraArgs = [
    "--set DOTDIR '${./.}'"
    "--set RUNTIMEDEPS '${mkDeps runtimeDependencies}/bin'"
    "--set PLUGINDIR '${pluginPackages}'"
    "--set ATUIN_CONFIG_DIR '${../atuin}'"
    "--set STARSHIP_CONFIG ${../starship/prompt.toml}"
    "--set EDITOR nvim"
  ];
}
