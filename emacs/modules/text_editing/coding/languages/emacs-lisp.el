

(use-package elisp-slime-nav
  :hook ((emcas-lisp-mode . elisp-slime-nav-mode)
	 (emacs-lisp-mode . company-mode)
	 (emacs-lisp-mode . rainbow-delimiters-mode)
	 (emacs-lisp-mode . highlight-symbol-mode)
	 (emacs-lisp-mode . flycheck-mode))
)

(use-package elisp-format)

(use-package highlight-quoted
  :hook ((emacs-lisp-mode . highlight-quoted-mode))
)
