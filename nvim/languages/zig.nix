{ inputs, system, ... }:
{
  plugins.lsp.servers.zls = {
    enable = true;
    package = null; # prefer zls provided by devshells
  };
}

