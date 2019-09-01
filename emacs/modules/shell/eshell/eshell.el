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


(defun +eshell-pop-window (&optional command)
  (interactive)
  (let ((eshell-buffer (get-buffer-create "*eshell-popup*")))
    (pop-to-buffer eshell-buffer)
    (eshell-mode)
    (if command
	(+eshell-run-command command))))
     

(add-to-list 'display-buffer-alist
	     `("*eshell-popup*"
	       (display-buffer-at-bottom)
	       (window-height . 20)
	       ))
