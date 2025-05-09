# this file was generated by nixpins (https://github.com/juliamertz/nixpins)
{fetchFromGitHub, ...}: let
  fetchFlake = attrs: builtins.getFlake "${attrs.url}/${attrs.rev}";
in {
  inputs = {
    godoc.url = "github:fredrikaverpil/godoc.nvim";
    nixcats.url = "github:BirdeeHub/nixCats-nvim";
    noogle = {
      url = "github:juliamertz/noogle-cli";
      flake = true;
    };
    rose-pine.url = "github:rose-pine/neovim";
    snacks.url = "github:folke/snacks.nvim";
  };
  sources = {
    godoc = fetchFromGitHub {
      owner = "fredrikaverpil";
      repo = "godoc.nvim";
      rev = "356f79853dbb3b3e200064367603751895153c29";
      hash = "sha256-w5NP/Hb7e/ZROVvc5+C0xxz4ecnWPdo6ICaCPlpaWhs=";
    };
    nixcats = fetchFromGitHub {
      owner = "BirdeeHub";
      repo = "nixCats-nvim";
      rev = "88363047c9e5ac20001b9f3ee964fdc89cc2eb86";
      hash = "sha256-fKa0Qx29He9fug22n9PYcqshtclvWxQoplLuqti6iXM=";
    };
    noogle = fetchFlake {
      url = "github:juliamertz/noogle-cli";
      rev = "93af64622638f4edecf3ad0956ceafa06f4928db";
      hash = "sha256-MJfYtRmqoXqb2ypLFD9zLq7qKRpjA5wkC5x5lBF8lFc=";
    };
    rose-pine = fetchFromGitHub {
      owner = "rose-pine";
      repo = "neovim";
      rev = "96ff3993a67356ee85d1cdab9be652cdc1c5d1ac";
      hash = "sha256-8iXJ9MDshMOp1QZpGjF52wabN7oG1Rcz/SOWuGMW4Vw=";
    };
    snacks = fetchFromGitHub {
      owner = "folke";
      repo = "snacks.nvim";
      rev = "bc0630e43be5699bb94dadc302c0d21615421d93";
      hash = "sha256-Gw0Bp2YeoESiBLs3NPnqke3xwEjuiQDDU1CPofrhtig=";
    };
  };
}
