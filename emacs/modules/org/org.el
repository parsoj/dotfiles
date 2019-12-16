(use-package org
  

  :config
  ;; running (org-reload) forces emacs to load the newest version of org,
  ;; rather than just sticking with the built-in version
  ;;(we have deps on the newest version of org, so we need to do this)
  (org-reload)

  (setq org-root "~/org")
  (setq org-projects-root (concat org-root "/projects"))


  (custom-set-variables '(org-stuck-projects
			  '("/+PROJECT" ("TODO") nil "")))

  (defun +org-set-price ()
    (interactive)
    (org-set-property "PRICE" (read-string "Price: "))
    )

  (provide '+org-core))
