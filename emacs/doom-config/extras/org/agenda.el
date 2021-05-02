;;; ../.config/emacs/doom-config/extras/org/agenda.el -*- lexical-binding: t; -*-


(setq agenda-folders '("active"))


(defun org-get-agenda-folders ()
  (-map (lambda (x) (expand-file-name (concat org-directory "/" x "/"))) agenda-folders)
  )


(defun get-org-files-in-folder (folder)
  (directory-files-recursively folder (rx ".org" eos))
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
(setq org-todo-keywords '((type "INBOX(i)" "TODO(t)" "PROJECT(p)" "NOTE" "|")
                          (sequence  "AVAILABLE(a)" "BLOCKED(b)" "NEXT(n)"  "|" "DONE(d!)" "CANCELLED(c)")))

(setq org-todo-keyword-faces '(("PROJECT" . "purple")
                               ("ROUTINE" . "pink")))

(setq org-active-states '("NEXT" "AVAILABLE" "ROUTINE" "TODO"))


(defun jeff/ts-beg-of-week (ts)
  (->> ts
       (ts-adjust 'day (- (ts-dow (ts-now))))
       (ts-apply :hour 0 :minute 0 :second 0))
  )


(defun jeff/ts-end-of-week (ts)
  (->> ts
       (ts-adjust 'day (- 6 (ts-dow (ts-now))))
       (ts-apply :hour 23 :minute 59 :second 59)))

(setq org-agenda-custom-commands '(

                                   ("t" "Items Available TODAY (grouped per area)"
                                    (
                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (not (tags "routine" "spare_time"))
                                                     (or
                                                      (scheduled :to today)
                                                      (not (scheduled))
                                                      )
                                                     )
                                                   (
                                                    (org-ql-block-header "Available TODAY for each Area of Focus")
                                                    ;; (org-agenda-files
                                                    ;;  (get-org-files-in-folder (expand-file-name "~/org/current_projects"))
                                                    ;;  )
                                                    (org-super-agenda-groups '((:auto-category t)))

                                                    )))
                                    )

                                   ("w" "Items Available THIS WEEK (grouped per area)"
                                    (
                                     (org-ql-block `(and
                                                     ,(append '(todo) org-active-states)
                                                     (not (tags "routine" "spare_time"))
                                                     (or
                                                      (scheduled :to ,(jeff/ts-end-of-week (ts-now)))
                                                      (not (scheduled))
                                                      )
                                                     )
                                                   (
                                                    (org-ql-block-header "Available THIS WEEK for each Area of Focus")
                                                    ;; (org-agenda-files
                                                    ;;  (get-org-files-in-folder (expand-file-name "~/org/current_projects"))
                                                    ;;  )
                                                    (org-super-agenda-groups '((:auto-category t)))

                                                    )))
                                    )

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
                                   ("d" "Daily Planning"
                                    (
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
                                   ;; ("w" "Weekly Overview"
                                   ;;  (
                                   ;;   (agenda ""
                                   ;;           ((org-agenda-overriding-header "Weekly Overview")
                                   ;;            (org-agenda-skip-function '(org-agenda-skip-entry-if 'regexp  ":routine:"))
                                   ;;            (org-agenda-span 7))))

                                   ;;  )


                                   ))

(org-super-agenda-mode 1)



(map! :leader
      (:prefix-map ("o". "open")
       :desc "Agenda" "x" (lambda! () (org-agenda t "x" ))
       ))


(defun jeff/org-save-all-non-agenda-org-buffers ()
  "Save all Org buffers without user confirmation."
  (interactive)
  (message "Saving all Org buffers...")
  (save-some-buffers t (lambda () (and (derived-mode-p 'org-mode)
                                       (not (derived-mode-p 'org-agenda-mode)))))
  (when (featurep 'org-id) (org-id-locations-save))
  (message "Saving all Org buffers... done"))

;;;  auto-save org-mode buffers from agenda
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'jeff/org-save-all-non-agenda-org-buffers nil t)
            (auto-save-mode)))
