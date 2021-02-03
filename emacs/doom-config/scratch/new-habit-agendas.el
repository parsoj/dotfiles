;;; ../.config/emacs/doom-config/scratch/new-habit-agendas.el -*- lexical-binding: t; -*-


(let
    (
     (org-agenda-custom-commands '(
                                   ("m" "Daily Planning"
                                    (
                                     (tags "+TODO=\"INBOX\""
                                           ((org-agenda-overriding-header "Inbox Items")))
                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (deadline :to today)
                                                     )
                                                   ((org-ql-block-header "Due Today")
                                                    (org-super-agenda-groups '((:auto-property "PROJECT")))))
                                     (org-ql-block
                                      `(and
                                        (todo "PROJECT")
                                        (tags "active")
                                        )
                                      ((org-ql-block-header "Active Projects")
                                       ;; (org-agenda-super-groups '((:auto-category t)))
                                       (org-super-agenda-groups '((:auto-category t))))
                                      )
                                     (org-ql-block `(and
                                                     (todo "PROJECT")
                                                     (tags "active")
                                                     (not (descendants ,(append '(todo) org-active-states)))
                                                     )
                                                   ((org-ql-block-header "Stuck Projects")
                                                    (org-super-agenda-groups '((:auto-category t)))
                                                    ))
                                     )))))


  (org-super-agenda-mode 1)
  (org-agenda t "x")
  )

(setq org-use-property-inheritance '("PROJECT"))

(setq org-log-into-drawer nil)
