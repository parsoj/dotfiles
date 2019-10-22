;; Auto-Dark-Emacs is an auto changer between 2 themes, dark/light, respecting the
;; overall settings of MacOS

;; Set your themes here
(set 'darktheme 'wombat)
(set 'lightheme 'leuven)

(set 'thebeforestate "initial") 

(run-with-timer 0 1 (lambda ()			   
			   ;; Get's MacOS dark mode state
			   (if (string= (shell-command-to-string "printf %s \"$( osascript -e \'tell application \"System Events\" to tell appearance preferences to return dark mode\' )\"") "true")
			       (progn
				 (set 'thenowstate t)
				 )
			     (set 'thenowstate nil)
			     )

			   ;; Verifies if Darkmode is changed since last checked
			   (if (string= thenowstate thebeforestate)
			       ;; If nothing is changed
			       (progn

				 )
			     ;; If something is changed

			     (if (string= thenowstate "t")
				 (progn
				   (load-theme darktheme t)
				   (disable-theme lightheme)
				   )
			       (load-theme lightheme t)
			       (disable-theme darktheme) 
			       )
			     )
			   (set 'thebeforestate thenowstate)
			   )
		     )

(defvar emacs-dark-mode-p 't)

(defvar dark-mode-theme 'doom-one)
(defvar light-mode-theme 'doom-nord-light) 

(defun osx-dark-mode-p ()
    (string= (shell-command-to-string "printf %s \"$( osascript -e \'tell application \"System Events\" to tell appearance preferences to return dark mode\' )\"") "true") 
  )


(defun set-emacs-dark-mode (is-dark-mode)
    (unless
	(eq is-dark-mode emacs-dark-mode-p) 
      (if is-dark-mode
	  (load-theme dark-mode-theme 't) 
	(load-theme light-mode-theme 't) 
	)
      (setq emacs-dark-mode-p (not emacs-dark-mode-p) )  
      (solaire-mode-swap-bg)
    )
)

(defun set-osx-dark-mode (dark-mode-p)
  (do-applescript
   (concat
"
tell application \"System Events\"
	tell appearance preferences
		set dark mode to " (if dark-mode-p "true" "false")
"
	end tell
end tell
") 
   )
  ) 

(defun set-emacs-dark-mode-from-osx ()
  (set-emacs-dark-mode (osx-is-dark-mode))
  )

(set-osx-dark-mode nil) 
(set-osx-dark-mode 't)  

(set-emacs-dark-mode-from-osx) 
