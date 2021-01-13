;;; ../.config/emacs/doom-config/scratch/reminders-import.el -*- lexical-binding: t; -*-



(Get-reminders "iCloud" "Inbox")

(split-string (osa "\
tell application \"Reminders\"
	set XX to {}
	repeat with R in reminders of list \"Inbox\" of account \"iCloud\"
		if completed in R is false then
			copy name in R to end of XX
		end if
	end repeat
	return XX as text
end tell")

              "####")


(osa "display dialog \"butt\" ")


(Reminders-accounts)



(Reminders-lists "iCloud")
