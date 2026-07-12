#!/bin/bash
# Effectively disable the Dock: auto-hide with a delay so long it never appears.
# (The Dock process can't be killed outright — it also runs Mission Control,
# cmd+tab, and window minimizing.)
#
# To undo:
#   defaults delete com.apple.dock autohide-delay
#   defaults delete com.apple.dock autohide-time-modifier
#   killall Dock

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock
