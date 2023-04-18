#!/bin/bash

rm -f ~/.yabairc ; ln -s $(pwd)/yabairc ~/.yabairc

sudo rm -f /usr/local/bin/push_space; ln -s $(pwd)/scripts/push_space ~/.local/bin/push_space
sudo rm -f /usr/local/bin/pop_space; ln -s $(pwd)/scripts/pop_space ~/.local/bin/pop_space