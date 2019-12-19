;;; +treemacs.el -*- lexical-binding: t; -*-


(use-package treemacs
  :config
  (treemacs-follow-mode t) 
  (treemacs-filewatch-mode t)

  (setq treemacs-width 35
        treemacs-display-in-side-window t
        treemacs-indentation-string (propertize " " 'face 'font-lock-comment-face)
        treemacs-indentation 1)

  (add-hook 'treemacs-mode-hook (lambda ()
                                  (linum-mode -1)
                                  (fringe-mode 0)
                                  ;;(setq buffer-face-mode-face `(:background "#211C1C"))
                                  (buffer-face-mode 1)))





  
  )

(use-package treemacs-evil
  :after treemacs +evil
  )

(use-package treemacs-projectile
  :after treemacs projectile
  )

(use-package treemacs-magit
  :after treemacs magit
  )

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

(provide '+treemacs)
;;; +treemacs.el ends here
