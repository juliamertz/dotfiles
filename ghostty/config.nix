{ writeText, stdenv, ... }:
writeText "ghostty-config"
  # toml
  ''
    theme = rose-pine-moon
    font-family = Berkeley Mono Nerd Font
    font-size = 24 

    window-decoration = ${if stdenv.isLinux then "server" else "none"}
    window-padding-x = 15
    window-padding-y = 15

    auto-update = false
  ''
