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
brew tap railwaycat/emacsmacport
brew install emacs-mac
brew linkapps

################################################################################
# brew - tools
brew install git
brew install python
brew install gnupg2
brew install bash

# generate a new ssh key
ssh-keygen -t rsa -b 4096 -N '' -C $EMAIL

# default curl on OSX is insecure - smush it
brew install curl --with-openssl
brew link --force curl


################################################################################
# cask -- fixing mac-ness
brew cask install Alfred

################################################################################
# cask -- utilities
brew cask install Dashlane
brew cask install evernote
brew cask install hammerspoon
brew cask install rescuetime
brew cask install dropbox
brew cask install flux


################################################################################
# cask -- core apps
brew cask install google-chrome


################################################################################
# manual tasks

# update built-in trackpad gestures
# disable normal system keyboard shortcuts to allow hammerspoon to take over




