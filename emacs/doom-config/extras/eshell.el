;;; ../.config/emacs/doom-config/extras/eshell.el -*- lexical-binding: t; -*-


(defun +f-directories-max-depth (path max)
  (let* ((curr-depth (f-depth path))
         (max-depth (+ curr-depth max)))
    (f-directories path (lambda (dir) (<= (f-depth dir) max-depth )) t)
    )
  )





(defun +eshell-in-directory ()
  (interactive)
  (let ((default-directory (completing-read "Run eshell in project directory:" (+f-directories-max-depth (projectile-project-root) 10))))
    (+eshell/here)

    )
  )
