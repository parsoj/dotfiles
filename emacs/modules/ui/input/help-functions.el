
(with-eval-after-load '+hydra
  (with-eval-after-load 'ivy

  (setq hydra-help-actions--title (s-concat (all-the-icons-faicon "question" :v-adjust .025) " Help Actions" )) 

  (pretty-hydra-define hydra-help-actions
                        (:color teal :title hydra-help-actions--title)
                        (
			 "Describe"
                         (
			  ("h" counsel-apropos "apropos")
                          ("f" describe-function "function") ;; TODO move to function-at-point at some point
                          ("v" describe-variable "variable")
                          ("m" describe-mode "mode")
			  )
			)
			)


  (general-define-key
   :states '(normal visual emacs movement treemacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "h" 'hydra-help-actions/body
   )
)

)
