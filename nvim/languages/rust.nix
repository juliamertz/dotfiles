{
  extraFiles = {
    "queries/rust/injections.scm".text = builtins.readFile ../queries/rust/injections.scm;
  };

  plugins.rustaceanvim.enable = true;
}
