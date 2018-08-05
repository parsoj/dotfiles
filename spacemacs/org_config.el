
(setq org-hierarchical-todo-statistics nil)

;; disable org mode timestamping for now
(setq org-log-done nil)

;; keybinding to quickly delete subtrees
(spacemacs/set-leader-keys-for-major-mode 'org-mode "S d" 'org-cut-subtree)

;;********************************************************************************
;; external integrations and syncs

;; sync org calendar with google calendar (needs creds from secrets.el.gpg)
(require 'org-gcal)
(setq org-gcal-file-alist '(("parsoj@gmail.com" . "~/org/calendar/calendar.org")))

(setq org-mobile-directory "~/Dropbox/emacsData/orgMode/mobileOrg/push")
(setq org-mobile-inbox-for-pull "~/Dropbox/emacsData/orgMode/mobileOrg/pull")

;;******************************************************************************************
;; agenda config
;; (copied from Gregory Stein's config: https://github.com/gjstein/emacs.d )

(require 'org-agenda)

;;; Code:
;; Some general settings
(setq org-directory "~/org")

;; Display properties
(setq org-tags-column 80)
(setq org-agenda-tags-column org-tags-column)
(setq org-agenda-sticky nil)

;; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%50ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM %16TIMESTAMP_IA")

;;******************************************************************************************
;; Tags
(setq org-tag-alist '((:startgroup)
		      ("@errands" . ?e)
		      ("@grocery" . ?g)
		      ("@home" . ?h)
		      ("@parents_house" . ?a)
		      ("@maiolinos_house" . ?m)
		      (:endgroup)
		      ("@computer" . ?c)
		      ("@phone_privacy" . ?p)
		      ("@business_hours" . ?h)
          ("defer_weekly_review" . ?d)
		      ("WAITING" . ?w)
		      ("PERSONAL" . ?P)
		      ("NOTE" . ?n)
		      ))

;; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key 'expert)

;; Include the todo keywords
(setq org-fast-tag-selection-include-todo t)

;;******************************************************************************************
;; Custom State Keywords
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w@/!)" "INACTIVE(i@/!)" "|" "CANCELLED(c@/!)" "MEETING")
        (sequence "GOAL(g)" "|" "ACHIEVED")
        ))
;; Custom colors for the keywords
(setq org-todo-keyword-faces
      '(("TODO" :foreground "red" :weight bold)
	("NEXT" :foreground "blue" :weight bold)
	("DONE" :foreground "forest green" :weight bold)
	("WAITING" :foreground "orange" :weight bold)
	("INACTIVE" :foreground "magenta" :weight bold)
	("CANCELLED" :foreground "forest green" :weight bold)
	("MEETING" :foreground "forest green" :weight bold)))
;; Auto-update tags whenever the state is changed
(setq org-todo-state-tags-triggers
      '(("CANCELLED" ("CANCELLED" . t))
	("WAITING" ("WAITING" . t))
	("INACTIVE" ("WAITING") ("INACTIVE" . t))
	(done ("WAITING") ("INACTIVE"))
	("TODO" ("WAITING") ("CANCELLED") ("INACTIVE"))
	("NEXT" ("WAITING") ("CANCELLED") ("INACTIVE"))
	("DONE" ("WAITING") ("CANCELLED") ("INACTIVE"))))


;; using org-edna module to manage dependencies between todos
(add-to-list 'org-modules 'org-edna)
(org-edna-load)

;;******************************************************************************************
;; capture templates
(defun org-capture-at-point ()
  "Insert an org capture template at point."
  (interactive)
  (org-capture 0))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/inbox/inbox.org" "Tasks")
         ,(concat
           "* TODO %^{Task Description} %^G\n SCHEDULED: <%(org-read-date)> \n %^{Effort}p \n %^{Goal}p\n"
         ))))

