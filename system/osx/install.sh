# base emacs install
brew tap d12frosted/emacs-plus
brew install emacs-plus --with-no-titlebar
brew services start emacs-plus

# chunkwm install
ln -s ~/.dotfiles/system/osx/chunkwmrc ~/.chunkwmrc
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
brew services start chunkwm

# bitbar plugin for chunkwm
ln -s ~/.dotfiles/system/osx/chunkwm_skhd.1s.sh ~/.bitbar/plugins/
brew cask install bitbar

#skhd
ln -s ~/.dotfiles/system/osx/skhdrc ~/.skhdrc
brew install koekeishiya/formulae/skhd
brew services start skhd

################################################################################
# Apps install
brew cask install google-chrome

# Fonts
# input font (used by spacemacs)
brew cask install font-input

# communication
brew cask install slack

# entertainment
brew cask install spotify

# dev tools
brew cask install postman
brew cask install docker

# productivity
brew cask install dropbox
brew cask install evernote
brew cask install rescuetime
brew cask install fantastical

# system fix tools
brew cask install 1password
brew cask install bartender
brew cask install alfred
brew cask install bitbar
brew cask install istat-menus







