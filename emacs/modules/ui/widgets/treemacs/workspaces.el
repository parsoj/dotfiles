
(defun +treemacs-get-name-from-workspace-create-return (ret-val)
  (cl-struct-slot-value 'treemacs-workspace 'name (car (cdr ret-val)))
  )
