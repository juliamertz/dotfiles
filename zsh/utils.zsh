#!/usr/bin/env zsh

isShellCats=$([ -z "${shellCats}" ] && echo "false" || echo "true")

function setupShellCats() {
  if $isShellCats; then
		export PATH="$SHELLCATS_EXTRAPATH:$PATH"
  fi
}

# get value of category definition
function getCat() {
  local cat=$1
  echo "${shellCats[$cat]}"
}

function enableForCat() {
  # check if this category is enabled or has a thruthy value
  local cat="$1"
  # fallback value for when the configuration isn't built with nix
  local default="${2:-true}"

  if ! $isShellCats; then
    return $default
  fi

  local value=$(getCat $cat)
  if [[ "$value" == "true" ]]; then
    return 0;
  elif [[ "$value" == "false" ]]; then 
    return 1
  else
    if [ -n "$value" ]; then
      return 0
    else
      return 1
    fi
  fi
}

# Append to PATH
function append_path {
	if [[ ! $PATH =~ $1 ]]; then
		export PATH="$PATH:$1"
	fi
}

# Prepend to PATH
function prepend_path {
	if [[ ! $PATH =~ $1 ]]; then
		export PATH="$1:$PATH"
	fi
}

# Evaluate shell hook if it's in PATH
function try_hook {
	if command -v "$1" >/dev/null; then
		eval "$($@)"
	fi
}

function ansiColorEscape() {
	print -n "\x1b[${1}m"
}

function ansiColorCode() {
	case "$1" in
	"black") echo 30 ;;
	"brblack") echo 90 ;;
	"red") echo 31 ;;
	"green") echo 32 ;;
	"yellow") echo 33 ;;
	"blue") echo 34 ;;
	"magenta") echo 35 ;;
	"cyan") echo 36 ;;
	"white") echo 37 ;;
	"default") echo 39 ;;
	"reset") echo 0 ;;
	*) ;;
	esac
}

function clr() {
	ansiColorEscape $(ansiColorCode $1)
}

function plugin() {
	owner=$(echo $1 | cut -d'/' -f1)
	repo=$(echo $1 | cut -d'/' -f2)

  if $isShellCats; then
		source $SHELLCATS_PLUGINS/$repo/$repo.plugin.zsh
		return
  else
    local plugins_dir=$HOME/.cache/shellcats/plugins

    # Clone repo if it doesn't exist yet
    if [[ ! -d "$plugins_dir/$repo" ]]; then
      if [[ ! -d "$plugins_dir" ]]; then
        mkdir -vp "$plugins_dir"
      fi
      echo "$(clr blue)📥 Fetching plugin $repo$(clr reset)"
      git clone "https://github.com/$owner/$repo"  "$plugins_dir/$repo"
    fi

    local entry_file="$plugins_dir/$repo/$repo.plugin.zsh" 
    # Attempt to source entry point
    if [[ ! -f $entry_file ]]; then
      echo "$(clr yellow)⚠️ Warning plugin $repo is missing an entry file$(clr reset)"
    else
      source "$entry_file"
    fi
    echo
  fi
}
