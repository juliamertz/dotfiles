if enableForCat "prompt"; then
  # set newline precmd for starship prompt
  starship_precmd() { echo }
	add-zsh-hook precmd starship_precmd
  try_hook starship init zsh

  return
fi

# basic fallback prompt for when configuration isn't built with nix

function print_segment() { print -n "$(clr $2)$1$(clr reset)" }

function print_padding() { print -n " " }

function print_newline() { print -n $'\n' }

function prompt_dir() { print_segment '%~ ' blue }

# Git: branch/detached head, dirty status
function prompt_git() {
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

function prompt_status() {
	local symbols
	symbols=()
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}\u2718"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}\u26a1"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}\u2699"

	[[ -n "$symbols" ]] && print_segment "$symbols " reset
}

function prompt_caret() {
  print_newline
  print -n "$(clr white);$(clr reset) "
}

# End the prompt, closing any open segments
function prompt_end() {
	print -n "%{%k%}"
	print -n "%{%f%}"
	CURRENT_BG=''
}

## Main prompt
function prompt_main() {
	RETVAL=$?
	CURRENT_BG='NONE'
	prompt_status
	prompt_dir
	prompt_git
	prompt_caret
	prompt_end
}

function prompt_precmd() {
  print
	vcs_info
	PROMPT="%{%f%b%k%}$(prompt_main)"
}

function prompt_setup() {
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
