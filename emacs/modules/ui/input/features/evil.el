;;; evil.el -*- lexical-binding: t; -*-

(setq evil-want-keybinding nil)
(use-package evil
  :init
  ;;(setq evil-want-integration t)
  (setq evil-want-keybinding nil)

  :config
  (evil-mode 1)
  )

(use-package evil-collection
  :after evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-collection-init)
  )


(use-package evil-matchit)

(provide '+evil)
