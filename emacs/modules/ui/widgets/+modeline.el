;;; +modeline.el -*- lexical-binding: t; -*-

(use-package doom-modeline
  :after (all-the-icons doom-themes)
  :config
  :hook (after-init . doom-modeline-mode)
  :init
  (setq
   doom-modeline-height 1
   )
  (set-face-attribute 'mode-line nil :height 130)
  (set-face-attribute 'mode-line-inactive nil :height 130)

  (setq
   doom-modeline-bar-width 3
   doom-modeline-minor-modes nil
   doom-modeline-buffer-file-name-style 'truncate-upto-project
   doom-modeline-icon t
   doom-modeline-major-mode-icon t
   doom-modeline-major-mode-color-icon t
   doom-modeline-buffer-state-icon t
   doom-modeline-buffer-modification-icon t
   doom-modeline-buffer-encoding t
   doom-modeline-lsp t
   doom-modeline-env-version t
   )
  

  (setq doom-modeline-env-enable-python t
	doom-modeline-env-python-executable "python")

  (setq doom-modeline-env-enable-ruby t
	doom-modeline-env-ruby-executable "ruby")

  (setq doom-modeline-env-enable-go t
	doom-modeline-env-go-executable "go")
  :config
  
  (add-hook 'doom-modeline-mode-hook #'column-number-mode)   ; cursor column in modeline
  )


(provide '+modeline)
;;; +modeline.el ends here
