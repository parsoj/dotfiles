(with-eval-after-load 'general
  (general-define-key
   "M-w" 'delete-frame
   )
  (general-define-key
   :states '(normal movement)
   "/" 'swiper
   )


   
  (general-define-key
   :states '(normal visual emacs movement treemacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "c" 'hydra-config-actions/body
   "SPC" 'counsel-M-x
   "ff" 'find-file
   "fs" 'save-buffer

   "hf" 'counsel-describe-function
   "hv" 'counsel-describe-variable
   "hk" 'describe-key

   "tl" 'toggle-truncate-lines
   "tn" 'display-line-numbers-mode
   "tt" 'treemacs

   "wd"   'delete-window
   "wx"   'ace-swap-window
   "wu" 'winner-undo
   "wr" 'winner-redo
   "wm" 'delete-other-windows
   "ws" 'split-window-vertically
   "wv" 'split-window-horizontally
   "wh" 'evil-window-left
   "wl" 'evil-window-right
   "wk" 'evil-window-up
   "wj" 'evil-window-down

   "bd" 'evil-delete-buffer
   "br" 'revert-buffer
   "bb" 'counsel-switch-buffer
   "bp" 'previous-buffer
   "bn" 'next-buffer

   "pf" 'counsel-projectile-find-file
   "pp" 'counsel-projectile-switch-project
   "pr" '(lambda () (interactive) (funcall run-project-func))
   "ps" 'counsel-projectile-rg


   "ag" 'magit-status

   "'" '+eshell-pop-window

   "o" 'hydra-org-actions/body

   "ee" 'eval-last-sexp
   "ep" 'eval-print-last-sexp
   "eb" 'eval-buffer
   "eb" 'eval-region
   )

  ;;we want the ESC key to be able to quit/escape out of *anything*
  (general-define-key
   [remap evil-force-normal-state] 'keyboard-quit
  )
  )


(provide '+bindings) 
