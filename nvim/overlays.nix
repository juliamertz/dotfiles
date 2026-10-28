{
  sources,
  inputs,
}:
prev: final:
let
  overrideSrc =
    pkg: src:
    pkg.overrideAttrs {
      inherit src;
    };
in
{
  vimPlugins = final.vimPlugins // {
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
    strudel-nvim =
      let
        src = sources.strudel-nvim;
        pluginSource = prev.buildNpmPackage {
          name = "strudel-nvim-built";
          version = "dev";
          inherit src;

          npmDeps = prev.importNpmLock { npmRoot = sources.strudel-nvim; };
          npmConfigHook = prev.importNpmLock.npmConfigHook;
          dontNpmBuild = true;

          env.PUPPETEER_SKIP_DOWNLOAD = "1";

          installPhase = ''
            runHook preInstall
            mkdir -p "$out"
            cp -r lua js node_modules package.json package-lock.json "$out/"
            runHook postInstall
          '';
        };
      in
      prev.vimUtils.buildVimPlugin {
        pname = "strudel.nvim";
        src = pluginSource;
        version = "dev";
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
