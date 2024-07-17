#!/usr/bin/env bash

# Lazygit puts it's configuration in a weird place on macos.
# Linking it to ~/.config makes more sense.
LAZYGIT_PATH="$HOME/Library/Application Support/lazygit"

rm -rf $LAZYGIT_PATH
ln -s $HOME/.config/lazygit $LAZYGIT_PATH
