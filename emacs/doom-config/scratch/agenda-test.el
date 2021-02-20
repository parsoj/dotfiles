;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(defun get-org-files-in-folder (folder)
  (directory-files-recursively folder (rx ".org" eos))
  )


(let

    (



     ;; (org-agenda-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org"))
     (org-agenda-custom-commands '(
                                   ("d" "Daily Planning"
                                    (
                                     ;; (agenda ""
                                     ;;         ((org-agenda-overriding-header "Weekly Overview")
                                     ;;          (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("ROUTINE")))
                                     ;;          (org-agenda-span 7)))
                                     ;;
                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (not (tags "routine" "spare_time"))
                                                     )
                                                   (
                                                    (org-ql-block-header "Next items for each project")
                                                    (org-agenda-files
                                                     (get-org-files-in-folder (expand-file-name "~/org/current_projects"))
                                                     )
                                                    (org-super-agenda-groups '((:auto-category t)))

                                                    ))
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

                                     ;; TODO filter files down to just projects
                                     )
                                    )

                                   )))


  (org-super-agenda-mode 1)
  ;; (org-agenda t "w")
  (org-agenda t "d")
  )
