# bootstrap script to install spacemacs and dependencies

# support tools
brew install --no-sandbox global --with-pygments --with-ctags
brew install ag
brew install bash

# core spacemacs install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
brew tap railwaycat/emacsmacport
brew install emacs-mac
brew linkapps
