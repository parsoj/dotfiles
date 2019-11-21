
(with-eval-after-load '+hydra
  (with-eval-after-load 'ivy

  (setq hydra-help-actions--title (s-concat (all-the-icons-faicon "question" :v-adjust .025) " Help Actions" )) 

  (defvar +doc-at-point-func nil)

  (pretty-hydra-define hydra-help-actions
                        (:color teal :title hydra-help-actions--title)
                        (
			 "Describe"
                         (
			  ("h" (lambda () (interactive) (funcall +doc-at-point-func)))
			  ("a" counsel-apropos "apropos")
                          ("f" describe-function "function") ;; TODO move to function-at-point at some point
                          ("v" describe-variable "variable")
                          ("m" describe-mode "mode")
                          ("k" describe-key "key")
			  )
			)
			)


  (general-define-key
   :states '(normal visual emacs movement treemacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "h" 'hydra-help-actions/body
   )


;;  (add-to-list 'display-buffer-alist
;;	     `("*Help*"
;;	       ,(lambda (buffer alist) (display-buffer-in-direction buffer (cons '(direction . right) alist)))
;;	       (window-width . 0.33)
;;	       ))

)

)
