(with-eval-after-load 'general
  (general-define-key
   "M-w" 'delete-frame
   )
  (general-define-key
   :states '(normal movement)
   "/" 'swiper
   )


  ;; TODO - this should be split into keymaps - that are referenced by major mode bindings  declared in other areas
  ;; eg - keymaps for org-mode should be controlled completely by the org config code, and that code should reference
  ;; more general keymaps like the stuff here
  (general-define-key
   :states '(normal visual emacs movement treemacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "c" 'hydra-config-actions/body
   "SPC" 'counsel-M-x
   "ff" 'find-file
   "fs" 'save-buffer

   ;;   "hf" 'counsel-describe-function
   ;;   "hv" 'counsel-describe-variable
   ;;   "hk" 'describe-key

   "tl" 'toggle-truncate-lines
   "tn" 'display-line-numbers-mode
   "tt" 'treemacs

   "wd" 'delete-window
   "ww"  'ace-window
   "wx" 'ace-swap-window
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
   "bs" '(lambda () (interactive) (pop-to-buffer "*scratch*"))

   "pf" 'counsel-projectile-find-file
   "pp" 'counsel-projectile-switch-project
   "pr" '(lambda () (interactive) (funcall run-project-func))
   "ps" 'counsel-projectile-rg
   "pt" '+treemacs-open-current-project

   "rt" '(lambda () (interactive) (funcall run-test-func))

   "ag" 'magit-status
   "aa" 'org-agenda

   "'" '+eshell-pop-window

   "ee" 'eval-last-sexp
   "ep" 'eval-print-last-sexp
   "eb" 'eval-buffer
   "er" 'eval-region
   "ed" 'eval-defun

   "sd" '(lambda () (interactive) (counsel-rg nil default-directory))

   "fd" '+delete-file-and-buffer
   "fr" '+rename-file-and-buffer
   )

  ;;we want the ESC key to be able to quit/escape out of *anything*
  (general-define-key
   [remap evil-force-normal-state] 'keyboard-quit
   )
  )


(provide '+bindings) 
