(use-package projectile
  :init
  (setq
   projectile-globally-ignored-files '("~" ".swp") 
   projectile-project-search-path '("~/code/projects" "~/code/reference-code/")
   projectile-project-root-files-functions '(projectile-root-top-down)
   projectile-enable-caching 1
   )
  :config
  (projectile-global-mode)
  )
