#/usr/bin/bash

mkdir -p ~/.config/emacs
rm -rf ~/.config/emacs ; ln -s $(pwd) ~/.config/emacs
