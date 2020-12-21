;;; ../.config/emacs/doom-config/extras/org/reminders-import.el -*- lexical-binding: t; -*-

;; Reminders Import Code
;; import reminders from OSX reminders app

(defun Reminders-accounts ()
  (mapcar (lambda (x) (split-string x "----"))
          (split-string (osa
                         "set AppleScript's text item delimiters to {\"----\"}
tell application \"Reminders\"
  set XX to {}
  repeat with A in accounts
    set {name:x1, id:x2} to properties of A
    if x2 is not missing value
      copy {x1, x2} as text to end of XX
    end if
  end repeat
  set AppleScript's text item delimiters to {\"####\"}
  return XX as text
end tell")
                        "####")))


(defun Reminders-lists (account)
  (mapcar (lambda (x) (split-string x "----"))
          (split-string (osa "\
set AppleScript's text item delimiters to {\"----\"}
tell application \"Reminders\"
  set XX to {}
  repeat with L in lists of account #{account}
    set {name:x1, id:x2} to L
    copy {x1, x2} as text to end of XX
  end repeat
  set AppleScript's text item delimiters to {\"####\"}
  return XX as text
end tell")
                        "####")

          )
  )


(defun Get-reminders (account list)

  (split-string (osa "\
tell application \"Reminders\"
	set XX to {}
	repeat with R in reminders of list #{list} of account #{account}
		if completed in R is false then
			copy name in R to end of XX
		end if
	end repeat
	set AppleScript's text item delimiters to {\"####\"}
	return XX as text
end tell") "####"))



(defun insert-inbox-heading (inbox-item-string)
  (progn
    (org-insert-heading)
    (insert "INBOX ")
    (insert inbox-item-string)
    )
  )


(defun insert-reminders-from-inbox ()
  (interactive)
  (mapcar #'insert-inbox-heading (Get-reminders "iCloud" "Inbox"))
  )

(defun clear-reminders-list (account list)
  (osa "\
tell application \"Reminders\"
	set completed of every reminder in list #{list} in account #{account} to true
end tell
")
  )


(defun clear-reminders-inbox ()
  (interactive)
  (clear-reminders-list "iCloud" "Inbox")
  )
