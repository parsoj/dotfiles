#base install of homebrew and homebrew-cask
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install cask

################################################################################
# spacemacs

# support tools
brew install --no-sandbox global --with-pygments --with-ctags


# core spacemacs install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
brew tap d12frosted/emacs-plus
brew install emacs-plus
brew linkapps

################################################################################
# cli apps to install
brew install git
brew install python

################################################################################
# cask -- fixing mac-ness
brew cask install bartender
brew cask install alfred2
brew cask install totalspaces #requires SIP to be disabled
brew cask install seil
brew cask insgtall karabiner

################################################################################
# cask -- utilities
brew cask install 1password
brew cask install evernote
brew cask install hammerspoon
brew cask install rescuetime


################################################################################
# cask -- core apps
brew cask install google-chrome
brew cask install slack


################################################################################
# manual tasks

# disable SIP to make totalspaces and other apps happy
# disable keyboard and trackpad shortcuts




