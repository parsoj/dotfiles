;;; emacs/projects/config.el -*- lexical-binding: t; -*-


(def-package! projectile
  :init
  (setq
   projectile-project-search-path '("~/code/remitly/" "~/code/personal/")
   projectile-project-root-files-functions '(projectile-root-top-down)
   projectile-project-root-files '(".projectile" "NOTES.org")
   counsel-projectile-switch-project-action (lambda (project_root) (find-file (concat project_root "/NOTES.org")))
   )
  )

(def-package! org-projectile
  :config
  (org-projectile-per-project) ;; tell org-projectile that we are following the "file-per-project strategy"
  (setq
   org-projectile-per-project-filepath "PROJECT_NOTES.org"
   org-projectile-capture-template "* %?\n"
   )
  (push (org-projectile-project-todo-entry) org-capture-templates)

  )
