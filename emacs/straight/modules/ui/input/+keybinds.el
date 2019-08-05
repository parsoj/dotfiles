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

(defun create-new-module ()
    ;; TODO load list of directories, and prompt for parent dir for new module
    ;; TODO ask for file/path name from that starting point
    ;; TODO create new file there and open it
    )

;; (defhydra hydra-config-actions nil
;;   "Configuration Actions"
;;   ("m" jump-to-module "jump to module")
;;   ("i" '(find-file (concat config-root "init.el")) "jump to init.el")
;;   )

(with-eval-after-packages (hydra major-mode-hydra general)
 (pretty-hydra-define hydra-config-actions
                      (:color teal :quit-key "q" :title "Configuration Actions")
                      ("Jump to:"
                       (
                        ("m" jump-to-module "module")
                        ("i" '(find-file (concat config-root "init.el")) "init.el")
                        )
                       )
                      )

 (general-define-key
  :states 'normal
  :prefix "SPC"
  "c" 'hydra-config-actions/body

  ))

(provide '+keybinds)
;;; +keybinds.el ends here
