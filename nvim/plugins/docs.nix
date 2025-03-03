{
  system,
  inputs,
  ...
}:
{
  plugins.godoc = {
    enable = true;
    settings = {
      picker.type = "telescope";
      window.type = "vsplit";
      adapters = [
        { name = "go"; }
        {
          name = "nix";
          setup.__raw = "function() return require('noogle').setup() end";
        }
      ];
    };
  };

  keymaps = [
    {
      key = "<leader>gd";
      action = "<cmd>GoDoc<cr>";
      options.desc = "Search go documentation";
    }
    {
      key = "<leader>nd";
      action = "<cmd>Noogle<cr>";
      options.desc = "Search nix documentation";
    }
  ];

  extraPlugins = [
    inputs.noogle.packages.${system}.noogle-nvim
  ];
}
