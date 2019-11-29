


(defun +pull-reminders-inbox ()
  (interactive)
  (-map #'Reminders-insert-reminder (Reminders-reminders-1 "iCloud" "Inbox")
	))  



