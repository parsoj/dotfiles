#base install of homebrew and homebrew-cask
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install cask

################################################################################
# spacemacs

# support tools
brew install --no-sandbox global --with-pygments --with-ctags
brew install ag

# core spacemacs install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
brew tap d12frosted/emacs-plus
brew install emacs-plus
brew linkapps

################################################################################
# brew - tools
brew install git
brew install python
brew install gnupg2

#default curl on OSX is insecure - smush it
brew install curl --with-openssl
brew link --force curl


################################################################################
# cask -- fixing mac-ness
brew cask install alfred2 #TODO save profile/config
brew cask install seil

################################################################################
# cask -- utilities
brew cask install dashane
brew cask install evernote
brew cask install hammerspoon
brew cask install rescuetime


################################################################################
# cask -- core apps
brew cask install google-chrome
brew cask install slack


################################################################################
# manual tasks

# update built-in trackpad gestures
# disable normal system keyboard shortcuts to allow hammerspoon to take over




