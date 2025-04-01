{ fetchFromGitHub, ... }:
{
  inputs = {
    godoc = "github:fredrikaverpil/godoc.nvim";
    nixcats = "github:BirdeeHub/nixCats-nvim";
    noogle = "github:juliamertz/noogle-cli";
    rose-pine = "github:rose-pine/neovim";
    snacks = "github:folke/snacks.nvim";
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
      rev = "212178d2ceb8f1997848a38b8f9ef4bd185e0045";
      hash = "sha256-R1HPtByFlpyV9Yt9PA85P1Z2Z1/9iGMhbGpXeC6tW4I=";
    };
    noogle = fetchFromGitHub {
      owner = "juliamertz";
      repo = "noogle-cli";
      rev = "26bd7d0ad085c68d6f50ed96714a24ce96c4ddac";
      hash = "sha256-OTL8Si3JxnElm8T/YMSaUOBm5Oj7vnsT/L3C5ML6+Ho=";
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
