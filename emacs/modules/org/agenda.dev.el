

(defun refresh-org-agenda-files () 
  (interactive) 
  (setq org-agenda-files    
	(directory-files-recursively
	 org-projects-root
	 "\\.org$")))


(refresh-org-agenda-files) 


(setq org-agenda-custom-commands
      '(("a" "Main Agenda"
	 (
	  (tags-todo "DEADLINE<=\"<+3d>\"+SCHEDULED>=\"<today>\""
		     ((org-agenda-overriding-header "Due Soon")))

	  (tags "+inbox"
		((org-agenda-overriding-header "Inbox Items")))

	  (tags-todo "DEADLINE>\"<+3d>\"+DEADLINE<=\"<+1w>\"+SCHEDULED>=\"<today>\""
		     ((org-agenda-overriding-header "Due Within the Week")))

	  (tags-todo (concat
		      "TODO=" (string-join org-actionable-keywords "|")
		      "+SCHEDULED>=\"<today>\"")
		     ;;TODO add contextual info (actionable in current context)
		     ((org-agenda-overriding-header "Actionable Tasks"))
		     )
	  )
	 )))


(org-agenda)
