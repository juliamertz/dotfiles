# Add to PATH
function add_path {
	if [[ -d $1 ]] && [[ ! $PATH =~ $1 ]]; then
		export PATH=$PATH:$1
	fi
}

# Evaluate shell hook if it's in PATH
function try_hook {
  if [[ -f $(which $1) ]]; then 
    eval "$($@)" 
  fi
}

# Checks if ZPLUGINDIR is set
# It will check if the plugin directory is missing and then clone it
# Then it sources the plugins entrypoint
function plugin {
  local owner=$1
  local repo=$2

  if [[ ! -v ZPLUGINDIR ]]; then
    echo "Error `plugin` function called without 'ZPLUGINDIR' variable set"
    exit 1
  fi

  local entry_file=$ZPLUGINDIR/$repo/$repo.plugin.zsh

  if [[ $ZPLUGINDIR == /nix/store/* ]]; then
    source $entry_file
    return 
  fi

  if [[ ! -d $ZPLUGINDIR/$repo ]]; then
    if [[ ! -d $ZPLUGINDIR ]]; then
      mkdir -vp $ZPLUGINDIR
    fi
    git clone https://github.com/$owner/$repo $ZPLUGINDIR/$repo
  fi

  if [[ ! -f $entry_file ]]; then
    echo Warning plugin $repo is missing an entry file
  fi

  source $entry_file
}

function ansi_color_escape() {
	print -n "\x1b[${1}m"
}

function ansi_color_code() {
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

function clr() {
  ansi_color_escape $(ansi_color_code $1)
}

