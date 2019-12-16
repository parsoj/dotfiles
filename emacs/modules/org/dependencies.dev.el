
(use-package org-edna)



(defun +org-deps-update-todo-keyword-for-availability (pom)
  
  (let ((todo-state (org-entry-get pom "TODO"))
	;;FIXME extract actual list from blocker entry
	(blockers (org-entry-get pom "BLOCKER" )))
    ))

(defun +org-get-blocker-ids (pom)
  (read (substring  (org-entry-get pom "BLOCKER") 2)) 
  )

(defun +org-deps-all-blockers-complete-p (pom)
  (--map (+org-todo-state-done-p (org-id-find it)) (+org-get-blocker-ids pom)) 
  )

(org-id-find  "85E3018F-BD08-448D-BAB4-E4E9F0D42375")

(defun +org-id-todo-state-available-p (id)
  (+org-todo-state-available-p (org-id-find id))
  )


;; TODO investigate -
;; does org.el already have a concept of "Done states" - and should we just be using/referencing those? 
