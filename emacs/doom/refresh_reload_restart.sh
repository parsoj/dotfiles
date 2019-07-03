#!/bin/bash

pkill Emacs

set -e

cd ~/.emacs.d/

./bin/doom clean

git reset --hard HEAD

git pull

./bin/doom refresh

cd ~/

$DOTFILES_DIR/osx/scripts/launch_emacsclient
