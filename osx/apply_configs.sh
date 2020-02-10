#!/bin/bash

rm -f ~/.yabairc ; ln -s $(pwd)/app_settings/yabai/yabairc ~/.yabairc
rm -f ~/.skhdrc; ln -s $(pwd)/app_settings/skhd/skhdrc ~/.skhdrc
