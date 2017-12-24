# bootstrap script to install spacemacs and dependencies

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
