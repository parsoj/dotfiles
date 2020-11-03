#!/usr/bin/env bash
set -euo pipefail

rm -rf ~/Library/LaunchAgents/com.emacs.app.plist ; ln -s $(pwd)/emacs-daemon.plist ~/Library/LaunchAgents/com.emacs.app.plist

launchctl load ~/Library/LaunchAgents/com.emacs.app.plist
