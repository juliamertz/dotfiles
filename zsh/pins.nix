# this file was generated by nixpins (https://github.com/juliamertz/nixpins)
{fetchFromGitHub, ...}: {
  inputs = {
    ez-compinit.url = "github:mattmc3/ez-compinit";
    fzf-tab.url = "github:Aloxaf/fzf-tab";
    zsh-autocomplete.url = "github:marlonrichert/zsh-autocomplete";
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
      rev = "01dad759c4466600b639b442ca24aebd5178e799";
      hash = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
    };
    zsh-autocomplete = fetchFromGitHub {
      owner = "marlonrichert";
      repo = "zsh-autocomplete";
      rev = "a09c1c5c1c967a1a9541820370a9bab4edc0ab29";
      hash = "sha256-2UBY0dOUvkLjfIJKkTcN9UfwUdNiVCCQO1Ot443m4fo=";
    };
    zsh-completions = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-completions";
      rev = "e61c9c14d6978191762e9586a0c882114e49221d";
      hash = "sha256-9s9EkorKNH1DrA9rKUl/4aGIZY+7+EyryZ/69365te0=";
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
      rev = "cd730cd347dcc0d8ce1697f67714a90f07da26ed";
      hash = "sha256-UQo9shimLaLp68U3EcsjcxokJHOTGhOjDw4XDx6ggF4=";
    };
  };
}