(defun org-insert-gtd-task ()
  ;; get description
  (setq task-description (read-string "Task Description:"))
  ;; get contexts

  ;; get effort
  ;; TODO read up on effort estimates and set default t-shirt sizes
  (setq effort-level (read-number "Effort Level:"))

  ;; get and relevant dates attached to the task
  (setq relevant-dates (pcase (ido-completing-read "Schedule or Deadline?" '("Schedule" "Deadline" "None"))
    ('"Schedule" (concat "SCHEDULED: <" (org-read-date) ">"))
    ('"Deadline" (concat "DEADLINE: <" (org-read-date) ">"))
    ('"None" "")
    ))

  ;; goal or none
  (setq goal-prop (helm-completing-read (org-map-entries '(lambda ()
                                      (nth 4 (org-heading-components))
                                      ) "/+TODO" 'agenda)))

  ;; priority
)

(defun attach-to-goal()
  (org-entry-put (point)
                 "GOAL"
                 (ido-completing-read "Which Goal?"
                                     (org-map-entries '(lambda ()
                                                         (nth 4 (org-heading-components))
                                                         ) "/+GOAL" 'agenda))))

(add-to-list 'org-global-properties
             '("Effort_ALL". "0:05 0:10 0:15 0:30 1:00 2:00 3:00 4:00 8:00"))

;; org-checklist module provides auto-resetting of nested checkboxes for repeating headers
(require 'org-checklist)
(add-to-list 'org-modules 'org-checklist)

;;******************************************************************************************
;; gs helper functions
(defun gs/mark-next-done-parent-tasks-todo ()
  "Visit each parent task and change NEXT (or DONE) states to TODO."
  ;; Don't change the value if new state is "DONE"
  (let ((mystate (or (and (fboundp 'org-state)
                          (member state
				  (list "NEXT" "TODO")))
                     (member (nth 2 (org-heading-components))
			     (list "NEXT" "TODO")))))
    (when mystate
      (save-excursion
        (while (org-up-heading-safe)
          (when (member (nth 2 (org-heading-components)) (list "NEXT" "DONE"))
            (org-todo "TODO")))))))
(add-hook 'org-after-todo-state-change-hook 'gs/mark-next-done-parent-tasks-todo 'append)

;; == Refile ==
;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq refile-items (apply 'append
	                            (mapcar
	                             (lambda (directory)
		                             (directory-files-recursively
		                              directory org-agenda-file-regexp))
	                             '("~/org/"))))
(setq org-refile-targets '((nil :maxlevel . 12)
                           (refile-items :maxlevel . 12)))

;;  Be sure to use the full path for refile setup
(setq org-refile-use-outline-path 'full-file-path)
(setq org-outline-path-complete-in-steps nil)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)

;; == Habits ==
;;(require 'org-habit)
;;
(add-to-list 'org-modules 'org-habit)
(setq org-habit-show-habits-only-for-today t)

;; ******************************************************************************************
;; Agenda
(setq org-agenda-files (apply 'append
	                            (mapcar
	                             (lambda (directory)
		                             (directory-files-recursively
		                              directory org-agenda-file-regexp))
	                             '("~/org/projects/"
                                 "~/org/calendar/"
                                 ))))

;; Dim blocked tasks (and other settings)
(setq org-enforce-todo-dependencies t)
(setq org-agenda-inhibit-startup nil)
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view (disabled)
(setq org-agenda-compact-blocks nil)

;; ignore stuff that is scheduled in the future
(setq org-agenda-todo-ignore-scheduled 'future)
(setq org-agenda-tags-todo-honor-ignore-options t)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      '(("x" "Experimental Main Agenda"
         ((tags-todo "SCHEDULED<=\"<now>\""
                     ((org-agenda-overriding-header "Scheduled Items")))
          (todo ""
                ((org-agenda-overriding-header "Tasks")
                 (org-agenda-max-entries 5)
                 ))

          (agenda ""
                  ((org-agenda-overriding-header "Agenda")
                   (org-agenda-span 1)
				           (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
                   ))))))

