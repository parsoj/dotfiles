
sudo apt -y install python-dev
sudo apt -y install python-pip
pip install virualenv
pip install ipython

sudo apt -y install python3-dev
sudo apt -y install python3-pip
pip3 install ipython


# styles
rm -f ~/.config/flake8 ; ln -s ./style/flake8 ~/.config/flake8
rm -rf ~/.config/yapf ; ln -s ./style/yapf ~/.config/yapf

