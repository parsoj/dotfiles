EMACS_CONF_ROOT=~/.config/emacs

rm -rf ~/.emacs.d ; ln -s $EMACS_CONF_ROOT/doom-core ~/.emacs.d
rm -rf ~/.doom.d; ln -s $EMACS_CONF_ROOT/doom-config ~/.doom.d

