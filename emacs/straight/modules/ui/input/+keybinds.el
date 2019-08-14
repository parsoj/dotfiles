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
                          ("i" (lambda() (interactive) (find-file (concat config-root "init.el") )) "init.el")
                          )
                         )
                        )


   (general-define-key
    :states '(normal)
    :prefix "SPC"
    :non-normal-prefix "M-SPC"
    "c" 'hydra-config-actions/body
    "SPC" 'counsel-M-x
    "ff" 'find-file
    "fs" 'save-buffer

    "hf" 'describe-function
    "hv" 'describe-variable

    "tl" 'visual-line-mode

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

    )
  
)


(provide '+keybinds)
;;; +keybinds.el ends here
