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

;;********************************************************************************
;; Calendar
;; TODO google cal integration


;;********************************************************************************
;; Context Picker

;; TODO implement a context quick-picker to set current resources and capital


;;******************************************************************************************
;; Workflows
;;

(setq org-todo-keywords
      '((sequence "TRIAGE(i)" "TODO(t)" "WAITING(w)" "|" "CANCELLED(c)" "DONE(d)" )))

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
(setq org-resources-enum '("#laptop" "#tablet" "#home" "#work" "#parents" "#spare_time"))


(setq org-contexts-enum '(("@home" . ("#home" "#laptop" "#spare_time"))
                          ("@parents" . ("#parents"))
                          ("@work" . ("#laptop" "#work"))
                          ))


(defvar org-current-context-resources '())

(defun set-current-resources-from-saved-context (context)
  (setq org-current-context-resources (assoc-default context org-contexts-enum))
  )

(defun build-resource-constraints-filter-string ()
  (string-join-pre (seq-filter (lambda (e) (not (member e org-current-context-resources))) org-resources-enum) "-")
  )

(defun string-join-pre (l sep)
  (concat sep (string-join l sep))
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
  (concat (build-resource-constraints-filter-string) "+TODO=\"TODO\"-SCHEDULED>=<now>" )
  )

;;******************************************************************************************
;; Agenda Config



(setq org-agenda-files
      (org-files-from-dirs
       '("projects" "life_ops" "spare_time" "someday_maybe")))

(setq org-agenda-custom-commands
      `(("x" "Now"
         ((tags-todo ,(build-up-next-agenda-query) nil org-agenda-files)
          (agenda "" ((org-agenda-span 1)
                      (org-deadline-warning-days 7)))
          (agenda "" ((org-agenda-span 7)
                      (org-deadline-warning-days 21)
                      (org-agenda-repeating-timestamp-show-all t))))
         )))

;; TODO add view for stuck and stalled projects
;; stuck projects -> no actionable items under the project
;; stalled projects ->actionable items that haven't gotten attention for x days



;; * TODO Implement quick tagging from agenda view
;; * TODO Implement shortcut for opening agenda view

;; *TODO save this in a layout/perspective
