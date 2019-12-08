
(use-package org-edna)


;;(setq +org-available-todo-keywords
;;      '("TODO"))
;;
;;
;;(setq +org-completed-todo-keywords
;;      '("DONE"))


(defun +org-deps-update-todo-keyword-for-availability (pom)
  
  (let ((todo-state (org-entry-get pom "TODO"))
	;;TODO extract actual list from blocker entry
	(blockers (org-entry-get pom "BLOCKER" )))

    
    )
  

  )


(defun +org-get-blockers-ids-list (pom)
  ;;TODO regex to extract blockers list
  ;;TODO use regex tester
  (org-entry-get pom "BLOCKER")

  )


(defun +org-deps-all-blockers-complete-p (pom)
  (all? (-map +org-id-todo-state-available-p (+org-get-blockers-list pom)))
  )

(defun +org-todo-state-available-p (pom)
  (memq (org-entry-get pom "TODO") +org-available-todo-keywords)
  )


(defun +org-id-todo-state-available-p (id)
  (+org-todo-state-available-p (org-id-find id))
  )
