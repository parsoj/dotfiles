#base install of homebrew and homebrew-cask
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install cask

################################################################################
# spacemacs
../spacemacs/spacemacs_bootstrap.sh

################################################################################
# brew - tools
brew install git
brew install python
brew install gnupg2
brew install bash
brew install coreutils

# generate a new ssh key
ssh-keygen -t rsa -b 4096 -N '' -C $EMAIL

# default curl on OSX is insecure - smush it
brew install curl --with-openssl
brew link --force curl


################################################################################
# cask -- fixing mac-ness
brew cask install Alfred
brew cask install hammerspoon
brew cask install karabiner
brew cask install magicprefs
brew cask install totalspaces

################################################################################
# cask -- machine utils
brew cask install flux
brew cask insall little-snitch
brew cask install istat-menus

################################################################################
# cask -- core apps
brew cask install google-chrome
brew cask install Dashlane
brew cask install dropbox
brew cask install slack

## productivity
brew cask install rescuetime
brew cask install omnifocus
brew cask install fantastical

################################################################################
# manual tasks

## update built-in trackpad gestures
### disable two-finger swipe for "back"

## disable normal system keyboard shortcuts to allow hammerspoon to take over

## set alfred to pull from dropbox



