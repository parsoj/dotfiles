;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(setq org-active-states '("NEXT" "AVAILABLE" "ROUTINE"))

(progn

(setq org-agenda-custom-commands '(
                                   ("x" "custom agenda"
                                    (
                                      (tags "+TODO=\"INBOX\""
                                            ((org-agenda-overriding-header "Inbox Items")))
                                      (org-ql-block `(and (tags "active")
                                                          (or (scheduled :to today)
                                                              (not (scheduled)))
                                                          ,(append '(todo) org-active-states))
                                                    ((org-ql-block-header "Due Today")))
                                     (tags "SCHEDULED<=\"<today>\"&+active"
                                           ((org-agenda-overriding-header "Available Today")
                                            ))
                                     (tags "TODO=\"PROJECT\"&+active"
                                           ((org-agenda-overriding-header "Active Projects")
                                            (org-super-agenda-groups '((:auto-category t)))
                                            ))
                                     ))))

(org-agenda t "x")
)
