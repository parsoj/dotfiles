;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(let

    (

     ;; (org-agenda-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org"))
     (org-agenda-custom-commands '(
                                   ("m" "Morning Planning"
                                    (
                                     (tags "+TODO=\"INBOX\""
                                           ((org-agenda-overriding-header "Inbox Items")))
                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (deadline :to today)
                                                     )
                                                   ((org-ql-block-header "Due Today")))
                                     (agenda ""
                                             ((org-agenda-start-day "1d")
                                              (org-agenda-span 1))

                                             )
                                     (org-ql-block
                                      `(and
                                        (todo "PROJECT")
                                        (tags "active")
                                        )
                                      ((org-ql-block-header "Active Projects")
                                       ;; (org-agenda-super-groups '((:auto-category t)))
                                       (org-super-agenda-groups '((:auto-category t))))
                                      )

                                     )
                                    )
                                   ("w" "Weekly Planning"
                                    (
                                     (tags "+TODO=\"INBOX\""
                                           ((org-agenda-overriding-header "Inbox Items")))

                                     (agenda ""
                                             ((org-agenda-start-day "1d")
                                              (org-agenda-span 7))) ;;TODO filter out routine items from this view
                                     )

                                    )
                                   )))


  (org-super-agenda-mode 1)
  ;; (org-agenda t "w")
  (org-agenda t "m")
  )
