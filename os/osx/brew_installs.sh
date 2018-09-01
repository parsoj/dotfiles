#base install of homebrew and homebrew-cask
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install cask

################################################################################
# spacemacs

# support tools
brew install --no-sandbox global --with-pygments --with-ctags
brew install ag
brew install bash

# core spacemacs install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
brew install emacs-plus
brew linkapps

# copy spacemacs daemon app to /Applications to be run as a login item
cp -r Spacemacs_Daemon.app /Applications/

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
brew cask install magicprefs
brew cask install totalspaces
brew cask install bartender

################################################################################
# cask -- machine utils
brew cask install flux
brew cask install little-snitch
open /usr/local/Caskroom/little-snitch/4.0.4/LittleSnitch-4.0.4.dmg
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
# Xcode tools
xcode-select --install

################################################################################
# manual tasks

## update built-in trackpad gestures
### disable two-finger swipe for "back"

## disable normal system keyboard shortcuts to allow hammerspoon to take over

## set alfred to pull from dropbox



