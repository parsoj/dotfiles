;;; +keybinds.el --- main keybindings -*- lexical-binding: t; -*-


(defun jump-to-module ()
  (interactive)
  (let ((module-path (completing-read
                      "Jump To Module: "
                      (get-modules-list)
                      nil t)))
    (find-file module-path)
    )

  )

(defun jump-to-doom-module ()
  (interactive)
  (let ((module-path (completing-read
                      "Jump Doom To Module File: "
                      (get-doom-modules-list)
                      nil t)))
    (find-file module-path)
    )

  )

(defun create-new-module ()
  (interactive)
  (let ((module-dir (completing-read
		      "Pick Directory to create in: "
		      (get-modules-directories)
		      nil t)))

    (counsel-file-jump nil module-dir)
    ;; TODO load list of directories, and prompt for parent dir for new module
    ;; TODO ask for file/path name from that starting point
    ;; TODO create new file there and open it
    )
)

(use-package-require-after-load
 '(general +hydra +ivy)
 (progn
   (pretty-hydra-define hydra-config-actions
                        (:color teal :quit-key "ESC" :title "Configuration Actions")
                        ("Jump to:"
                         (
			  ("M" create-new-module "new module")
                          ("m" jump-to-module "module")
			  ("d" jump-to-doom-module "doom module")
                          ("i" (lambda() (interactive) (find-file (concat config-root "init.el") )) "init.el")
			  ("r" load-all-config-files "reload config")
                          )
                         )
                        )
   (general-define-key
    [escape] 'keyboard-escape-quit
    )

   (general-define-key
    :states '(normal)
    :prefix "SPC"
    :non-normal-prefix "M-SPC"
    "c" 'hydra-config-actions/body
    "SPC" '(lambda () (interactive) (counsel-M-x ""))
    "ff" 'find-file
    "fs" 'save-buffer
    "hf" 'describe-function
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
    "bb" '+ivy/switch-buffer
    "bp" 'previous-buffer
    "bn" 'next-buffer


    )
 )
)

(provide '+keybinds)
;;; +keybinds.el ends here
