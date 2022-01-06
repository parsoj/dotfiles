;;; ../.config/emacs/doom-config/extras/lang/go.el -*- lexical-binding: t; -*-

(set-lookup-handlers! 'go-mode
  :definition #'lsp-ui-peek-find-definitions
  :references #'lsp-ui-peek-find-references
  )


(add-hook! go-mode #'aggressive-indent-mode)
