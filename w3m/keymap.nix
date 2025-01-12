{ writeText, ... }:
let
  keybinds = # sh
    ''
      # Navigation
      keymap $ LINE_END
      keymap ^ LINE_BEGIN
      keymap 0 LINE_BEGIN
      keymap G END
      keymap gg BEGIN
      keymap ESC-g GOTO_LINE
      keymap w NEXT_WORD
      keymap b PREV_WORD

      # NPage Navigation
      keymap j COMMAND "MOVE_DOWN1"
      keymap k COMMAND "MOVE_UP1"

      # Undo
      keymap C-r REDO

      #keymap C-f NEXT_PAGE
      keymap C-f COMMAND "NEXT_PAGE"
      #keymap C-b PREV_PAGE
      keymap C-b COMMAND "PREV_PAGE"
      keymap H BACK
      keymap r RELOAD

      # Tab stuff
      keymap J NEXT_TAB
      keymap K PREV_TAB
      keymap o GOTO
      keymap O TAB_GOTO

      # Search
      keymap / WHEREIS
      keymap ? SEARCH_BACK
      keymap n SEARCH_NEXT
      keymap N SEARCH_PREV

      # Commands
      keymap :: COMMAND
      keymap :help HELP
      keymap :downloads DOWNLOAD_LIST
      #keymap :hist HISTORY
      keymap :q EXIT
      keymap :settings OPTIONS

      # copy url to clipboard
      keymap yy EXTERN 'printf %s | xclip -selection clipboard'
    '';

    reset = # sh
    ''
    keymap + NULL
    keymap C-v NULL
    keymap SPC NULL
    keymap ^[[6~ NULL
    keymap - NULL
    keymap ESC-v NULL
    keymap ^[[5~ NULL
    keymap b NULL
    keymap C-f NULL
    keymap C-b NULL
    keymap C-f NULL
    keymap C-b NULL
    keymap C-n NULL
    keymap C-p NULL
    keymap J NULL
    keymap K NULL
    keymap > NULL
    keymap < NULL
    keymap , NULL
    keymap . NULL
    keymap C-a NULL
    keymap ^ NULL
    keymap $ NULL
    keymap C-e NULL
    keymap 0 NULL
    keymap Z NULL
    keymap z NULL
    keymap w NULL
    keymap W NULL
    keymap b NULL
    keymap ESC-g NULL
    keymap ESC-< NULL
    keymap ESC-> NULL
    keymap ^[[1~ NULL
    keymap ^[[4~ NULL
    keymap G NULL
    keymap g NULL
    keymap [ NULL
    keymap ] NULL
    keymap TAB NULL
    keymap C-u NULL
    keymap ESC-TAB NULL
    keymap ^[[Z NULL
    keymap ESC-m NULL
    keymap u NULL
    keymap C-r NULL
    keymap C-j NULL
    keymap C-m NULL
    keymap C-t NULL
    keymap ESC-C-j NULL
    keymap ESC-C-m NULL
    keymap a NULL
    keymap I NULL
    keymap ESC-I NULL
    keymap c NULL
    keymap u NULL
    keymap i NULL
    keymap = NULL
    keymap C-g NULL
    keymap : NULL
    keymap ";" NULL
    keymap ESC-: NULL
    keymap F NULL
    keymap M NULL
    keymap ESC-M NULL
    keymap L NULL
    keymap ESC-l NULL
    keymap U NULL
    keymap ESC-u NULL
    keymap V NULL
    keymap @ NULL
    keymap "#" NULL
    keymap | NULL
    keymap B NULL
    keymap C-_ NULL
    keymap s NULL
    keymap v NULL
    keymap ESC-s NULL
    keymap S NULL
    keymap E NULL
    keymap ESC-e NULL
    keymap R NULL
    keymap r NULL
    keymap C-l NULL
    keymap T NULL
    keymap C-q NULL
    keymap { NULL
    keymap } NULL
    keymap ESC-t NULL
    keymap J NULL
    keymap K NULL
    keymap ESC-b NULL
    keymap ESC-a NULL
    keymap / NULL
    keymap ? NULL
    keymap n NULL
    keymap N NULL
    keymap C-s NULL
    keymap C-r NULL
    keymap ESC-w NULL
    keymap ESC-W NULL
    keymap C-@ NULL
    keymap ESC-n NULL
    keymap ESC-p NULL
    keymap \" NULL
    keymap ^[[28~ NULL
    keymap ^[[2~ NULL
    keymap ^[[E NULL
    keymap ^[[L NULL
    keymap H NULL
    keymap o NULL
    keymap r NULL
    keymap C-k NULL
    keymap C-h NULL
    keymap D NULL
    keymap m NULL
    keymap C-w NULL
    keymap ESC-c NULL
    keymap ESC-o NULL
    keymap ESC-k NULL
    keymap ! NULL
    keymap C-z NULL
    keymap q NULL
    keymap Q NULL
    '';
in
writeText "keymap" (reset + keybinds)
