


(use-package js2-mode
  :mode "\\.m?js\\'"
  :config
  (setq js-chain-indent t
        ;; Don't mishighlight shebang lines
        js2-skip-preprocessor-directives t
        ;; let flycheck handle this
        js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil
        ;; Flycheck provides these features, so disable them: conflicting with
        ;; the eslint settings.
        js2-strict-trailing-comma-warning nil
        js2-strict-missing-semi-warning nil
        ;; maximum fontification
        js2-highlight-level 3
        js2-highlight-external-variables t
        js2-idle-timer-delay 0.1)

  (add-hook 'js2-mode-hook #'rainbow-delimiters-mode)

  )


;; Tools
(use-package eslintd-fix
  :hook (js2-mode . eslintd-fix)
  )
(use-package js2-refactor
  :hook (js2-mode . js2-refactor-mode)
  )
(use-package npm-mode
  :hook (js2-mode  . npm-mode)
  )

;; Eval
(use-package nodejs-repl)
(use-package skewer-mode
  :hook (js2-mode . skewer-mode)
  ;;run-skewer to attach a browser to emacs
  )
