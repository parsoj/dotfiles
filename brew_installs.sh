#base install of homebrew and homebrew-cask
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install cask

# spacemacs install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
brew tap d12frosted/emacs-plus
brew install emacs-plus
brew linkapps
#/spacemacs install

########################################################################################

# cli apps to install
export cli_apps_to_install="

git
python

"
for app in $cask_apps_to_install;
do
    brew install $app;
done
#/cli apps to install

########################################################################################

# cask apps to install
export cask_apps_to_install="

1password
evernote
google-chrome
hammerspoon
rescuetime
seil
slack

"
for app in $cask_apps_to_install;
do
    brew cask install $app;
done
#/cask apps to install

########################################################################################







