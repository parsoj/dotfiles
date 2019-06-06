;; -*- no-byte-compile: t; -*-
;;; lang/emacs-lisp/packages.el

(package! elisp-mode :built-in t)

(package! highlight-quoted)
(package! elisp-def)
(package! elisp-demos)
(package! company-quickhelp)
(package! popup)

(when (featurep! :tools flycheck)
  (package! flycheck-cask))
