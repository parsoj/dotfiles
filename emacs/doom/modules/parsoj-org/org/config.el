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

(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)

(defvar sr-org-refile-targets nil
  "List of refile targets for Org-remember.
   See `org-refile-targets'.")

(defvar sr-org-refile-dir-excludes  "^[#\\.].*$")
(defvar sr-org-refile-file-excludes "^[#\\.].*$")


(setq org-directory "~/org/")

(setq org-file-search-regexp "\\`[^.].*\\.org\\'")

(defun org-files-from-dirs (dirs)
  (directory-list-find-files-recursively
   (mapcar (lambda (x) (concat org-directory x)) dirs)
   org-file-search-regexp))


(defun directory-list-find-files-recursively (dir-list match)
  (seq-reduce 'append  (mapcar (lambda (dir) (directory-files-recursively dir match)) dir-list) nil)
  )

(defun refresh-org-refile-targets ()
  (interactive)
  (setq org-refile-targets `(
                             (,(org-files-from-dirs
                                '("remitly" "projects" "life_ops" "reference" "spare_time" "someday_maybe")) .
                                (:level . 0)))))

(refresh-org-refile-targets)

(add-hook 'org-after-refile-insert-hook 'org-save-all-org-buffers)

;;********************************************************************************
;; Global IDs for org entries

(setq org-id-track-globally t)
(setq org-id-locations-file (convert-standard-filename (concat org-directory ".org-id-locations")))

;;********************************************************************************
;; Context Picker

;; TODO implement a context quick-picker to set current resources and capital


;;******************************************************************************************
;; Workflows
;;

(setq org-todo-keyword-faces `(
                               ("TODO" . ,(doom-color 'yellow))
                               ("NEXT" . ,(doom-color 'red))
                               ("INBOX" . ,(doom-color 'yellow))
                               ("LATER" . ,(doom-color 'teal))
                               ("DONE" . ,(doom-color 'grey))
                               ("CANCELLED" . ,(doom-color 'grey))
                               ("GOAL" . ,(doom-color 'green))
                               )

      org-todo-keywords '(
                          (sequence "TODO(t)" "INBOX(i)" "NEXT(n)" "IN-PROGRESS(p)" "LATER(l)" "WAITING(w)" "BLOCKED(b)" "|" "CANCELLED(c)" "DONE(d!)" )
                          (sequence "GOAL(g)" "|" "GOAL-REACHED(r)")
                          ))

;; TODO rethink the actionable states thing
(setq actionable-states '("TRIAGE" "TODO" "WAITING"))

(defun build-actionability-filter-string ()
  (format "+TODO={%s}" (string-join actionable-states "|"))
  )

;;******************************************************************************************
;; Dependencies
;;

(defvar org-dependency-targets '((org-agenda-files :maxlevel . 4)))

(defun ivy-find-todo (search-targets)
  ;; hacking the "org refile" searching functionality to find a todo
  (let ((org-refile-targets search-targets))
    (org-refile-get-location)
    ))

(defun update-blocked-state (pom)
  (let* ((in-blocked-state (equal (org-entry-get pom "TODO") "BLOCKED") )
        (has-blockers (org-entry-get-multivalued-property pom "BLOCKER") )
        (prev-state (org-entry-get pom "STATE-BEFORE-BLOCKED") )
        (has-prev-state (if prev-state t nil) )
        )

    (cond
     ((and in-blocked-state (not has-blockers))
      (progn
        (org-entry-put pom "TODO" (if has-prev-state prev-state "TODO") )
        (org-entry-delete pom "STATE-BEFORE-BLOCKED"))
      )
     ((and (not in-blocked-state) has-blockers)
      (org-entry-put pom "STATE-BEFORE-BLOCKED" (org-entry-get pom "TODO"))
      (org-entry-put pom "TODO" "BLOCKED")
      )
     )

    )
  )

(defun create-dependency (pom_a pom_b)
  (let ((id_a (org-id-get pom_a t))
        (id_b (org-id-get pom_b t)))

    (progn
      (modify-property pom_a "BLOCKERS" (lambda (id_list) (-union id_list '(id_b))))
      (update-state-from-blocker-data pom_a)
      (modify-property pom_b "BLOCKING" (lambda (id_list) (-union id_list '(id_a))))
      )
    )
  )

(defun on-complete-update-downstream-deps (pom)
  ;; look up own id prop (let)
  ;; look up "blocking" prop list (let)

  ;; map over each blocked id:
  ;; * TODO find downstream task based on id
  ;;   - NEXT TODO research how the edna id finder works
  ;; * remove own id from BLOCKER prop list (difference)
  ;; * update state from blocker data (above func)

  )

(defun add-blocker (pom)
  ;; TODO ivy find other task
  ;; TODO create dependency this->other

  )

(defun block-other-task (pom)
  ;; TODO ivy find other task
  ;; TODO create dependency other->this
  )

(defun build-blocked-filter-string ()
  "+BLOCKER={^$}"
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
  (concat
   (build-resource-constraints-filter-string)
   (build-blocked-filter-string)
   "+TODO=\"TODO\"-SCHEDULED>=\"<now>\"" )
  )

;;******************************************************************************************
;; Agenda Config



(defun refresh-org-agenda-files ()
  (interactive)
  (setq org-agenda-files
        (org-files-from-dirs
         '("remitly" "projects" "life_ops" "spare_time" "someday_maybe"))))
(refresh-org-agenda-files)

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


;;********************************************************************************
;; Calendar
;; TODO google cal integration

;; NOTE - we expect "org-caldav-oauth2-client-id" and "org-caldav-oauth2-client-secret" to be set in a secrets file

(setq org-caldav-url 'google)
(setq org-caldav-calendar-id "parsoj@gmail.com")
(setq plstore-cache-passphrase-for-symmetric-encryption t)
(setq org-caldav-inbox (concat org-directory "calendar/org-caldav-inbox.org"))
(setq org-caldav-files org-agenda-files)
(setq org-icalendar-timezone "US/Seattle")
