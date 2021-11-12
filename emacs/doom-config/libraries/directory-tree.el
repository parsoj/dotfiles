;;; ../.config/emacs/doom-config/libraries/directory-tree.el -*- lexical-binding: t; -*-


(defun +f-directories-max-depth (path max)
  (let* ((curr-depth (f-depth path))
         (max-depth (+ curr-depth max)))
    (f-directories path (lambda (dir) (<= (f-depth dir) max-depth )) t)
    )
  )


(defun +f-files-max-depth (path max)
  (
   let* ((curr-depth (f-depth path))
         (max-depth (+ curr-depth max)))
   (f-files path (lambda (dir) (<= (f-depth dir) max-depth )) t))
    )
