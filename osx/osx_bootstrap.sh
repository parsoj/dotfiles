
###############################################################################
# fix some really dumb default behavior in OSX

# don't randomly redirect focus to other workspaces
defaults write com.apple.dock workspaces-auto-swoosh -bool NO


################################################################################
# Symlink configs into place

rm ~/.skhdrc ; ln -s  ~/.dotfiles/osx/skhdrc ~/.skhdrc
rm ~/.chunkwmrc ; ln -s  ~/.dotfiles/osx/chunkwmrc ~/.chunkwmrc
rm ~/.zazurc.json ; ln -s  ~/.dotfiles/osx/zazurc.json ~/.zazurc.json

rm -rf ~/.bashrc; ln -s ~/.dotfiles/shell/bashrc ~/.bashrc
rm -rf ~/.bash_profile; ln -s ~/.dotfiles/shell/bash_profile ~/.bash_profile

################################################################################
# Install Spacemacs
rm ~/.spacemacs ; ln -s  ~/.dotfiles/spacemacs/spacemacs_config.el ~/.spacemacs

brew tap caskroom/fonts
brew cask install font-source-code-pro

