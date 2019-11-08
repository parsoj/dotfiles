
(with-eval-after-load '+org-core
  (defun refresh-org-agenda-files () 
    (interactive) 
    (setq org-agenda-files (mapcan (lambda (dir) 
				     (directory-files-recursively
				      (concat org-root "/" dir)
				      "\\.org$"))
				   org-project-dirs)))


  (refresh-org-agenda-files))
