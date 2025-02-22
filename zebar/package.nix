{
  lib,
  stdenv,
  fetchFromGitHub,

  nodejs,
  pnpm_9,

  makeWrapper,
  makeRustPlatform,
  rust-bin,
  cargo-tauri,

  pkg-config,
  openssl,
  glib-networking,
  pango,
  webkitgtk_4_1,
  libayatana-appindicator,
  wrapGAppsHook4,
}:
let
  src = fetchFromGitHub {
    owner = "glzr-io";
    repo = "zebar";
    rev = "83265bbd7e5a3ca038f8a79ac5286ceedb5b0d36";
    hash = "sha256-ctgbuG81IaJ1TpPWVaXePUImGMn429fdoQIdBGzHaYU=";
  };

  manifest = (lib.importTOML "${src}/packages/desktop/Cargo.toml");
  toolchain = (rust-bin.fromRustupToolchainFile "${src}/rust-toolchain.toml");
  rustPlatform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
rustPlatform.buildRustPackage {
  inherit (manifest.package) name version;
  inherit src;

  useFetchCargoVendor = true;
  cargoHash = "sha256-SQjr1HNnD7Ys5D7s6HH3/jGwy+TSLEgSmbrArS1wN/g=";

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pnpm_9.configHook

    pkg-config
    wrapGAppsHook4
    makeWrapper
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      glib-networking
      webkitgtk_4_1
      pango
      libayatana-appindicator
    ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit src;
    pname = "zebar";
    hash = "sha256-3h9YjoAEFpUa9XpCoMoEvdvOI+FiEcut4wDdWy94a4c=";
  };

  # build fontend
  preBuild = ''
    pnpm run --filter zebar --filter @zebar/settings-ui build
  '';

  postFixup =
    lib.optionalString stdenv.isLinux
      # sh
      ''
        # lib-appindicator is loaded dynamically so autopatch doesn't detect it
        # https://discourse.nixos.org/t/set-ld-library-path-globally-configuration-nix/22281/5
        wrapProgram $out/bin/zebar \
          --set LD_LIBRARY_PATH "${libayatana-appindicator}/lib"
      ''
    +
      lib.optionalString stdenv.isDarwin
        # sh
        ''
          mkdir -p $out/bin
          ln -sf $out/Applications/Zebar.app/Contents/MacOS/zebar $out/bin/zebar
        '';

  buildAndTestSubdir = "packages/desktop";

  RUST_BACKTRACE = 1;

  meta = with lib; {
    mainProgram = "zebar";
    description = "A tool for creating customizable and cross-platform taskbars, desktop widgets, and popups.";
    homepage = "https://github.com/glzr-io/zebar";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
