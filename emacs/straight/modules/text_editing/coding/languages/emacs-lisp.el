
(use-package elisp-format)

(use-package highlight-quoted
  :hook ((emacs-lisp-mode . highlight-quoted-mode)
	 (emacs-lisp-mode . rainbow-delimiters-mode)
	 (emacs-lisp-mode . highlight-symbol-mode)
	 (emacs-lisp-mode . flycheck-mode))
  )
