
(defun org-notepad-pop-frame ()
  (interactive)
  
  (with-selected-frame (make-frame)
    (let ((file-name (read-string "Name for Note: ")))
      (find-file (concat "~/org/inbox/" "note_" file-name ".org"  ))
      ))
  
  )



