#!/bin/bash

pkill Emacs

set -e

cd ~/.emacs.d/

./bin/doom clean

git reset --hard HEAD

git pull

./bin/doom refresh

cd ~/

~/.config/osx/scripts/launch_emacsclient
