;;; ../.config/emacs/doom-config/extras/keybinds.el -*- lexical-binding: t; -*-


(setq os-config-files '("~/.skhdrc" "~/.yabairc" "~/.zshrc" "~/.zshenv"))

(defun jump-to-os-config-file ()
  (interactive)
  (let ((jump-destination (completing-read "Jump to OS config file:" os-config-files)))
    (find-file (expand-file-name jump-destination))
    )
  )


(setq scratch-dir (expand-file-name (concat doom-private-dir "scratch")))


(map! :leader
      (:prefix-map ("f". "file")
       :desc "Open OS config file"  "o"   #'jump-to-os-config-file
       :desc "Open elisp scratch file" "z" (lambda! () (doom-project-find-file scratch-dir))
       ))
