
sudo pacaur -Sy python-dev
sudo pacaur -Sy python-pip
pip install virualenv
pip install ipython

sudo pacaur -Sy python3-dev
sudo pacaur -Sy python3-pip
pip3 install ipython


# auto formatting and style checking
rm -f ~/.config/flake8 ; ln -s ~/.dotfiles/spacemacs/language_support/python/flake8  ~/.config/flake8
pip install flake8

rm -rf ~/.config/yapf ; ln -s ~/.dotfiles/spacemacs/language_support/python/yapf ~/.config/yapf
pip install yapf

