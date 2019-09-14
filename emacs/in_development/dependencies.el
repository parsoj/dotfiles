
(setq org-dependency-targets `((,(directory-files-recursively active-projects-root ".*" t) :maxlevel . 4))) 


(defun +org-dependencies-find-todo (search-targets)
  ;; hacking the "org refile" searching functionality to find a todo
  (let ((org-refile-targets search-targets))
    (org-refile-get-location)
    ))


(defun update-blocked-state (pom)
  (let* ((in-blocked-state (equal (org-entry-get pom "TODO") "BLOCKED") )
        (has-blockers (org-entry-get-multivalued-property pom "BLOCKER") )
        (prev-state (org-entry-get pom "STATE-BEFORE-BLOCKED") )
        (has-prev-state (if prev-state t nil) )
        )

    (cond
     ((and in-blocked-state (not has-blockers))
      (progn
        (org-entry-put pom "TODO" (if has-prev-state prev-state "TODO") )
        (org-entry-delete pom "STATE-BEFORE-BLOCKED"))
      )
     ((and (not in-blocked-state) has-blockers)
      (org-entry-put pom "STATE-BEFORE-BLOCKED" (org-entry-get pom "TODO"))
      (org-entry-put pom "TODO" "BLOCKED")
      )
     )

    )
  )

;; make org header at point a dependant on the header at point b
(defun create-dependency (pom_a pom_b)
  (let ((id_a (org-id-get pom_a t))
        (id_b (org-id-get pom_b t)))

    (progn
      (modify-property pom_a "BLOCKERS" (lambda (id_list) (-union id_list '(id_b))))
      (update-state-from-blocker-data pom_a)
      (modify-property pom_b "BLOCKING" (lambda (id_list) (-union id_list '(id_a))))
      )
    )
  )

(defun on-complete-update-downstream-deps (pom)

  ;; look up own id prop (let)
  ;; look up "blocking" prop list (let)

  ;; map over each blocked id:
  ;; * TODO find downstream task based on id
  ;;   - NEXT TODO research how the edna id finder works
  ;; * remove own id from BLOCKER prop list (difference)
  ;; * update state from blocker data (above func)

  )

(defun block-this-task-on-other (pom)
  (let ((other-task (ivy-find-todo org-dependency-targets))
	)
    (create-dependency pom other-task)
    )

  )

(defun block-other-task-on-this (pom)
  (let ((other-task (ivy-find-todo org-dependency-targets))
	)
    (create-dependency other-task pom)
    )
  )

(defun build-blocked-filter-string ()
  "+BLOCKER={^$}"
  )


;; TODO replace usages of "pom" with a "refile-pointer" type item (from org.el)
