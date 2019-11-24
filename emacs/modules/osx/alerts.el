
(use-package alert
  :config 
  (defun eshell-command-alert (process status)
    "Send `alert' with severity based on STATUS when PROCESS finished."
    (let* ((cmd (process-command process))
	   (buffer (process-buffer process))
	   (msg (format "%s: %s" (mapconcat 'identity cmd " ")  status)))
      (if (string-prefix-p "finished" status)
	  (alert msg :buffer buffer :severity  'normal)
	(alert msg :buffer buffer :severity 'urgent))))

  (add-hook 'eshell-kill-hook #'eshell-command-alert)

  (alert-add-rule :status   '(buried)     ;only send alert when buffer not visible
		  :mode     'eshell-mode
		  :style 'osx-notifier)
  )

