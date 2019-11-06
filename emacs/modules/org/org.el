
(with-eval-after-load 'doom-themes
(setq org-todo-keyword-faces `(
                               ("PROJECT" . ,(doom-color 'violet))
                               ("TODO" . ,(doom-color 'yellow))
                               ("DONE" . ,(doom-color 'grey))
                               ("CANCELLED" . ,(doom-color 'grey))
                               )

      org-todo-keywords '(
                          (sequence "TODO(t)" "WAITING(w)" "|" "CANCELLED(c)" "DONE(d!)" )
                          (sequence "PROJECT(p)" "|" "PROJECT-COMPLETED(P)")
                          ))


)



(setq org-root "~/org")
(setq org-project-dirs '("projects"))

(defun refresh-org-agenda-files ()
 (interactive) 
 (setq org-agenda-files
       (mapcan (lambda (dir)
		 (directory-files-recursively
		  (concat org-root "/" dir)
		  "\\.org$")) org-project-dirs)))
 


(refresh-org-agenda-files)


(setq org-actionable-keywords '("TODO"))

(custom-set-variables '(org-stuck-projects
		      '("/+PROJECT" ("TODO") nil "")))


 (provide '+org-core)
