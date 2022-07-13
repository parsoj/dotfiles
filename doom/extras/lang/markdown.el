;;; extras/lang/markdown.el -*- lexical-binding: t; -*-

(add-hook 'markdown-mode-hook
          (lambda ()
            (progn (markdown-toggle-markup-hiding 1)
                   (+word-wrap-mode -1))))

;; (setq markdown-mode-hook nil)
