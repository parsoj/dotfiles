#!/usr/bin/env bash


install_emacs_mac() {
    echo "\ninstalling emacs-mac..."
    if brew list emacs-mac &>/dev/null; then
        echo "emacs-mac is already installed"
    else
        brew tap railwaycat/emacsmacport
        brew install emacs-mac --with-native-comp --with-xwidgets --with-natural-title-bar --with-emacs-big-sur-icon \
            && echo "emacs-mac is installed"
    fi
}

install_emacs_mac


clone_doom() {
    echo "\ncloning doom emacs..."
    if [ -d "~/.emacs.d" ]
    then
        echo "doom emacs is already cloned."
    else
        git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    fi

}

clone_doom


echo "running doom-clean"
doom clean
echo "done."

echo "syncing doom config"
doom sync
echo "done."

echo "generating doom env"
doom env
echo "done."

echo "installing all-the-icons"
emacs --batch -f all-the-icons-install-fonts
