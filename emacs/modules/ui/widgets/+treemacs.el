;;; +treemacs.el -*- lexical-binding: t; -*-

(use-package treemacs
  :config
  (treemacs-follow-mode t)

  (setq treemacs-width 35
        treemacs-display-in-side-window t
        treemacs-indentation-string (propertize " " 'face 'font-lock-comment-face)
        treemacs-indentation 1)

  (add-hook 'treemacs-mode-hook (lambda ()
                                  (linum-mode -1)
                                  (fringe-mode 0)
                                  ;;(setq buffer-face-mode-face `(:background "#211C1C"))
                                  (buffer-face-mode 1)))
  )

(use-package treemacs-evil
  :after treemacs +evil
  )

(use-package treemacs-projectile
  :after treemacs
  )

(use-package treemacs-magit
  :after treemacs magit
  )




(provide '+treemacs)
;;; +treemacs.el ends here
