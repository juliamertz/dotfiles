# this file was generated by nixpins (https://github.com/juliamertz/nixpins)
{fetchFromGitHub, ...}: {
  inputs = {
    ez-compinit.url = "github:mattmc3/ez-compinit";
    fzf-tab.url = "github:Aloxaf/fzf-tab";
    zsh-autocomplete.url = "github:marlonrichert/zsh-autocomplete";
    zsh-autosuggestions.url = "github:zsh-users/zsh-autosuggestions";
    zsh-completions.url = "github:zsh-users/zsh-completions";
    zsh-syntax-highlighting.url = "github:zsh-users/zsh-syntax-highlighting";
    zsh-vi-mode.url = "github:jeffreytse/zsh-vi-mode";
  };
  sources = {
    ez-compinit = fetchFromGitHub {
      owner = "mattmc3";
      repo = "ez-compinit";
      rev = "ac56d203e12bd5c4c0fe00c5fbf0d7dd6abc4e14";
      hash = "sha256-lDHAzad3XoUGm8dYp6LOIwcUn3c2J4qq9Zq6adaGYuQ=";
    };
    fzf-tab = fetchFromGitHub {
      owner = "Aloxaf";
      repo = "fzf-tab";
      rev = "2abe1f2f1cbcb3d3c6b879d849d683de5688111f";
      hash = "sha256-zc9Sc1WQIbJ132hw73oiS1ExvxCRHagi6vMkCLd4ZhI=";
    };
    zsh-autocomplete = fetchFromGitHub {
      owner = "marlonrichert";
      repo = "zsh-autocomplete";
      rev = "77a4f9c1343d12d7cb3ae1e7efc7c37397ccb6b0";
      hash = "sha256-YH5T9a9KbYbvY6FRBITlhXRmkTmnwGyCQpibLe3Dhwc=";
    };
    zsh-autosuggestions = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-autosuggestions";
      rev = "0e810e5afa27acbd074398eefbe28d13005dbc15";
      hash = "sha256-85aw9OM2pQPsWklXjuNOzp9El1MsNb+cIiZQVHUzBnk=";
    };
    zsh-completions = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-completions";
      rev = "21789376b8c875fbed68398a6867f84f5c682597";
      hash = "sha256-OcRpvlTuNIOzYwq4g3QSqXkn0dk7xny8UY87jF6ffT0=";
    };
    zsh-syntax-highlighting = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-syntax-highlighting";
      rev = "5eb677bb0fa9a3e60f0eff031dc13926e093df92";
      hash = "sha256-KRsQEDRsJdF7LGOMTZuqfbW6xdV5S38wlgdcCM98Y/Q=";
    };
    zsh-vi-mode = fetchFromGitHub {
      owner = "jeffreytse";
      repo = "zsh-vi-mode";
      rev = "f82c4c8f4b2bdd9c914653d8f21fbb32e7f2ea6c";
      hash = "sha256-CkU0qd0ba9QsPaI3rYCgalbRR5kWYWIa0Kn7L07aNUI=";
    };
  };
}
