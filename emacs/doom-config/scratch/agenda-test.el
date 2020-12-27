;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


(setq org-active-states '("ROUTINE" "NEXT" "AVAILABLE" ))

;; (setq org-active-states '("ROUTINE" "AVAILABLE" ))


;; (org-ql-search
;;   org-agenda-files
;;    '(and

;;      (deadline :to today)
;;      (todo "ROUTINE" "NEXT" "AVAILABLE")
;;      )
;;   )

(setq org-agenda-custom-commands '(
                                   ("x" "custom agenda"
                                    (
                                     (tags "+TODO=\"INBOX\""
                                           ((org-agenda-overriding-header "Inbox Items")))
                                     ;; (tags "SCHEDULED<=\"<today>\"&+active"
                                     ;;       ((org-agenda-overriding-header "Due Today")
                                     ;;        ))
                                     (org-ql-block '(deadline :to today)
                                                   ((org-ql-block-header "Due Today")))
                                     (org-ql-block `(and (tags "active")
                                                         (or (scheduled :to today)
                                                             (not (scheduled)))
                                                         ,(append '(todo) org-active-states))
                                                   ((org-ql-block-header "Available Today")))
                                     (tags "TODO=\"PROJECT\"&+active"
                                           ((org-agenda-overriding-header "Active Projects")
                                            (org-super-agenda-groups '((:auto-category t)))
                                            ))
                                     ))))


(org-agenda t "x")
