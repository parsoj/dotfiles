;;; ../.config/emacs/doom-config/extras/keybinds.el -*- lexical-binding: t; -*-


(setq os-config-files '("~/.skhdrc" "~/.yabairc" "~/.zshrc"))

(defun jump-to-os-config-file ()
  (interactive)
  (let ((jump-destination (completing-read "Jump to OS config file:" os-config-files)))
    (find-file (expand-file-name jump-destination))
    )
  )

(map! :leader
      (:prefix-map ("f". "file")
       :desc "Open OS config file"  "o"   #'jump-to-os-config-file
       ))
