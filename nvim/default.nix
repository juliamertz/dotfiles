{
  ripgrep,
  stdenv,

  vimPlugins,
  inputs,
  system,
  pkgs,
  ...
}:
let
  nixvim' = inputs.nixvim.legacyPackages.${system};
  nixvimModule = {
    inherit pkgs;
    module = import ./config.nix;
    extraSpecialArgs = { inherit vimPlugins; };
  };

  # plugins =
  #   linkFarmFromDrvs "neovim-plugins"
  #   <| (with vimPlugins; [
  #     rose-pine
  #     harpoon2
  #     telescope-nvim
  #     conform-nvim
  #     snacks-nvim
  #     trouble-nvim
  #     lazydev-nvim
  #     nvim-tree-lua
  #     oil-nvim
  #     noice-nvim
  #     nui-nvim
  #     ccc-nvim
  #     plenary-nvim
  #     render-markdown-nvim
  #     todo-comments-nvim
  #     mini-statusline
  #     mini-surround
  #     mini-git
  #     mini-icons
  #     (nvim-treesitter.withPlugins (
  #       plugins: with plugins; [
  #         nix
  #         lua
  #       ]
  #     ))
  # ]);

in
nixvim'.makeNixvimWithModule nixvimModule
