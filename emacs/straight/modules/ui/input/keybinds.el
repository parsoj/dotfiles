;;; +keybinds.el --- main keybindings -*- lexical-binding: t; -*-

(use-package general
  :after +hydra +ivy +evil

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
  (pretty-hydra-define hydra-config-actions
                        (:color teal :quit-key "ESC" :title "Configuration Actions")
                        ("Jump to:"
                         (
			  ("M" create-new-module "new module")
                          ("m" jump-to-module "module")
                          ("d" jump-to-doom-module "doom-module")
                          ("i" (lambda() (interactive) (find-file (concat config-root "init.el") )) "init.el")
                          )
                         )
                        )


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

    "tl" 'toggle-truncate-lines
    "tn" 'display-line-numbers-mode
    "tt" 'treemacs

    "wd"   'delete-window
    "wx"   'ace-swap-window
    "wu" 'winner-undo
    "wr" 'winner-redo
    "wm" 'doom/window-maximize-buffer
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
    "pt" '(lambda () (interactive) (funcall project-test-func))
    "ps" 'counsel-projectile-ag

    )

)


(provide '+keybinds)
;;; +keybinds.el ends here
