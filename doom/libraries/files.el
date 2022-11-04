;;; libraries/files.el -*- lexical-binding: t; -*-


(defun ++browse-project ()
  "Browse files from the current project's root."
  (interactive) (doom-project-browse (doom-project-root)))
;; NOTE No need for find-in-project, use `projectile-find-file'

(defun ++browse-templates ()
  "Browse files from `+file-templates-dir'."
  (interactive) (doom-project-browse +file-templates-dir))

(defun ++find-in-templates ()
  "Find a file under `+file-templates-dir', recursively."
  (interactive) (doom-project-find-file +file-templates-dir))

(defun ++find-file-under-here ()
  "Perform a recursive file search from the current directory."
  (interactive)
  (doom-project-find-file default-directory))
