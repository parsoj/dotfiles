
(with-eval-after-load 'evil
  (with-eval-after-load 'general
    (with-eval-after-load '+navigation-helpers
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

       
       "h" 'outline-up-heading
       "j" 'outline-forward-same-level
       "k" 'outline-backward-same-level
       "l" #'(lambda () (interactive) (progn
				   (outline-show-children)
				   (outline-show-entry)
				   (outline-next-heading)))



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
	 (
	  ("o" (lambda() (interactive)  ( do-find-file-jump "Jump to org file:" (+org-all-files))) "Any Org File")
	  ("p" (lambda() (interactive)  ( do-find-file-jump "Jump to org project file:" (+org-all-project-files))) "Org Project File")
	  ("i" (find-file (concat org-root "/inbox/inbox.org")))
	  ("r" +refresh-org-refile-targets "Refresh Org-Refile Targets")
	  ("a" org-agenda "Agenda")
	  ))))

    )
  )
