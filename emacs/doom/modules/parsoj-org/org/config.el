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

(defun build-actionability-filter-string ()
  "+ACTIONABLE=\"t\""
  )

;;******************************************************************************************
;; Dependencies

;; TODO import & require org-edna

;; TODO add func to use ivy to fetch another task from org-agenda-files

;; TODO add func to add an id to a task if there isn't already an id attached

;; TODO add func to create basic dep between two tasks

;; TODO add entrypoint func to make current task dependant on another

;; TODO add entrypoint func to make current task a blocker for another

(defun build-blocked-filter-string ()
  "+BLOCKER=nil"
  )

;;******************************************************************************************
;; Resources and Contexts
(setq org-resources-enum '("#laptop" "#tablet" "#home" "#work" "#parents"))


(setq org-contexts-enum '(("@home" . ("#home" "#laptop"))
                          ("@parents" . ("#parents"))
                          ))

(setq org-current-context-resources '())

(defun set-current-resources-from-saved-context ()
  ;; TODO implement
  )

(defun build-context-filter-string ()
  ;; TODO implement - should just be calling the resource constraints filter from current context
  )

(defun build-resource-constraints-filter-string (available-resources-list)
  ;; TODO implement
  )

;;******************************************************************************************
;; Captial

(setq focus-levels-enum '(1 2 3 4))

;; In minutes for now
(setq time-levels-enum '(5 15 30 60 120 180))


(setq available-capital-alist '(
                                ("Time" . 30)
                                ("Focus". 3)
                                ))

(defun build-capital-constraints-agenda-query (available-capital-alist)
  ;; NOTE don't filter out items that require a resource not specificed in the alist
  ;; TODO implement

  )

;;******************************************************************************************
;; "Up Next" Agenda block

(defun build-up-next-agenda-query ()
  ;; TODO implement
  ""
  )

;;******************************************************************************************
;; Agenda Config



(setq org-agenda-files
      (org-files-from-dirs
       '("projects" "life_ops" "spare_time" "someday_maybe")))

(setq org-agenda-custom-commands
      `(("a" "Now"
         ((tags-todo ,(build-up-next-agenda-query) nil org-agenda-files))
         (agenda "" ((org-agenda-span 1)
                     (org-deadline-warning-days 7)))
         (agenda "" ((org-agenda-span 7)
                     (org-deadline-warning-days 21)
                     (org-agenda-repeating-timestamp-show-all t)))
         )))

;; TODO add view for stuck and stalled projects
;; stuck projects -> no actionable items under the project
;; stalled projects ->actionable items that haven't gotten attention for x days
