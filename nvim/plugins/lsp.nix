{
  plugins = {
    # lspkind.enable = true;
    # lsp-lines.enable = true;
    # lsp-signature.enable = true;

    lsp = {
      enable = true;

      keymaps = {
        lspBuf = {
          "gd" = "definition";
          "K" = "hover";
          "<leader>vrn" = "rename";

          # "gD" = "declaration";
          # "gi" = "implementation";

					# vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					# vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					# vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
					# vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
					# vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
					# vim.keymap.set('n', '<leader>vws', require('telescope.builtin').lsp_workspace_symbols, opts)
        };
      };

      servers = {
        bashls.enable = true;
        cssls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        clangd.enable = true;
        denols.enable = true;
        gopls.enable = true;
        nil_ls.enable = true;
        zls.enable = true;
        volar.enable = true;
        ts_ls.enable = true;
      };

    };
  };
}
