# Add to PATH
function add_path {
	if [[ -d $1 ]] && [[ ! $PATH =~ $1 ]]; then
		export PATH=$PATH:$1
	fi
}

# Evaluate shell if if it's in PATH
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
    echo "Error: plugin called without 'ZPLUGINDIR' variable set"
    exit 1
  fi

  if [[ ! -d $ZPLUGINDIR/$repo ]]; then
    if [[ ! -d $ZPLUGINDIR ]]; then
      mkdir -vp $ZPLUGINDIR
    fi
    git clone https://github.com/$owner/$repo $ZPLUGINDIR/$repo
  fi

  local entry_file=$ZPLUGINDIR/$repo/$repo.plugin.zsh
  if [[ ! -f $entry_file ]]; then
    echo Warning plugin $repo is missing an entry file
  fi

  source $entry_file
}
