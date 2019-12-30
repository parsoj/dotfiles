(with-eval-after-load 'doom-themes
  (with-eval-after-load 'org

    (setq org-todo-keyword-faces `(
				   ("PROJECT" . ,(doom-color 'violet))
				   ("TODO" . ,(doom-color 'yellow))
				   ("DONE" . ,(doom-color 'grey))
				   ("CANCELLED" . ,(doom-color 'grey))
				   )

	  org-todo-keywords '(
                              (sequence "TODO(t)" "NEXT(n)" "BLOCKED(b)" "WAITING(w)" "|" "CANCELLED(c)" "DONE(d!)" )
                              (sequence "PROJECT(p)" "|" "PROJECT-COMPLETED(P)")
                              ))


    (setq org-actionable-keywords '("TODO" "NEXT"))
    (setq org-done-keywords '("DONE"))

    (defun +org-todo-state-actionable-p (keyword-string)
      (memq keyword-string org-actionable-keywords)
      )

    (defun +org-todo-state-done-p (keyword-string)
      (memq keyword-string org-done-keywords)
      )

    ))
