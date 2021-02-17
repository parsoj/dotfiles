;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(let

    (

     ;; (org-agenda-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org"))
     (org-agenda-custom-commands '(
                                   ("d" "Daily Planning"
                                    (
                                     (agenda ""
                                             ((org-agenda-overriding-header "Weekly Overview")
                                              (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("ROUTINE")))
                                              (org-agenda-span 7)))
                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (deadline :to today)
                                                     (not (tags "routine"))
                                                     )
                                                   ((org-ql-block-header "Due Today")))
                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (scheduled :to today)
                                                     )
                                                   ((org-ql-block-header "Scheduled Today")))

                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (deadline :to +3)
                                                     (not (tags "routine"))
                                                     )
                                                   ((org-ql-block-header "Due in next 3 days")))
                                     (tags "FOO"
                                           ((org-agenda-overriding-header "Next items for each project"))) ;TODO
                                     (tags "FOO"
                                           ((org-agenda-overriding-header "Project Activity"))) ;;TODO
                                     )
                                    )

                                   )))


  (org-super-agenda-mode 1)
  ;; (org-agenda t "w")
  (org-agenda t "d")
  )
