

################################################################################
# Homebrew Setup 
BREW_BIN_PATH=/usr/local/bin/brew
if [ ! -f "$BREW_BIN_PATH" ]; then
    echo "Homebrew not found on system. Installing Hombrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle


################################################################################
# Window Management
rm -f ~/.yabairc ; ln -s $(pwd)/app_settings/yabai/yabairc ~/.yabairc
sudo yabai --install-sa
brew services restart yabai

################################################################################
# Keybindings
rm -f ~/.skhdrc; ln -s $(pwd)/app_settings/skhd/skhdrc ~/.skhdrc
brew services restart skhd
