#!/usr/bin/env bash

###############################################################################
# fix some really dumb default behavior in OSX

# don't randomly redirect focus to other workspaces
defaults write com.apple.dock workspaces-auto-swoosh -bool NO

###############################################################################
# Symlink configs into place

rm ~/.skhdrc ; ln -s  ~/dotfiles/osx/skhdrc ~/.skhdrc
rm ~/.yabairc ; ln -s  ~/dotfiles/osx/yabairc ~/.yabairc

###############################################################################
# Apply Brewfile
brew update
#brew bundle --verbose
