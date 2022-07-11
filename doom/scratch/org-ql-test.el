;;; ../.config/emacs/doom-config/scratch/org-ql-test.el -*- lexical-binding: t; -*-


(let ((mah-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org")))


  (org-ql-search mah-files `(and

                             (or (scheduled :to today)
                                 (not (scheduled)))
                             (not (deadline :to today))
                             )
    :sort '(date)
    :columns '((deadline) )
    ;; :time-grid t
    ;; :super-groups '((:time-grid t))
    ))
