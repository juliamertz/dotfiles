{
  pkgs,
  system,
  inputs,
  ...
}:
{
  plugins.lsp.servers.nil_ls = {
    enable = true;
    package = inputs.nil.packages.${system}.default;
    settings = {
      nix = {
        flake = {
          autoArchive = true;
        };
      };
    };
  };

  extraPackages = with pkgs; [ nurl ];
  extraConfigLuaPost = ''
    vim.api.nvim_create_user_command('Nurl', 'read !nurl <args> 2>/dev/null', { nargs = '*' })
  '';
}
