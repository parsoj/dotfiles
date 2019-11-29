(defun describe-function-in-popup () 
  (interactive) 
  (let* ((thing (symbol-at-point)) 
	 (description (save-window-excursion (describe-function thing) 
					     (switch-to-buffer "*Help*") 
					     (buffer-string)))) 
    (popup-tip description 
	       :point (point) 
	       :around t 
	       :height 30 
	       :scroll-bar t 
	       :margin t)))

(defun describe-function-in-pos-tip  (function) 
  "Display the full documentation of FUNCTION (a symbol) in tooltip." 
  (interactive (list (function-called-at-point))) 
  (if (null function) 
      (pos-tip-show "** You didn't specify a function! **" '("red")) 
    (pos-tip-show (with-temp-buffer (let ((standard-output (current-buffer)) 
					  (help-xref-following t)) 
				      (prin1 function) 
				      (princ " is ") 
				      (describe-function function) 
				      (buffer-string))) nil nil nil 0)))
(defun pos-tip-describe-function-at-point () 
  (interactive) 
  (let ((thing (symbol-at-point))) 
    (describe-function-in-pos-tip thing)))


(setq help-buffer-name
      "*posframe help buffer*")
(defun describe-function-doesnt-suck (funct) 
  (interactive (list (function-called-at-point))) 
  (let* ((funct funct) 
	 (description (save-window-excursion (describe-function funct) 
					     (switch-to-buffer "*Help*") 
					     (buffer-string))))


    ;;TODO make posframe temporary, or quick-escape-able
    ;;TODO put postframe in the top-right corner, or below cursor (just an out-of the way position)
    (posframe-show help-buffer-name 
		   :string description 
		   :width 70 
		   :height 30 
		   :timeout 8
		   :internal-border-width 1 
		   :internal-border-color "grey"

		   :poshandler (lambda (info)
				 (let* ((window-left (+ -10 (plist-get info :parent-window-left)))
					(window-bottom (+ 10 (plist-get info :parent-window-bottom)))
					(window-width (plist-get info :parent-window-width)) 
					(posframe-width (plist-get info :posframe-width))) 
				   (cons (+ window-left window-width (- 0 posframe-width))
					 window-bottom))))))



;;(if (get-buffer help-buffer-name) 
;;    (kill-buffer help-buffer-name )  )
;;
;;(describe-function-doesnt-suck 'posframe-show)
