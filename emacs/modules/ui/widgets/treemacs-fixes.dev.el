
(defun +treemacs-find-and-switch-workspace ()
  (interactive)
  (progn
    (treemacs--find-workspace) 

    (treemacs--rerender-after-workspace-change)

    )

  )
(defun spacemacs/treemacs-project-toggle ()
  "Toggle and add the current project to treemacs if not already added."
  (interactive)
  (if (eq (treemacs-current-visibility) 'visible)
      (delete-window (treemacs-get-local-window))



    )
  )


(defun open-current-project-in-treemacs ()
  (interactive)

  (let ((path (projectile-ensure-project (projectile-project-root)))
        (name (projectile-project-name))
	)
    (progn
      (treemacs-select-window) 

      (if ( treemacs-find-workspace-for-path path) 

	  (setf (treemacs-current-workspace) 
		(treemacs-find-workspace-for-path path))

	)

      ;;(treemacs-do-add-project-to-workspace path name)
      (treemacs--rerender-after-workspace-change)

      )
    )

  )

(defun treemacs-find-workspace-for-path (path) 
  (--first (treemacs-is-path path :in-workspace it)
           (treemacs-workspaces)  
	   )
  )




(setf (treemacs-current-workspace)
      (let ((it (treemacs-current-workspace))
	    (path default-directory))
	(--first (treemacs-is-path path :in-workspace it)
		 treemacs--workspaces)))

