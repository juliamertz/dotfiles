{
  extraFiles = {
    "queries/rust/injections.scm" = builtins.readFile ../queries/rust/injections.scm;
  };

  plugins.rustaceanvim.enable = true;
}
