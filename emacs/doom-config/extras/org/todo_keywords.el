

(defun +localize-todo-keyword-vars ()
  (interactive)

  (progn
    (add-file-local-variable 'org-todo-keywords org-todo-keywords)
    (add-file-local-variable 'org-todo-keyword-faces org-todo-keyword-faces)
    )
  )
