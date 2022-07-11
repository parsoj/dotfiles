;;; ../.config/emacs/doom-config/extras/workspaces/navigation.el -*- lexical-binding: t; -*-


(defun all-project-files ()
  (+f-files-max-depth (projectile-project-root) 5)
  )


(defun +eshell-switch-directory-in-project ()
  (interactive)

  (setq default-directory
        (expand-file-name
         (concat
          (completing-read "switch to directory:" (+f-directories-max-depth (projectile-project-root) 6))
          "/")))
 )
