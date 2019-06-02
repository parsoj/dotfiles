;;; emacs/projects/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +pop-to-project-todo-file ()
  (interactive)
  (+pop-to-indirect-buffer "*NOTES*"
                           (lambda () (find-file-noselect (concat (projectile-project-root) "/NOTES.org" ))))
  )

;;;###autoload
(defun +pop-to-indirect-buffer (buf_name fetch_func)
  (interactive)
  (pop-to-buffer
   (let ((existing-buffer (get-buffer buf_name)))
     (if existing-buffer
         existing-buffer
       (make-indirect-buffer
        (funcall fetch_func)
        buf_name
        t
        ))))
  )

;;;###autoload
(defun +run-commands-in-project-eshell-popup (command_list)
  ;; TODO special popup rules for this popup
  ;; TODO cleanup section separate from run section
  (interactive)
  (progn
    (pop-to-buffer (get-buffer-create
                    "*Project Run*"))
    (+eshell/open
     (projectile-project-root)
     (string-join
      command_list
      " && "
      )
     )

    )
  )
