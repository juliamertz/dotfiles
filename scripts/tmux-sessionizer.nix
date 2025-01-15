{ writeShellScriptBin, lib, fzf, ... }:
writeShellScriptBin "tmux-sessionizer" ''
  if [[ $# -eq 1 ]]; then
  	selected=$1
  else
  	selected=$(find ~/projects/* ~/ -mindepth 1 -maxdepth 1 -type d | ${lib.getExe fzf})
  fi

  if [[ -z $selected ]]; then
  	exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)
  tmux_running=$(pgrep tmux)

  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  	tmux new-session -s $selected_name -c $selected
  	exit 0
  fi

  if ! tmux has-session -t=$selected_name 2>/dev/null; then
  	tmux new-session -ds $selected_name -c $selected
  	send ls Enter
  fi

  tmux switch-client -t $selected_name
''
