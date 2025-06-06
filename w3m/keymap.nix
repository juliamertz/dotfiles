{writeText, ...}: let
  keybinds =
    # sh
    ''
      ########## command ##########
      keymap :: COMMAND
      keymap :H HELP
      keymap :O OPTIONS
      keymap :d DOWNLOAD_LIST

      ########## history navigation ##########
      keymap L NEXT
      keymap H PREV
      keymap :p SELECT_MENU
      keymap :h HISTORY

      ########## scrolling ##########
      keymap C-e UP
      keymap C-y DOWN
      keymap gg BEGIN
      keymap G END
      keymap C-d NEXT_PAGE
      keymap d NEXT_PAGE
      keymap C-u PREV_PAGE
      keymap u PREV_PAGE
      keymap zz CENTER_V
      ########## cursor ##########
      keymap l NEXT_TAB
      keymap h PREV_TAB
      keymap j UP
      keymap k DOWN
      keymap RIGHT MOVE_RIGHT
      keymap LEFT MOVE_LEFT
      keymap DOWN MOVE_DOWN1
      keymap UP MOVE_UP1
      keymap 0 LINE_BEGIN
      keymap $ LINE_END
      keymap w NEXT_WORD
      keymap b PREV_WORD
      ########## cursor history ##########
      keymap C-i REDO
      keymap C-o UNDO
      ########## navigation ##########
      keymap f MOVE_LIST_MENU
      keymap F LIST_MENU
      keymap C-n NEXT_LINK
      keymap C-p PREV_LINK
      keymap :l PEEK_LINK

      # reload
      keymap r RELOAD
      keymap C-r RELOAD

      # save/load
      keymap :w SAVE
      keymap :W PRINT
      keymap :o GOTO
      keymap :e LOAD

      # jump
      keymap ESC-C-j SUBMIT
      keymap C-] TAB_LINK
      keymap C-y GOTO_LINK

      ########## info ##########
      keymap y PEEK
      keymap gC-g INFO
      keymap C-g LINE_INFO
      keymap gf VIEW

      ########## search ##########
      keymap / ISEARCH
      keymap ? ISEARCH_BACK
      keymap n SEARCH_NEXT
      keymap N SEARCH_PREV

      ########## bookmarks ##########
      keymap a ADD_BOOKMARK
      keymap :b VIEW_BOOKMARK

      ########## tab ##########
      keymap x CLOSE_TAB
      keymap gh GOTO http://www.google.com/en
      keymap gH TAB_GOTO http://www.google.com/en
      keymap C-t NEW_TAB
      keymap gt NEXT_TAB
      keymap gT PREV_TAB
      keymap C-wL TAB_RIGHT
      keymap C-wH TAB_LEFT
      keymap t TAB_GOTO
      keymap T TAB_MENU

      ########## quit ##########
      keymap ZZ EXIT
      keymap C-Q EXIT
      keymap ZQ QUIT
      keymap :q QUIT
    '';

  reset =
    # sh
    ''
      keymap K NULL
      keymap J NULL
      keymap SPC NULL
      keymap - NULL
      keymap + NULL
      keymap C-v NULL
      keymap ESC-v NULL
      keymap C-f NULL
      keymap C-b NULL
      keymap C-n NULL
      keymap C-p NULL
      keymap < NULL
      keymap > NULL
      keymap . NULL
      keymap , NULL
      keymap ^ NULL
      keymap C-a NULL
      keymap W NULL
      keymap ^[[6~ NULL
      keymap ^[[5~ NULL
      keymap g NULL
      keymap ^[[1~ NULL
      keymap ^[[4~ NULL
      keymap ESC-< NULL
      keymap ESC-> NULL
      keymap [ NULL
      keymap ] NULL
      keymap ^[[Z NULL
      keymap ESC-m NULL
      keymap ( NULL
      keymap ) NULL
      keymap C-j NULL
      keymap C-m NULL
      keymap ESC-C-j NULL
      keymap ESC-C-m NULL
      keymap ESC-w NULL
      keymap ESC-W NULL
      keymap C-s NULL
      keymap = NULL
      keymap ESC-l NULL
      keymap U NULL
      keymap V NULL
      keymap v NULL
      keymap R NULL
      keymap ESC-s NULL
      keymap : NULL
      keymap C-q NULL
      keymap T NULL
      keymap } NULL
      keymap { NULL
      keymap ESC-a NULL
      keymap ESC-b NULL
      keymap c NULL
      keymap ESC-: NULL
      keymap C-h NULL
      keymap q NULL
      keymap Q NULL
      keymap C-w NULL
      keymap C-d NULL
      keymap C-u NULL
      keymap RIGHT NULL
      keymap l NULL
      keymap LEFT NULL
      keymap h NULL
      keymap j NULL
      keymap DOWN NULL
      keymap k NULL
      keymap UP NULL
      keymap C-e NULL
      keymap C-y NULL
      keymap 0 NULL
      keymap $ NULL
      keymap Z NULL
      keymap z NULL
      keymap ESC-g NULL
      keymap gg NULL
      keymap G NULL
      keymap w NULL
      keymap b NULL
      keymap C-n NULL
      keymap C-p NULL
      keymap ESC-TAB NULL
      keymap f NULL
      keymap C-o NULL
      keymap TAB NULL
      keymap C-j NULL
      keymap C-] NULL
      keymap I NULL
      keymap ESC-I NULL
      keymap ESC-C-j NULL
      keymap y NULL
      keymap u NULL
      keymap i NULL
      keymap gC-g NULL
      keymap C-g NULL
      keymap ";" NULL
      keymap M NULL
      keymap ESC-M NULL
      keymap F NULL
      keymap ESC-u NULL
      keymap t NULL
      keymap @ NULL
      keymap "#" NULL
      keymap | NULL
      keymap B NULL
      keymap L NULL
      keymap H NULL
      keymap s NULL
      keymap gf NULL
      keymap S NULL
      keymap E NULL
      keymap ESC-e NULL
      keymap C-r NULL
      keymap r NULL
      keymap C-l NULL
      keymap C-t NULL
      keymap d NULL
      keymap gt NULL
      keymap gT NULL
      keymap ESC-t NULL
      keymap C-wL NULL
      keymap C-wH NULL
      keymap a NULL
      keymap n NULL
      keymap N NULL
      keymap / NULL
      keymap ? NULL
      keymap C-@ NULL
      keymap ESC-n NULL
      keymap ESC-p NULL
      keymap \" NULL
      keymap ^[[2~ NULL
      keymap ^[[28~ NULL
      keymap ^[[E NULL
      keymap ^[[L NULL
      keymap o NULL
      keymap C-k NULL
      keymap D NULL
      keymap m NULL
      keymap ESC-c NULL
      keymap ESC-o NULL
      keymap ESC-k NULL
      keymap \\ NULL
      keymap ! NULL
      keymap C-z NULL
      keymap ZZ NULL
      keymap ZQ NULL
    '';
in
  writeText "keymap" (reset + keybinds)
