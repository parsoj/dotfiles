(with-eval-after-load '+org-core

  (setq org-dependency-targets `((,(directory-files-recursively org-projects-root ".*" t)
				  :maxlevel . 4)))


  (defun +org-dependencies-find-todo (search-targets)
    ;; hacking the "org refile" searching functionality to find a todo
    (let ((org-refile-targets search-targets)) 
      (org-refile-get-location)))

  ;; make org header at point a dependant on the header at point b
  (defun create-dependency (pom_a pom_b) 
    (let ((id_a (org-id-get pom_a t)) 
	  (id_b (org-id-get pom_b t)))
      (progn (modify-property pom_a "BLOCKERS" (lambda (id_list) 
						 (-union id_list '(id_b)))) 
	     (update-state-from-blocker-data pom_a) 
	     (modify-property pom_b "BLOCKING" (lambda (id_list) 
						 (-union id_list '(id_a)))))))




  ;; TODO replace usages of "pom" with a "refile-pointer" type item (from org.el)
)
