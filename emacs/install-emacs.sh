#!/bin/bash

brew tap d12frosted/emacs-plus

rm -rf /Applications/Emacs.app

brew uninstall emacs-plus@28
brew install emacs-plus@28  --with-debug --with-nobu417-big-sur-icon

ln -s /usr/local/opt/emacs-plus@28/Emacs.app /Applications
