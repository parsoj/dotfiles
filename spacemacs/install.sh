
#############################################################
# Spacemacs installation

# base install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
pacman -S emacs

# link in spacemacs config
rm ~/.spacemacs ; ln -s ~/.dotfiles/spacemacs/spacemacs_config.el ~/.spacemacs

# source code pro font for spacemacs
mkdir -p ~/.fonts
cp ~/.dotfiles/spacemacs/fonts/source-code-pro/*.ttf ~/.fonts

# all-the-icons setup for neotree
cp ~/.dotfiles/spacemacs/fonts/all-the-icons/*.ttf ~/.fonts

##############################################################
# base emacs install

# add kevin kelley's emacs ppa
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs26

################################################################################
# set up systemd to launch emacs daemon on startup

mkdir -p ~/.config/systemd/user
rm ~/.config/systemd/user/emacs.service ; ln -s /home/jeff/.dotfiles/spacemacs/systemd/emacs.service ~/.config/systemd/user/emacs.service

systemctl enable --user emacs
systemctl start --user emacs

################################################################################

# spacemacs support utilities
pacaur -S the_silver_searcher
pacaur -S markdown
pacaur -S global
################################################################################
 # random utils

# pops up a notification when long-running scripts complete (accompanied with .bashrc setting)
pacaur -S undistract-me-git
