
(use-package go-mode
  :after +env
  :hook (go-mode . lsp)

  :config
  (setenv "GOPATH" (concat (getenv "HOME") ".go/"))
  (add-to-exec-path (concat (getenv "GOPATH") "bin"))
  )

(use-package go-eldoc
  :hook (go-mode . go-eldoc-setup)
  )

(use-package go-guru
  :hook (go-mode . go-guru-hl-identifier-mode)
  )

