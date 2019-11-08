#/usr/bin/bash

mkdir -p ~/.config/emacs
rm -rf ~/.config/emacs/init.el ; ln -s $(pwd)/init.el ~/.config/emacs/init.el
