###############################################################################
# fix some really dumb default behavior in OSX

# don't randomly redirect focus to other workspaces
defaults write com.apple.dock workspaces-auto-swoosh -bool NO

###############################################################################
# Symlink configs into place

rm ~/.skhdrc ; ln -s  ~/.config/osx/skhdrc ~/.skhdrc
rm ~/.chunkwmrc ; ln -s  ~/.config/osx/chunkwmrc ~/.chunkwmrc

###############################################################################
# Apply Brewfile
brew bundle
