

(defun refresh-org-agenda-files () 
  (interactive) 
  (setq org-agenda-files    
	(+org-all-project-files)
	))


(refresh-org-agenda-files) 


(setq org-agenda-custom-commands
      '(("a" "Main Agenda"
	 (
	  (tags (concat  "/+" (string-join org-actionable-keywords "+|"))
		((org-agenda-overriding-header "Inbox Items")
		 (org-agenda-files (+org-inbox-files))))

	  ;;(tags "+DEADLINE<=\"<+3d>\"+SCHEDULED>=\"<today>\""
	  ;;	((org-agenda-overriding-header "Due Soon")))


	  (tags
	   "+DEADLINE>\"<+3d>\"+DEADLINE<=\"<+1w>\"+SCHEDULED>=\"<today>\""  
	   ((org-agenda-overriding-header "Due Within the Week")))

	  (tags (concat
		 "/+" (string-join org-actionable-keywords "+|")
		 ;;"+SCHEDULED=\"\"+SCHEDULED>=\"<today>\""
		 )
		;;TODO add contextual info (actionable in current context)
		((org-agenda-overriding-header "Actionable Tasks"))
		)

	  )
	 )))


(org-agenda nil "a")
