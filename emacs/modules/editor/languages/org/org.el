(use-package org
  
  
  :config
  ;; running (org-reload) forces emacs to load the newest version of org,
  ;; rather than just sticking with the built-in version
  ;;(we have deps on the newest version of org, so we need to do this)
  (org-reload)

  (setq org-root "~/org")
  (setq org-projects-root (concat org-root "/projects"))
  (setq org-inbox-root (concat org-root "/inbox"))

  (setq org-files-regex "\\.org$")

  (defun +org-all-files ()
    (directory-files-recursively org-root org-files-regex)
    )

  (defun +org-all-project-files ()
    (directory-files-recursively org-projects-root org-files-regex))

  (defun +org-inbox-files ()
    (directory-files-recursively org-inbox-root org-files-regex)
    )

  (custom-set-variables '(org-stuck-projects
			  '("/+PROJECT" ("TODO") nil "")))

  (defun +org-set-price ()
    (interactive)
    (org-set-property "PRICE" (read-string "Price: "))
    )



  (with-eval-after-load '+yasnippet
	(with-eval-after-load '+general
    (general-add-hook
     'org-mode
     (list
      #'yas-minor-mode
      ))
    ))

  (provide '+org-core)
  )
