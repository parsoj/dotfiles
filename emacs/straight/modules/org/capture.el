(setq org-capture-templates
      '(
        ("i" "Inbox entry" entry
         (file +org-capture-todo-file)
         "* INBOX %?\n%i\n%a" :prepend t :kill-buffer t)

        ("p" "protocol quick-capture" entry
         (file +org-capture-todo-file)
         "* INBOX %a" :prepend t :kill-buffer t :immediate-finish t)
        )
      )

(setq +org-capture-frame-parameters
 '((name . "org-capture")
  (width . 70)
  (height . 25)
  (transient . t)
  (undecorated . t)
  ))

(setq +org-capture-todo-file "inbox/inbox.org"
      +org-capture-notes-file "inbox/inbox.org"
      )

(defun +org-capture|cleanup-frame ()
  "Closes the org-capture frame once done adding an entry."
  (when (+org-capture-frame-p)
    (delete-frame nil t)))

(defun +org-capture-frame-p (&rest _)
  "Return t if the current frame is an org-capture frame opened by
`+org-capture/open-frame'."
  (and (equal "org-capture" (frame-parameter nil 'name))
       (frame-parameter nil 'transient)))

(defun +org-capture/open-frame (&optional initial-input key)
  "Opens the org-capture window in a floating frame that cleans itself up once
you're done. This can be called from an external shell script."
  (interactive)
  (when (and initial-input (string-empty-p initial-input))
    (setq initial-input nil))
  (when (and key (string-empty-p key))
    (setq key nil))
  (let* ((frame-title-format "")
         (frame (if (+org-capture-frame-p)
                    (selected-frame)
                  (make-frame +org-capture-frame-parameters))))
    (with-selected-frame frame
      (require 'org-capture)
      (condition-case ex
          (cl-letf (((symbol-function #'pop-to-buffer)
                     (symbol-function #'switch-to-buffer)))
            (switch-to-buffer "*Messages*")
            (let ((org-capture-initial initial-input)
                  org-capture-entry)
              (when (and key (not (string-empty-p key)))
                (setq org-capture-entry (org-capture-select-template key)))
              (if (or org-capture-entry
                      (not (fboundp 'counsel-org-capture)))
                  (org-capture)
                (unwind-protect
                    (counsel-org-capture)
                  (if-let* ((buf (cl-loop for buf in (buffer-list)
                                          if (buffer-local-value 'org-capture-mode buf)
                                          return buf)))
                      (with-current-buffer buf
                        (add-hook 'kill-buffer-hook #'+org-capture|cleanup-frame nil t))
                    (delete-frame frame))))))
        ('error
         (message "org-capture: %s" (error-message-string ex))
         (delete-frame frame))))))
