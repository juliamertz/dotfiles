{
  plugins.luasnip = {
    enable = true;
    fromLua = [
      {
        paths = ../snippets;
      }
    ];
  };

  keymaps = [
    {
      action.__raw = ''function() require'luasnip'.expand() end'';
      key = "<C-k>";
      mode = "i";
      options = {
        desc = "Expand snippet";
      };
    }
    {
      action.__raw = ''function() require'luasnip'.jump(1) end'';
      key = "<C-l>";
      mode = ["i" "s"];
      options = {
        desc = "Jump to next position";
      };
    }
    {
      action.__raw = ''function() require'luasnip'.jump(-1) end'';
      key = "<C-h>";
      mode = ["i" "s"];
      options = {
        desc = "Jump to previous position";
      };
    }
  ];
}
