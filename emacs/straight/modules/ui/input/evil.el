;;; evil.el -*- lexical-binding: t; -*-

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  )

(use-package evil-collection
  :after evil

  :custom
  (evil-collection-setup-minibuffer t)
  (evil-collection-setup-debugger-keys t)

  :config
  (evil-collection-init)
)

(provide '+evil)
