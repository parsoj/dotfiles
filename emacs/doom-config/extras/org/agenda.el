;;; ../.config/emacs/doom-config/extras/org/agenda.el -*- lexical-binding: t; -*-


(setq agenda-folders '("inbox" "current_projects"))


(defun org-get-agenda-folders ()
  (-map (lambda (x) (expand-file-name (concat org-directory "/" x "/"))) agenda-folders)
  )


(defun org-get-agenda-files ()
  (apply '-concat  (-map
                    (lambda (folder)
                      (directory-files-recursively folder (rx ".org" eos))
                      )
                    (org-get-agenda-folders)

                    )))



(defun org-refresh-agenda-files ()
  (interactive)
  (setq org-agenda-files (org-get-agenda-files)))

(org-refresh-agenda-files)


;; (defun org-set-agenda-files ()
;;   (interactive)
;;   (setq org-agenda-files (org-get-agenda-files))
;;   )
;;


(use-package! org-super-agenda)
(use-package! org-ql)

;; (org-super-agenda-mode 1)

;;;  todo keywords must be set after org-ql and org-super agenda have been loaded
(setq org-todo-keywords '((type "INBOX(i)" "TODO(t)" "PROJECT(p)" "ROUTINE(r)" "|")
                          (sequence  "AVAILABLE(a)" "BLOCKED(b)" "NEXT(n)"  "|" "DONE(d)" "CANCELLED(c)")))

(setq org-todo-keyword-faces '(("PROJECT" . "purple")
                               ("ROUTINE" . "pink")))

(setq org-active-states '("NEXT" "AVAILABLE" "ROUTINE" "TODO"))


(setq org-agenda-custom-commands '(
                                   ("x" "custom agenda"
                                    (
                                     (tags "+TODO=\"INBOX\""
                                           ((org-agenda-overriding-header "Inbox Items")))
                                     ;; (tags "SCHEDULED<=\"<today>\"&+active"
                                     ;;       ((org-agenda-overriding-header "Due Today")
                                     ;;        ))
                                     (org-ql-block `(and
;;; there appears to be a bug where ordering
;;; matters for the "and" predicate. be wary here
                                                     ,(append '(todo) org-active-states)
                                                     (deadline :to today)
                                                     )
                                                   ((org-ql-block-header "Due Today")))
                                     ;; (org-ql-block `(and (tags "active")
                                     ;;                     (or (scheduled :to today)
                                     ;;                         (not (scheduled)))
                                     ;;                     (not (deadline :to today))
                                     ;;                     ,(append '(todo) org-active-states))
                                     ;;               ((org-ql-block-header "Available Today")))
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
                                                   ((org-ql-block-header "Stuck Projects")))
                                     ))
                                   ("m" "Morning Planning"

                                    )
                                   ("e" "Evening shutdown"

                                    )
                                   ("w" "Weekly Planning"

                                    )


                                   ))

(org-super-agenda-mode 1)



(map! :leader
      (:prefix-map ("o". "open")
       :desc "Agenda" "x" (lambda! () (org-agenda t "x" ))
       ))


;;;  auto-save org-mode buffers from agenda
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))
