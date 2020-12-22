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



(setq org-agenda-files (org-get-agenda-files))

;; (defun org-set-agenda-files ()
;;   (interactive)
;;   (setq org-agenda-files (org-get-agenda-files))
;;   )
;;

(setq org-todo-keywords '((type "INBOX(i)" "PROJECT(p)" "ROUTINE(r)" "|")
                          (sequence  "AVAILABLE(a)" "BLOCKED(b)" "NEXT(n)"  "|" "DONE(d)")))

(setq org-todo-keyword-faces '(("PROJECT" . "purple")
                               ("ROUTINE" . "pink")))


(use-package! org-super-agenda)

(org-super-agenda-mode 1)

(progn

  ;; (setq org-super-agenda-groups '(
  ;;                                 ;; (:name "Due today"
  ;;                                 ;;  :deadline today)

  ;;                                 ;; (:name "Today"
  ;;       			  ;;  ;; :time-grid t
  ;;       			  ;;  :scheduled today)
  ;;                                 (:name "Work Items"
  ;;                                  :and (
  ;;                                        :todo "INBOX"
  ;;                                        :scheduled (past today)
  ;;                                        )
  ;;                                  )

  ;;                                 (:name "Currently Active Projects"
  ;;                                  :and (
  ;;                                        :todo "PROJECT"

  ;;                                        )
  ;;                                  )

  ;;                                 ))

(setq org-agenda-custom-commands '(
                                   ("x" "custom agenda"
                                    (
                                     (tags "+TODO=\"INBOX\""
                                           ((org-agenda-overriding-header "Inbox Items")))
                                     (tags "active/!NEXT"
                                           ((org-agenda-overriding-header "Next items")))
                                     (tags "active/!AVAILABLE|NEXT"
                                           ((org-agenda-overriding-header "On Deck")))
                                     (tags "TODO=\"PROJECT\"&+active"
                                           ((org-agenda-overriding-header "Active Projects")
                                            (org-super-agenda-groups '((:auto-category t)))
                                            ))
                                     (tags "SCHEDULED<=\"<today>\"&+active"
                                           ((org-agenda-overriding-header "Items For Today")
                                            ))
                                     ;; (agenda "" ((org-agenda-span 1)
                                     ;;             (org-agenda-start-day "today")))
                                     ;; (todo "NEXT")
                                     ;; ;; (todo "INBOX")
                                     ;; (todo "PROJECT")
                                     ;;
                                     ))))

  (org-agenda t "x")
  )
