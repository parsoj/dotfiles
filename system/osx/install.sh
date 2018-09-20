# chunkwm install
ln -s ~/.dotfiles/system/osx/chunkwmrc ~/.chunkwmrc
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
brew services start chunkwm

#skhd
ln -s ~/.dotfiles/system/osx/skhdrc ~/.skhdrc
brew install koekeishiya/formulae/skhd
brew services start skhd




