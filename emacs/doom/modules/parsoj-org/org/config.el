;;; parsoj-org/init.el -*- lexical-binding: t; -*-


(setq org-capture-templates
      '(
        ("i" "Inbox entry" entry
         (file +org-capture-todo-file)
         "* %?\n%i\n%a" :prepend t :kill-buffer t)

        ("p" "protocol quick-capture" entry
         (file +org-capture-todo-file)
         "* %a" :prepend t :kill-buffer t :immediate-finish t)
        )
      )

(setq +org-capture-frame-parameters
 '((name . "org-capture")
  (width . 70)
  (height . 25)
  (transient . t)
  (undecorated . t)
  ))

(setq +org-capture-todo-file "inbox/inbox.org"
      +org-capture-notes-file "inbox/inbox.org"
      )

(setq org-root "~/org/")

(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)

(defvar sr-org-refile-targets nil
  "List of refile targets for Org-remember.
   See `org-refile-targets'.")

(defvar sr-org-refile-dir-excludes  "^[#\\.].*$")
(defvar sr-org-refile-file-excludes "^[#\\.].*$")


(setq org-root "~/org/")

(setq org-file-search-regexp "\\`[^.].*\\.org\\'")

(defun org-files-from-dirs (dirs)
  (directory-list-find-files-recursively
   (mapcar (lambda (x) (concat org-root x)) dirs)
   org-file-search-regexp))


(defun directory-list-find-files-recursively (dir-list match)
  (seq-reduce 'append  (mapcar (lambda (dir) (directory-files-recursively dir match)) dir-list) nil)
  )

(setq org-refile-targets `(
                           (,(org-files-from-dirs
                              '("projects" "life_ops" "reference" "spare_time" "someday_maybe")) .
                             (:maxlevel . 2))))


;;******************************************************************************************
;; Workflows
;;

(setq org-todo-keywords
      '((sequence "TRIAGE" "TODO" "WAITING" "|" "CANCELLED" "DONE" )))

(setq actionable-states '("TRIAGE" "TODO" "WAITING"))

(defun update-actionability-after-state-change ()
  (if (member org-state actionable-states)
      (org-entry-put (point) "ACTIONABLE" t)
      (org-entry-put (point) "ACTIONABLE" nil)
    )
  )
(add-hook 'org-after-todo-state-change-hook 'update-actionability-after-state-change)

(defun build-actionability-agenda-filter-string ()
  "+ACTIONABLE=\"t\""
  )

;;******************************************************************************************
;; Dependencies
(def-package! org-depend)

;; TODO define hook function for completing a task that blocks other tasks

;; TODO add above hook function to right place

;; TODO set org-depend settings to block completion of tasks that have blockers

;; TODO define query func to filter out blocked tasks

;;******************************************************************************************
;; Resources and Contexts
(setq org-tools-enum '("#laptop" "#tablet" "#home" "#work" "#parents"))

(setq org-contexts-enum '(("@home" . ("#home" "#laptop"))
                          ("@parents" . ("#parents"))
                          ))

(defun build-resource-constraints-agenda-filter-string (available-resources-list)
  ;; TODO implement
  )

;;******************************************************************************************
;; Captial

;; TODO Focus Levels Enum
;; TODO Time levels Enum
;; TODO Money levels Enum

(setq available-capital-alist '(
                                ("Time" . 2)
                                ("Focus". 3)
                                ("Money". 1)
                                ))

(defun build-capital-constraints-agenda-query (available-capital-alist)
  ;; NOTE don't filter out items that require a resource not specificed in the alist

  )

;;******************************************************************************************
;; Agenda Config


(setq org-agenda-files
      (org-files-from-dirs
       '("projects" "life_ops" "spare_time" "someday_maybe")))

(setq org-agenda-custom-commands
      '(("a" "Now" tags-todo 'SCHEDULED<=<now>+TODO="TODO"-BLOCKED' nil org-agenda-files)))
;; TODO add main "next up" block
;; TODO add "appointments today" block
;; TODO add "critical/due-soon" block
;; TODO add view for stuck projects
