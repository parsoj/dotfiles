# Spacemacs
rm ~/.spacemacs ; ln -s ~/.dotfiles/spacemacs/spacemacs_config ~/.spacemacs

# Git
rm ~/.gitconfig ; ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
rm ~/.gitignore_global ; ln -s ~/.dotfiles/git/gitignore_global ~/.gitignore_global

# Hammerspoon
rm -rf ~/.hammerspoon ; ln -s ~/.dotfiles/hammerspoon ~/.hammerspoon

# Bash
rm -rf ~/.bash_profile ; ln -s ~/.dotfiles/bash/bash_profile ~/.bash_profile

# ssh
rm ~/.ssh/config ; ln -s ~/.dotfiles/ssh/config ~/.ssh/config

# python styles
rm -f ~/.config/flake8 ; ln -s ~/.dotfiles/code-styles/python/flake8 ~/.config/flake8
rm -rf ~/.config/yapf ; ln -s ~/.dotfiles/code-styles/python/yapf ~/.config/yapf
