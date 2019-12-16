
(with-eval-after-load 'evil
  (with-eval-after-load 'general
    (evil-define-state org "Org State" 
      :cursor 'evil-normal-state-cursor 
      :enable (motion))

    ;; NOTE disabling this custom state for org mode for now
    ;;(evil-set-initial-state 'org-mode 'org)
    (evil-set-initial-state 'org-mode 'normal)  

    (general-define-key
     :states '(normal visual emacs movement treemacs)    
     :prefix "SPC"
     "o" 'hydra-org-actions/body

     )



    (general-define-key
     :keymaps 'org-mode-map
     :states 'normal
     :prefix ","

     
     "k" 'outline-backward-same-level
     "j" 'outline-forward-same-level
     "l" #'(lambda () (interactive) (progn
				 (outline-show-children)
				 (outline-show-entry)
				 (outline-next-heading)))
     "h" 'outline-up-heading
     "r" 'org-refile
     "i" 'evil-insert

     "t" 'org-todo

     "d" 'org-cut-subtree
     "p" 'org-paste-subtree
     "u" 'undo
     )

    (defvar hydra-org-actions--title "Org Actions")

    (pretty-hydra-define hydra-org-actions
      (:color teal :title hydra-org-actions--title)
      (
       "Jump To..."
       (("p" jump-to-org-project "Jump to project file")
	)))

    (defun jump-to-org-project ()
      (interactive)
      (let ((module-path (completing-read
			  "Jump To Org Project: "
			  (directory-files-recursively projects-root ".*" t)
			  nil t)))
	(find-file module-path)
	)

      )

    )
  )
