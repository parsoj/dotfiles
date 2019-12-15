
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scratch code

(defun spacemacs/treemacs-project-toggle ()
  "Toggle and add the current project to treemacs if not already added."
  (interactive)
  (if (eq (treemacs-current-visibility) 'visible)
      (delete-window (treemacs-get-local-window))
    (let ((path (projectile-ensure-project (projectile-project-root)))
          (name (projectile-project-name)))
      (unless (treemacs-current-workspace)
        (treemacs--find-workspace))
      (treemacs-do-add-project-to-workspace path name)
      (treemacs-select-window))))

(treemacs-current-workspace)

(setq found-treemacs-workspace (+treemacs-find-workspace-for-path (buffer-file-name)))

(treemacs-workspaces)
(#s(treemacs-workspace "Default" (#s(treemacs-project "digcore-store-srvc" "/Users/jeffparsons/lulu/digcore-store-srvc" local-readable) #s(treemacs-project "organice" "/Users/jeffparsons/code/organice" local-readable) #s(treemacs-project "org" "/Users/jeffparsons/Dropbox/org" local-readable) #s(treemacs-project "configuration" "/Users/jeffparsons/configuration" local-readable))) #s(treemacs-workspace "configuration" (#s(treemacs-project "configuration" "/Users/jeffparsons/configuration" local-readable))))



(setf  (treemacs-workspace->projects (treemacs-current-workspace))
       nil
       )

(treemacs--rerender-after-workspace-change)


#s(treemacs-workspace "Default" nil)

#s(treemacs-workspace "configuration" (#s(treemacs-project "configuration" "/Users/jeffparsons/configuration" local-readable)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; utility funcs
(defun +treemacs-find-workspace-for-path (path) 
  (--first (treemacs-is-path path :in-workspace it)
           (treemacs-workspaces)))

(defun +treemacs-open-current-project ()
  (interactive)

  (let* ((path (projectile-ensure-project (projectile-project-root)))
         (name (projectile-project-name))
	 (found-treemacs-workspace (+treemacs-find-workspace-for-path path))
	 )
    (progn
      (treemacs-select-window) 

      ;; if the project exists in a workspace already - open that workspace
      ;; otherwise, jump to the default workspace, and add the project there
      (if  found-treemacs-workspace  
	  (setf (treemacs-current-workspace)
		found-treemacs-workspace)
	(progn
	  (setf (treemacs-current-workspace)
		(car ( treemacs-workspaces))
		)
	  (treemacs-do-add-project-to-workspace path name)
	  )
	
	)

      (treemacs--rerender-after-workspace-change)

      )))

(defun +treemacs-close-window ()
  (interactive)
  (if (eq (treemacs-current-visibility) 'visible)
      (delete-window (treemacs-get-local-window))))



(defun +treemacs-clear-workspace ()
  (interactive)
  (progn
    (setf  (treemacs-workspace->projects (treemacs-current-workspace))
	   nil)
    (treemacs--rerender-after-workspace-change)))
