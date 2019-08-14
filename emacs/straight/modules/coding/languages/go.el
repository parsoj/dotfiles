
(use-package go-mode
  :hook (go-mode . lsp))

(use-package go-eldoc
  :hook (go-mode . go-eldoc-setup)
  )

(use-package go-guru
  :hook (go-mode . go-guru-hl-identifier-mode)
  )


