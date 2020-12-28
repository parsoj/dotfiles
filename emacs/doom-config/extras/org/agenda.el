;;; ../.config/emacs/doom-config/extras/org/agenda.el -*- lexical-binding: t; -*-


(setq agenda-folders '("inbox" "active"))


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



(defun refresh-agenda-files ()
  (interactive)
  (setq org-agenda-files (org-get-agenda-files)))

(refresh-agenda-files)


;; (defun org-set-agenda-files ()
;;   (interactive)
;;   (setq org-agenda-files (org-get-agenda-files))
;;   )
;;


(use-package! org-super-agenda)
(use-package! org-ql)

;; (org-super-agenda-mode 1)

;;;  todo keywords must be set after org-ql and org-super agenda have been loaded
(setq org-todo-keywords '((type "INBOX(i)" "PROJECT(p)" "ROUTINE(r)" "|")
                          (sequence  "AVAILABLE(a)" "BLOCKED(b)" "NEXT(n)"  "|" "DONE(d)")))

(setq org-todo-keyword-faces '(("PROJECT" . "purple")
                               ("ROUTINE" . "pink")))

(setq org-active-states '("NEXT" "AVAILABLE" "ROUTINE"))


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
                                     (org-ql-block `(and (tags "active")
                                                         (or (scheduled :to today)
                                                             (not (scheduled)))
                                                         ,(append '(todo) org-active-states))
                                                   ((org-ql-block-header "Available Today")))
                                     (tags "TODO=\"PROJECT\"&+active"
                                           ((org-agenda-overriding-header "Active Projects")
                                            (org-super-agenda-groups '((:auto-category t)))
                                            ))
                                     (org-ql-block `(and
                                                     (todo "PROJECT")
                                                     (tags "active")
                                                     (not (descendants ,(append '(todo) org-active-states)))
                                                     )
                                                   ((org-ql-block-header "Stuck Projects")))
                                     ))))



(map! :leader
      (:prefix-map ("o". "open")
       :desc "Agenda" "x" (lambda! () (org-agenda t "x" ))
       ))
