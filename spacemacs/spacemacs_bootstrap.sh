# bootstrap script to install spacemacs and dependencies

# support tools
brew install --no-sandbox global --with-pygments --with-ctags
brew install ag
brew install bash

# core spacemacs install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
brew install emacs-plus
brew linkapps

# running emacs server on startup
## add launchd plist to the launch agents dir and enable it
sudo cp spacemacs_launchd.plist /Library/LaunchAgents/
sudo launchctl load -w /Library/LaunchAgents/spacemacs_launchd.plist

