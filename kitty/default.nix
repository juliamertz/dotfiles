{
  wrapPackage,
  writeText,
  pkgs,
  ...
}:
let
  config = writeText "kitty.conf" ''
    include         ${./themes/rose-pine-moon.conf}

    font_size        22.00
    font_family      JetBrainsMono Nerd Font Mono

    hide_window_decorations titlebar-only
    window_padding_width    10 10 0 10
    tab_bar_style           fade
    tab_title_template      {index}
    background_opacity      0.70

    map alt+1 goto_tab 1
    map alt+2 goto_tab 2
    map alt+3 goto_tab 3
    map alt+4 goto_tab 4
    map alt+5 goto_tab 5
    map alt+6 goto_tab 6
    map alt+7 goto_tab 7
    map alt+8 goto_tab 8
    map alt+9 goto_tab 9
    map alt+t launch --cwd=current --type=tab
    map alt+w close_tab
  '';
in
wrapPackage {
  name = "kitty";
  package = pkgs.kitty;
  extraFlags = "--config ${config}";
}
