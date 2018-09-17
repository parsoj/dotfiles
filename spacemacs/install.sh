#############################################################
# Spacemacs

# base install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# link in spacemacs config
rm ~/.spacemacs ; ln -s ~/.dotfiles/spacemacs/spacemacs_config.el ~/.spacemacs


################################################################################
# Fonts and Icons

# source code pro font for spacemacs
mkdir -p ~/.fonts
cp ~/.dotfiles/spacemacs/fonts/source-code-pro/*.ttf ~/.fonts

# all-the-icons setup for neotree
cp ~/.dotfiles/spacemacs/fonts/all-the-icons/*.ttf ~/.fonts

##############################################################
# Emacs

yay -S emacs26-git

################################################################################
# run Emacs as a deamon on startup

mkdir -p ~/.config/systemd/user
rm ~/.config/systemd/user/emacs.service ; ln -s /home/jeff/.dotfiles/spacemacs/systemd/emacs.service ~/.config/systemd/user/emacs.service

systemctl enable --user emacs
systemctl start --user emacs

################################################################################
# Spacemacs support utilities
yay -S the_silver_searcher
yay -S markdown
yay -S global
