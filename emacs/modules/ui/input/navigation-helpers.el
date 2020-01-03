
(defun do-find-file-jump (message file-list)
  (interactive)
  (let ((path ( completing-read message file-list nil t) ))
    (find-file path)
    )
  )


(provide '+navigation-helpers)
