
(with-eval-after-load 'evil
  (with-eval-after-load 'general
    (evil-define-state org "Org State" 
      :cursor 'evil-normal-state-cursor 
      :enable (motion))

    (evil-set-initial-state 'org-mode 'org)
    (define-key evil-org-state-map (kbd "k") #'evil-previous-line) 
    (define-key evil-org-state-map (kbd "j") #'evil-next-line) 
    (define-key evil-org-state-map (kbd "l") #'evil-forward-char) 
    (define-key evil-org-state-map (kbd "h") #'evil-backward-char)

    (define-key evil-org-state-map (kbd "r") #'org-refile)
    (define-key evil-org-state-map (kbd "i") #'evil-insert)

    (define-key evil-org-state-map (kbd "t") #'org-todo)

    (define-key evil-org-state-map (kbd "d") #'evil-delete-line)


     )
    )
