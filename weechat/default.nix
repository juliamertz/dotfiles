{
  pkgs,
  weechat,
  symlinkJoin,
  makeWrapper,
  ...
}:
let
  configure = import ./configure.nix { inherit pkgs; };

  weechat-overlay = weechat.override {
    configure =
      { availablePlugins, ... }:
      {
        init = # sh
          ''
            /key bind ctrl-c /input delete_line
            /key bind ctrl-d /window page_down
            /key bind ctrl-u /window page_up

            /set fifo.file.path ~/.weechat/fifo
            /set logger.file.path ~/.weechat/log
            /set logger.file.flush_delay 1

            /bar hide buflist
            /bar hide title

            /alias add bc /buffer close

            /filter add hide_quit irc.* irc_quit *
            /filter add hide_part irc.* irc_part *

            /set weechat.color.chat_bg default
            /set weechat.color.chat_fg white
            /set weechat.color.chat_nick_self 214
            /set weechat.color.chat_prefix_error 124
            /set weechat.color.chat_prefix_network 66
            /set weechat.color.chat_prefix_action 214
            /set weechat.color.chat_highlight 142
            /set weechat.color.chat_read_marker 214
            /set weechat.color.chat_host 243
            /set weechat.color.chat_buffer 214
            /set weechat.color.separator 243
            /set weechat.look.prefix_join "👋"
            /set weechat.look.prefix_action "🌟"
            /set weechat.look.prefix_error "💢"
            /set weechat.bar.input_items ",input_text"
            /set irc.color.nicks ""
          '';
      };
  };

in
symlinkJoin {
  name = "weechat";
  paths = [
    configure.twitch
    weechat-overlay
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/weechat 
  '';
}
