;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(let

    (

     ;; (org-agenda-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org"))
     (org-agenda-custom-commands '(
                                   ("z" "custom agenda"
                                    (
                                     (org-ql-block
                                      `(and
                                        (todo "PROJECT")
                                        (tags "active")
                                        )
                                      ((org-ql-block-header "Active Projects")
                                       ;; (org-agenda-super-groups '((:auto-category t)))
                                       (org-super-agenda-groups '((:auto-category t))))
                                      )

                                     )))))


  (org-super-agenda-mode 1)
  (org-agenda t "z")
  )
