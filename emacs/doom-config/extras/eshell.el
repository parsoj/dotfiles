;;; ../.config/emacs/doom-config/extras/eshell.el -*- lexical-binding: t; -*-


(defun +f-directories-max-depth (path max)
  (let* ((curr-depth (f-depth path))
         (max-depth (+ curr-depth max)))
    (f-directories path (lambda (dir) (<= (f-depth dir) max-depth )) t)
    )
  )



(defun +eshell-switch-directory-in-project ()
  (interactive)

  (setq default-directory
        (expand-file-name
         (concat
          (completing-read "switch to directory:" (+f-directories-max-depth (projectile-project-root) 6))
          "/")))
 )
