;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(setq org-active-states '("NEXT" "AVAILABLE"))

;;  "Available today" section
(org-ql-search org-agenda-files `(and (tags "active")
                                      (or (scheduled :to today)
                                          (not (scheduled)))
                                      ,(append '(todo) org-active-states)))
