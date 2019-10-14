

(use-package elisp-slime-nav 
  :hook ((emcas-lisp-mode . elisp-slime-nav-mode) ))

(use-package elisp-format
  )

(use-package 
  highlight-quoted 
  :hook ((emacs-lisp-mode . highlight-quoted-mode)))

(use-package emacs-lisp-mode
  :straight (:type built-in)
  :hook
    ((emacs-lisp-mode . company-mode) 
    (emacs-lisp-mode . rainbow-delimiters-mode) 
    (emacs-lisp-mode . highlight-symbol-mode) 
    (emacs-lisp-mode . flycheck-mode)
    (emacs-lisp . lispy-mode)
    (ielm-mode . company-mode))

  )
  
