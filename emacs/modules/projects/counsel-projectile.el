(use-package counsel-projectile
  :after projectile
  :config
  (setq
   counsel-projectile-switch-project-action (lambda (project_root) (find-file (concat project_root "PROJECT_NOTES.org")))
   )

  )
