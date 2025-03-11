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
}
