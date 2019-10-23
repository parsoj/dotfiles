#!/bin/bash

rm -f ~/.yabairc ; ln -s $(pwd)/yabairc ~/.yabairc

sudo yabai --install-sa
