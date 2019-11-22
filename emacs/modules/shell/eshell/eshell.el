(use-package eshell 
  :config (add-hook 'eshell-mode-hook (lambda () 
					(general-define-key :keymaps 'eshell-mode-map 
							    :states '(insert) 
							    "<up>" 'eshell-previous-input 
							    "<down>" 'eshell-next-input) ))
)


;;;###autoload
(defun +eshell-run-command (command &optional buffer)
  (interactive)
  (let ((buffer
         (or buffer
             (if (eq major-mode 'eshell-mode)
                 (current-buffer)
               (cl-find-if #'buffer-live-p (+eshell-buffers))))))
    (unless buffer
      (user-error "No living eshell buffers available"))
    (unless (buffer-live-p buffer)
      (user-error "Cannot operate on a dead buffer"))
    (with-current-buffer buffer
      (goto-char eshell-last-output-end)
      (goto-char (line-end-position))
      (insert command)
      (eshell-send-input nil t))))


(defun +eshell-pop-window (&optional command bufname)
  (interactive)
  (let ((eshell-buffer (+eshell-get-create-buffer bufname)))
    (pop-to-buffer eshell-buffer)
    (if command
	(+eshell-run-command command))
    (+eshell-goto-next-prompt-insert)
    )
  )

(defun +eshell-switch-to-window (&optional command bufname)
  (interactive)
  (let ((eshell-buffer (+eshell-get-create-buffer bufname)))
    (switch-to-buffer eshell-buffer)
    (if command
	(+eshell-run-command command))
    (+eshell-goto-next-prompt-insert)
    )
  )

     

(add-to-list 'display-buffer-alist
	     `("*eshell*"
	       (display-buffer-at-bottom)
	       (window-height . 20)
	       ))


(defun +eshell-goto-next-prompt-insert ()
  (progn
    (evil-collection-eshell-next-prompt)
    (evil-append 0)
  )
  )

(defun +eshell-get-create-buffer (&optional bufname)
  (let* ((bufname (if bufname bufname "*eshell*"))
	 (buf (get-buffer-create bufname)))
    (with-current-buffer buf 
    (unless (equal major-mode 'eshell-mode)
      (erase-buffer)
      (eshell-mode)
	    )

    buf
    )))


(with-eval-after-load '+evil
(with-eval-after-load 'general

  (general-define-key
   :states '(normal movement)
   :prefix ","
   "h" 'counsel-esh-history
   )

  (evil-collection-eshell-setup)
  (evil-collection-eshell-next-prompt-on-insert)

  )
)
