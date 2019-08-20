(defun pop-eshell () 
  (interactive)
  (let ((eshell-buffer (get-buffer-create "*eshell popup*")))

    )
)


(defun boof ()
  (add-to-list 'display-buffer-alist '("*eshell popup*"
				       (display-buffer-reuse-window
					display-buffer-at-bottom) 
				       (window-height . 20))))
