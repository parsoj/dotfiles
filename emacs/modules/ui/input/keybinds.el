;;; +keybinds.el --- main keybindings -*- lexical-binding: t; -*-

(use-package general
  :after +hydra +ivy +evil +icons

  :init
  (setq general-override-states '(insert
                                  emacs
                                  hybrid
                                  normal
                                  visual
                                  motion
                                  operator
                                  replace))

  :config
  (defvar hydra-config-actions--title (s-concat (all-the-icons-faicon "sliders" :v-adjust .05) " Configuration Actions" ))

  (pretty-hydra-define hydra-config-actions
                        ;(:color teal :quit-key "ESC" :title "boop")
                        (:color teal :title hydra-config-actions--title)
                        (
			 "Emacs Config"
                         (("M" create-new-module "new module")
                          ("m" jump-to-module "module")
                          ("s" jump-to-scratch-file "scratch file")
                          ("S" create-new-scratch-file "new scratch file")
                          ("i" (lambda() (interactive) (find-file (concat config-root "init.el") )) "init.el" )
                          ;;("j" (lambda() (interactive) (find-file (concat config-root "init.el") )) "init.el" ) ;;just adding a duplicate head since hydra-posframe is comming out too small
			  )
			 "Package Dependencies"
			 (("l" (lambda() (interactive) (find-file "~/.emacs.d/straight/versions/default.el") ) "packages lockfile")
			  ("p" jump-to-package "package code")
			  )

			  "Yabai"
			 (("y" (lambda() (interactive) (find-file "~/.yabairc")) "yabairc")
			  ("Y" (lambda() (interactive) (find-file "~/Dropbox/Code/docs/yabai.asciidoc" )) "yabai docs"))

			"OSX Keybinds"
			 (("k" (lambda() (interactive) (find-file "~/.skhdrc")) "skhdrc")
			  ("K" (lambda() (interactive) (find-file "~/Dropbox/Code/docs/yabai.asciidoc")) "skhd docs"))
			 )
			)


  (defvar hydra-org-actions--title (s-concat (all-the-icons-faicon "sliders" :v-adjust .05) " Org-Mode Actions" ))


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
   "ps" 'counsel-projectile-ag


   "ag" 'magit-status

   "'" '+eshell-pop-window

   "o" 'hydra-org-actions/body

   "ee" 'eval-last-sexp
   "eb" 'eval-buffer
   "eb" 'eval-region
   )

  ;;we want the ESC key to be able to quit/escape out of *anything*
  (general-define-key
   [remap evil-force-normal-state] 'keyboard-quit
  )

)


(provide '+keybinds)
;;; +keybinds.el ends here