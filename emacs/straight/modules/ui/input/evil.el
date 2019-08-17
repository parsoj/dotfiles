;;; evil.el -*- lexical-binding: t; -*-

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)

  :config
  (evil-mode 1)
  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)
  )


(use-package evil-matchit)

(provide '+evil)
