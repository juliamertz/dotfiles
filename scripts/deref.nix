{ writeShellScriptBin, bash, ... }:
writeShellScriptBin "deref" ''
  #!${bash}

  if [ -h "$1" ] ; then
    target=`readlink $1`
    rm -v "$1"
    cp -vr "$target" "$1"
  fi
''
