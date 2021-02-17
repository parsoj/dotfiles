;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(let

    (

     ;; (org-agenda-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org"))
     (org-agenda-custom-commands '(
                                   ("d" "Daily Planning"
                                    (
                                     (
                                      ;; tags-todo "+TODO=\"TODO\""
                                      agenda ""
                                      ((org-agenda-overriding-header "Weekly Overview")
                                       (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("ROUTINE")))
                                       (org-agenda-span 5))) ;TODO
                                     (tags "FOO"
                                           ((org-agenda-overriding-header "Due Today"))) ;TODO
                                     (tags "FOO"
                                           ((org-agenda-overriding-header "Scheduled Today"))) ;TODO
                                     (tags "FOO"
                                           ((org-agenda-overriding-header "Due in new 3 days"))) ;TODO
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
