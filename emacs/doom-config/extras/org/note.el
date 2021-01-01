;;; ../.config/emacs/doom-config/extras/org/note.el -*- lexical-binding: t; -*-



(defun org-quick-note (fn)
  (interactive "sChoose name for note file: ")
  (find-file (concat "~/org/inbox/" fn ".org"))
  )
