(use-package org
  

  :config
  ;; running (org-reload) forces emacs to load the newest version of org,
  ;; rather than just sticking with the built-in version
  ;;(we have deps on the newest version of org, so we need to do this)
  (org-reload)

  (with-eval-after-load 'doom-themes
    (setq org-todo-keyword-faces `(
				   ("PROJECT" . ,(doom-color 'violet))
				   ("TODO" . ,(doom-color 'yellow))
				   ("DONE" . ,(doom-color 'grey))
				   ("CANCELLED" . ,(doom-color 'grey))
				   )

	  org-todo-keywords '(
                              (sequence "TODO(t)" "BLOCKED(b)" "WAITING(w)" "|" "CANCELLED(c)" "DONE(d!)" )
                              (sequence "PROJECT(p)" "|" "PROJECT-COMPLETED(P)")
                              ))


    )



  (setq org-root "~/org")
  (setq org-projects-root (concat org-root "/projects"))



  (setq org-actionable-keywords '("TODO"))

  (custom-set-variables '(org-stuck-projects
			  '("/+PROJECT" ("TODO") nil "")))

  (defun +org-set-price ()
    (interactive)
    (org-set-property "PRICE" (read-string "Price: "))
    )

  (provide '+org-core))
