CURRENT_BG='NONE'
PRIMARY_FG=black

SEGMENT_SEPARATOR="\ue0b0"
BRANCH="\ue725"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"
NIX_ICON=""

function ansi_color_escape() {
	print -n "\x1b[${1}m"
}

function color_code() {
	case "$1" in
    "black") echo 30;;
    "brblack") echo 90;;
    "red") echo 31;;
    "green") echo 32;;
    "yellow") echo 33;;
    "blue") echo 34;;
    "magenta") echo 35;;
    "cyan") echo 36;;
    "white") echo 37;;
    "default") echo 39;;
    "reset") echo 0;;
    *) ;;
	esac
}

function c() {
  ansi_color_escape $(color_code $1)
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
		print -n "%{$bg%F{$CURRENT_BG}%}%{$fg%}"
	else
		print -n "%{$bg%}%{$fg%}"
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && print -n $3
}

print_right() {
  clean=$(echo "$1" | sed -E 's/\x1b\[[0-9;]*[a-zA-Z]//g')
  
  local cols=$(tput cols)
  local len=${#clean}
  (( offset = $cols - $len + 1 ))

  print -f "\x1b[${offset}G"
  print -f $1
}

# takes the segment as the first argument
# takes ansi color name as the second
print_segment() {
  print -n "$(c $2)$1$(c reset)"
}

print_padding() {
  print -n " "
}

print_newline() {
	NEWLINE=$'\n'
  print -n $NEWLINE
}

# Context: user@hostname
prompt_context() {
  print_segment "$(whoami)" white
  print_segment "@" brblack
  print_segment "$(hostname)" white
  print_padding
}

prompt_nix_shell() {
  local in_shell="$IN_NIX_SHELL"
	if [[ -n $in_shell ]]; then
    print_segment "$NIX_ICON $in_shell" blue
	fi
}

# Dir: current working directory
prompt_dir() {
	print_segment '%~ ' blue
}

# Git: branch/detached head, dirty status
prompt_git() {
	local color ref
	is_dirty() {
		test -n "$(git status --porcelain --ignore-submodules)"
	}
	ref="$vcs_info_msg_0_"
	if [[ -n "$ref" ]]; then
    print_segment $ref green
    print_padding

		if is_dirty; then
      print_segment "~" yellow
      print_padding
		fi
	fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
	local symbols
	symbols=()
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

	[[ -n "$symbols" ]] && prompt_segment CURRENT_BG default "$symbols "
}

prompt_caret() {
  print_newline
  print -n "$(c magenta);$(c reset) "
}

# End the prompt, closing any open segments
prompt_end() {
	print -n "%{%k%}"
	print -n "%{%f%}"
	CURRENT_BG=''
}

## Main prompt
prompt_main() {
	RETVAL=$?
	CURRENT_BG='NONE'
	prompt_status
	# prompt_context
	prompt_dir
	prompt_git
  # print_right "$(prompt_right)"

	prompt_caret
	prompt_end
}

prompt_right() {
  prompt_context
  prompt_nix_shell
}

prompt_precmd() {
  print
	vcs_info
	PROMPT="%{%f%b%k%}$(prompt_main)"
}

prompt_setup() {
	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info

	prompt_opts=(cr subst percent)
	add-zsh-hook precmd prompt_precmd

	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' check-for-changes false
	zstyle ':vcs_info:git*' formats '%b'
	zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_setup "$@"
