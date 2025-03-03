{
  plugins = {
    lsp = {
      enable = true;

      keymaps = {
        lspBuf = {
          "gd" = "definition";
          "K" = "hover";
          "<leader>vrn" = "rename";
        };
      };

      servers = {
        bashls.enable = true;
        cssls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        clangd.enable = true;
        volar.enable = true;
      };
    };

  };
}
