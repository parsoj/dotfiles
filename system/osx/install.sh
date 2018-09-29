

# supporting tools
brew install the_platinum_searcher
brew install global --with-pygments --with-ctags
brew install npm
npm install -g tern
brew install imagemagick

# base emacs install
brew tap d12frosted/emacs-plus
brew install emacs-plus --with-no-titlebar
brew services start emacs-plus

################################################################################
# ChunkWM Stuff

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
brew install cask
brew cask install google-chrome

# Fonts
# input font (used by spacemacs)
brew install homebrew/cask-fonts/font-input

# communication
brew cask install slack
brew cask install pulse-sms

# entertainment
brew cask install spotify

# dev tools
brew cask install postman
brew cask install docker
brew cask install vagrant
brew cask install virtualbox
brew install awscli
brew install yarn
brew install php@7.1

# personal dev tools
brew cask install dash
brew install ripgrep

# productivity
brew cask install dropbox
brew cask install evernote
brew cask install rescuetime
brew cask install fantastical

# Utils
brew cask install nordvpn

# system fix tools
brew cask install 1password
brew cask install bartender
brew cask install alfred
brew cask install istat-menus
brew install coreutils
