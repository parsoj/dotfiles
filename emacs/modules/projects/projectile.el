;;
;;(use-package projectile
  ;;:init
;;;  (load (concat config-root "~/.emacs.d/local-settings/projects.el"))
  ;;(setq
   ;;projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o" ".swp")
   ;;projectile-project-root-files-top-down-recurring '("todo.org")
   ;;projectile-project-root-files-functions '(projectile-root-top-down-recurring)
   ;;projectile-enable-caching 1
   ;;projectile-project-search-path '("~/code/")
   ;;)
;;
  ;;:config
  ;;(projectile-discover-projects-in-search-path)
  ;;(projectile-global-mode)
;;)
;;
(use-package projectile
  :init
  (setq
   projectile-globally-ignored-files '("~" ".swp") 
   projectile-project-search-path '("~/code/remitly" "~/code/archived/")
   projectile-project-root-files-functions '(projectile-root-top-down)
   projectile-enable-caching 1
   )
  :config
  (projectile-global-mode)
  )
