;;; ../.config/emacs/doom-config/extras/org/note.el -*- lexical-binding: t; -*-



(defun org-quick-note ()
  (find-file (concat (read-file-name "Choose name for note file: " "~/org/inbox/" "notes.org") ".org")))
