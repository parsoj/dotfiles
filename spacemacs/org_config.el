
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

;; == Agenda ==

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
      '(
        ("m" "Morning Routine"
         ((tags-todo "+morning_routine+SCHEDULED<=\"<today>\""
					   ((org-agenda-overriding-header "Morning Routine:")
					    ))))
        ("n" "Nightly Routine"
         ((tags-todo "+nightly_routine+SCHEDULED<=\"<today>\"|+@home+EFFORT<=1"
					           ((org-agenda-overriding-header "Nightly Routine:")
					            ))))
	      ("t" "Today's Agenda"
         ((agenda ""))
         ;; TODO stuff stuck in WAITING
         ;; TODO - calendar events today
         ;; TODO - tasks scheduled for today
         ;; TODO tasks due today
         ;; TODO ordered by priority 
         ((org-agenda-span 1)
          (org-agenda-tag-filter-preset '("-morning_routine-nightly_routine"))
          ))
        ("w" . "Weekly Review agenda views")
        ("wr" "Last week in review"
         ((agenda "" (
                  (org-agenda-overriding-header "The Week in review")
                  (org-agenda-start-day "-7d")
                  (org-agenda-start-on-weekday nil)
                  (org-agenda-ndays-to-span 8)))
          (tags "+defer_weekly_review" (
                  (org-agenda-overriding-header "Items Deferred to Weekly Review")
                                        ))
          (stuck) ;; TODO refine definition of stuck projects
          )
         )
        ("wg" "goals review"
         (tags "+goal")
         )
        ("wf" "The Week Ahead"
         ((agenda "" (
                     (org-agenda-overriding-header "The Week Ahead")
                     (org-agenda-start-on-weekday nil)
                     (org-agenda-start-day "-1d")
                     (org-agenda-ndays-to-span 7)
                     )))
         ;; TODO add in stats on weekly work ahead

         )

	 ))

;; == Agenda Navigation ==

;; Search for a "=" and go to the next line
(defun gs/org-agenda-next-section ()
  "Go to the next section in an org agenda buffer"
  (interactive)
  (if (search-forward "===" nil t 1)
      (forward-line 1)
    (goto-char (point-max)))
  (beginning-of-line))

;; Search for a "=" and go to the previous line
;;(defun gs/org-agenda-prev-section ()
;;  "Go to the next section in an org agenda buffer"
;;  (interactive)
;;  (forward-line -2)
;;  (if (search-forward "===" nil t -1)
;;      (forward-line 1)
;;    (goto-char (point-min))))

;; == Agenda Post-processing ==
;; Highlight the "!!" for stuck projects (for emphasis)
(defun gs/org-agenda-project-highlight-warning ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "!W" nil t)
      (progn
	(add-face-text-property
	 (match-beginning 0) (match-end 0)
	 '(bold :foreground "orange"))
	))
    (goto-char (point-min))
    (while (re-search-forward "!S" nil t)
      (progn
	(add-face-text-property
	 (match-beginning 0) (match-end 0)
	 '(bold :foreground "white" :background "red"))
	))
    ))
(add-hook 'org-finalize-agenda-hook 'gs/org-agenda-project-highlight-warning)

;; Remove empty agenda blocks
(defun gs/remove-agenda-regions ()
  (save-excursion
    (goto-char (point-min))
    (let ((region-large t))
      (while (and (< (point) (point-max)) region-large)
	(set-mark (point))
	(gs/org-agenda-next-section)
	(if (< (- (region-end) (region-beginning)) 5) (setq region-large nil)
	  (if (< (count-lines (region-beginning) (region-end)) 4)
	      (delete-region (region-beginning) (region-end)))
	  )))))


(add-hook 'org-finalize-agenda-hook 'gs/remove-agenda-regions)

