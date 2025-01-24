{
  pkgs,
  lib,
  symlinkJoin,
  runCommand,
  makeWrapper,
  stdenv,
  perl,
  ...
}:
let
  shebang2nix =
    name: scriptPath:
    let
      script = # perl
        ''
          my %parsed;
          my $out = $ENV{"out"};

          open my $script_file, ">", "$out/script" or die "$!";
          open my $interpreter_file, ">", "$out/interpreter" or die "$!";
          open my $packages_file, ">", "$out/packages" or die "$!";

          while ( my $line = <STDIN> ) {
              chomp $line;
              if ( $line =~ /^#!\s*(.*)/ ) {
                  my $content = $1;    # Extract the content after #!
                  if ( $content =~ /nix-shell/ ) {

                      # Extract interpreter (-i)
                      if ( $content =~ /-i\s+(\S+)/ ) {
                          $parsed{interpreter} = $1;
                      }

                      # Extract packages (-p)
                      if ( $content =~ /-p\s+((?:\S+\s*)+)/ ) {
                          my $packages = $1;
                          $parsed{packages} = [ split /\s+/, $packages ];
                      }
                  }
              }
              else {
                  print $script_file "$line\n";
              }
          }

          close $script_file;

          print $interpreter_file "$parsed{interpreter}"; 
          close $interpreter_file;

          print $packages_file join( " ", @{ $parsed{packages} } ); 
          close $packages_file;
        '';

      parsed = runCommand "parse-shebang-${name}" { nativeBuildInputs = [ perl ]; } ''
        mkdir -p $out
        perl -e '${script}' < ${scriptPath}
        chmod +x $out/script
        cat $out/script > ./temp
      '';

      packages = builtins.readFile "${parsed}/packages";
      interpreter = pkgs.${builtins.readFile "${parsed}/interpreter"} or "/bin/sh";
      deps = map (n: pkgs.${n}) (
        builtins.filter (e: builtins.isString e && e != "") (builtins.split " " packages)
      );
    in
    stdenv.mkDerivation {
      inherit name;
      buildInputs = [ makeWrapper ];
      src = parsed;
      buildPhase = ''
        mkdir -p $out/bin

        echo "#!${interpreter}" > $out/temp
        cat ${parsed}/script >> $out/temp
        install --mode +x $out/temp $out/bin/${name}
        rm $out/temp

        wrapProgram $out/bin/${name} \
          --prefix PATH : "${lib.makeBinPath deps}"
      '';
    };

  readScripts =
    path:
    let
      isScript = name: !(builtins.match ".*\\..*" name != null);
      files = builtins.readDir path;
    in
    builtins.filter isScript (builtins.attrNames files);

  scripts = map (name: shebang2nix name (./. + "/${name}")) (readScripts ./.);
in
symlinkJoin {
  name = "scripts";
  paths = scripts;
}
