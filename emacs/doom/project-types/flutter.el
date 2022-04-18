;;; ../.config/emacs/doom/project-types/flutter.el -*- lexical-binding: t; -*-



;;; trigger the hot-reloading in the flutter vterm
(with-current-buffer "*vterm*"
  (let ((inhibit-read-only t))
    (vterm-send-string "r")))
