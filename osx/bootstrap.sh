#!/bin/bash

./apply_configs.sh

################################################################################
# Homebrew Setup 
BREW_BIN_PATH=/usr/local/bin/brew
if [ ! -f "$BREW_BIN_PATH" ]; then
    echo "Homebrew not found on system. Installing Hombrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


brew tap homebrew/services

brew bundle

################################################################################
# Window Management
sudo yabai --install-sa
brew services restart yabai

################################################################################
# Keybindings
brew services restart skhd
