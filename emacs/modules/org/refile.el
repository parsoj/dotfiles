
(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)


(setq org-root "~/org") 
(setq org-refile-dirs '("projects" "on_hold" "reference"))

(setq org-refile-targets `(
			   ,(mapcan
			    (lambda (dir) (directory-files-recursively (concat org-root "/" dir) "\\.org$") )
			    org-refile-dirs) 
			   (:maxlevel . 3)))

