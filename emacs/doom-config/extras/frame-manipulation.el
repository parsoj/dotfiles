;;; ../.config/emacs/doom-config/extras/frame-manipulation.el -*- lexical-binding: t; -*-

(defun +focus-this-frame ()
    (select-frame-set-input-focus (selected-frame)))
