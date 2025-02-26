{ inputs, system, ... }:
{
  plugins.lsp.servers.zls = {
    enable = true;
    package = inputs.zls.packages.${system}.default;
  };
}

