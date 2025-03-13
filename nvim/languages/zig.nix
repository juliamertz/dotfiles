{ pkgs, ... }:
{
  # language server
  plugins.lsp.servers.zls = {
    enable = true;
    # zls will not work if there is the tiniest version mismatch between lsp and zig version
    # for that reason it's better to prefer whatever zls package is in path provided by a devshell
    package = null;
  };

  # formatting
  plugins.conform-nvim.settings = {
    formatters_by_ft.zig = [ "zigfmt" ];
  };

  # by default neovim formats zig files on save, this should be fixed in 11.0
  # https://github.com/ziglang/zig.vim/issues/51
  globals.zig_fmt_autosave = 0;

  # debugger
  plugins.dap.configurations.zig = [
    {
      name = "Launch";
      type = "codelldb";
      request = "launch";
      cwd = "$\{workspaceFolder}";
      stopOnEntry = false;

      program.__raw = ''
        function()
          local zig_out = vim.fn.getcwd() .. "/zig-out/bin/"
          -- check if zig-out contains executable with name of project directory
          local project_name = vim.fs.basename(vim.fn.getcwd())
          if vim.fn.filereadable(zig_out .. project_name) == 1 then
            return zig_out .. project_name 
          end

          -- otherwise prompt for executable name
          return vim.fn.input("Path to executable: ", zig_out, "file")
        end
      '';
      args.__raw = ''
        function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, " ")
        end
      '';
    }
  ];

}
