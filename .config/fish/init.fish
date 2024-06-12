#!/usr/bin/env fish

if test -f ~/.config/fish/functions/fisher.fish
  # echo "Installing fisher..."
  # set fisher_repo "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish"
  # curl -sL $fisher_repo | source && fisher install jorgebucaran/fisher
end

for file in scripts/*.fish
    source $file
end
