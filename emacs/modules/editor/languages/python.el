(use-package python
  )

(use-package anaconda-mode
  :hook ((python-mode . anaconda-mode)
	 (python-mode . anaconda-eldoc-mode))
  )

(use-package company-anaconda
  :after anaconda-mode company
  )

(use-package pip-requirements
  :hook (pip-requirements-mode . pip-requirements-auto-complete-setup)
  )


(with-eval-after-load 'general
  (general-add-hook 
   'python-mode-hook
   (list
    #'lsp-deferred
    #'lsp-ui
    #'flycheck-mode
    ))
  )

(use-package py-isort)


(use-package yapfify
  :after python
  :hook (python-mode . yapf-mode)
  )


(use-package pylookup)
