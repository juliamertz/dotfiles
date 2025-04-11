sources: prev: final: let
  overrideSrc = pkg: src:
    pkg.overrideAttrs {
      inherit src;
    };
in {
  vimPlugins =
    final.vimPlugins
    // {
      snacks-nvim = overrideSrc final.vimPlugins.snacks-nvim sources.snacks;
      rose-pine = overrideSrc final.vimPlugins.rose-pine sources.rose-pine;
      noogle-nvim = sources.noogle.packages.${prev.system}.noogle-nvim;
      godoc-nvim = prev.vimUtils.buildVimPlugin {
        pname = "godoc.nvim";
        version = "dev";
        src = sources.godoc;
        nvimSkipModule = [
          "godoc"
          "godoc.pickers.init"
          "godoc.pickers.telescope"
          "godoc.pickers.snacks"
          "godoc.pickers.fzf_lua"
          "godoc.adapters.init"
          "godoc.adapters.go"
        ];
      };
    };

  vscode-lldb-bin = final.stdenvNoCC.mkDerivation {
    name = "vscode-lldb";
    src = prev.vscode-extensions.vadimcn.vscode-lldb;
    installPhase = ''
      mkdir -p $out/bin
      ln -svf $src/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/codelldb
    '';
  };
}
