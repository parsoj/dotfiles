#!/bin/bash

rm -f ~/.skhdrc; ln -s $(pwd)/skhdrc ~/.skhdrc
brew bundle
brew services start skhd
