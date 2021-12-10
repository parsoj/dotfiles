#!/bin/sh

set -e

brew tap railwaycat/emacsmacport
brew uninstall emacs-mac
brew install emacs-mac --with-modules --with-no-title-bars
ln -s /usr/local/opt/emacs-mac/Emacs.app /Applications/Emacs.app

./link-configs.sh
./install-fonts.sh

rm -rf ~/.emacs.d
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
