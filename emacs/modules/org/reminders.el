
(use-package 
  osascripts 
  :straight (:type git 
		   :host github 
		   :repo "leoliu/osascripts")
  :init

  (setq reminders-inbox-file "~/org/inbox/reminders.org")
  (setq reminders-account "iCloud")
  (setq reminders-inbox-list "Inbox")
  :config


  (defun +pull-reminders-inbox ()
    (interactive)
    (-map #'Reminders-insert-reminder (Reminders-reminders-1 "iCloud" "Inbox")
	  ))  




  )
