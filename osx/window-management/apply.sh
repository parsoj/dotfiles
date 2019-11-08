#!/bin/bash

rm -f ~/.yabairc ; ln -s $(pwd)/yabairc ~/.yabairc
brew bundle
sudo yabai --install-sa
brew services start yabai
