
(defun +org-capture-todo-file () 
  "Expand `+org-capture-todo-file' from `org-directory'.
If it is an absolute path return `+org-capture-todo-file' verbatim."
  (expand-file-name +org-capture-todo-file org-root))

(setq org-capture-templates '(("i" "Inbox entry" entry (file org-inbox-file) "* %?\n%i\n" 
			       :prepend t 
			       :kill-buffer t)
			      ("w" "web link capture" entry (file org-inbox-file) "* WEBCAP %a" 
			       :prepend t 
			       :kill-buffer t 
			       :immediate-finish t)))

(setq +org-capture-frame-parameters '(
				      ;(undecorated . t)
				      (name . "org-capture") 
				      (width . 70) 
				      (height . 25) 
				      (transient . t) 
				      ))

(setq org-root "~/org/")
(setq org-inbox-file (concat org-root "inbox/inbox.org"))


;;NOTE: we can just use the normal 'org-capture' func with the 'keys' param to pre-select a capture template
(defun org-capture-pop-frame (&optional initial-input key) 
  (interactive) 
  (with-selected-frame (make-frame +org-capture-frame-parameters)
    (org-capture nil "i")
    (evil-insert-state)
    (delete-other-windows)
    (x-focus-frame nil)
    )) 
    
(add-hook 'org-capture-after-finalize-hook 'org-capture-cleanup-frame)

(defun org-capture-cleanup-frame ()
  "Closes the org-capture frame once done adding an entry."
  (when (org-capture-frame-p)
    (delete-frame nil t)))

(defun org-capture-frame-p (&rest _)
  "Return t if the current frame is an org-capture frame opened by
`+org-capture/open-frame'."
  (and (equal "org-capture" (frame-parameter nil 'name))
       (frame-parameter nil 'transient)))
