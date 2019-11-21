

(setenv "GOPATH" (concat (getenv "HOME") "/code/toolkits/go/") )  

(add-to-list 'exec-path  (concat (getenv "GOPATH") "bin/"))



(with-eval-after-load '+projectile

  (add-to-list 'projectile-project-root-files "go.mod")
	       
)


(with-eval-after-load '+lsp

  (defun go-mode-on-save-actions ()
    (lsp-format-buffer)
    (lsp-organize-imports)
    )

  (defun add-go-mode-on-save-hook ()
    (add-hook 'before-save-hook #'go-mode-on-save-actions nil t)
    )
)

(use-package go-mode
  :after +env +lsp +flycheck
  :hook (
	 (go-mode . lsp)
	 (go-mode . flycheck-mode)
	 (go-mode . company-mode)
	 (go-mode . add-go-mode-on-save-hook)
	 )
  :init

  (setq
   lsp-before-save-edits t
   lsp-enable-on-type-formatting t
   lsp-enable-indentation t
   lsp-enable-snippet t
   lsp-prefer-flymake nil
   )

)
  

(use-package go-eldoc
  :after go-mode
  :hook (go-mode . go-eldoc-setup)
  )

(use-package go-guru
  :after go-mode
  :hook (go-mode . go-guru-hl-identifier-mode)
  )


(use-package gorepl-mode
  :after go-mode
  :hook (go-mode . gorepl-mode)
  
 )

(use-package go-rename
  )
