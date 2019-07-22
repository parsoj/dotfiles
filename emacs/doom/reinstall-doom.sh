#!/bin/bash

pkill Emacs
cd ~/
rm -rf .emacs.d
git clone -b develop https://github.com/hlissner/doom-emacs ~/.emacs.d
cd ~/.emacs.d
sed 's/setq load-prefer-newer noninteractive/setq load-prefer-newer nil/g' init.el > init_new.el
cp init_new.el init.el
bin/doom -y quickstart
