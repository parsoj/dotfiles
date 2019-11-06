
(with-eval-after-load 'evil
  (with-eval-after-load 'general
    (evil-define-state org "Org State" 
      :cursor 'evil-normal-state-cursor 
      :enable (motion))

    (evil-set-initial-state 'org-mode 'org)

    (general-define-key
     :states 'org
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

    )
)
