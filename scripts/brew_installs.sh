#base install of homebrew and homebrew-cask
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask


#spacemacs install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
brew tap d12frosted/emacs-plus
brew install emacs-plus --with-cocoa --with-gnutls --with-librsvg --with-imagemagick --with-spacemacs-icon
tic -o ~/.terminfo /usr/local/Cellar/emacs-plus/24.5/share/emacs/24.5/etc/e/eterm-color.ti
brew linkapps

#other stuff
brew install antigen

brew cask install google-chrome

brew install the_silver_searcher
