






(defun run-project-func ()
  ;;  (posframe-show "Help Popup" :string (documentation (symbol-at-point)) :position (point) :height 40 :width 80)
  (progn 
    (defvar help-popup-buffer "*Help Popup Buffer*") 
    (let ((sym (symbol-at-point)) 
	  (buf (get-buffer-create help-popup-buffer))) 

      (posframe-show buf
		     :string (documentation sym)
		     :poshandler 'posframe-poshandler-window-top-right-corner
		     :x-pixel-offset -20
		     :y-pixel-offset -20
		     :height (/ (frame-height) 4)
		     :width (/ (frame-width) 3)

      ) 
      )
    )) 



(posframe-show
(with-temp-buffer
  (let ((standard-output (current-buffer))
	(help-xref-following t))

    (describe-function-1 use-package) 
    (buffer-string))))
    


(describe-function-2 "use-package") 

(help-fns--signature 'use-package) 

;;TODO check help-fns file for more usages for doc strings and stuff



(setq three-step-help t) 

(use-package foo)
(symbol-plist 'use-package) 

(elisp-get-fnsym-args-string 'use-package) 
eldoc-highlight-function-argument
