(use-package flycheck
:init 
;; we need to delay/debounce flycheck runs - its too expensive to run with post-command-hook
(setq flycheck-idle-change-delay 4) 
  )

;(use-package flycheck-posframe
;  :after flycheck
;  :hook (flycheck-mode . flycheck-posframe-mode)
;  :config
;  (flycheck-posframe-configure-pretty-defaults) 
;  )

(provide '+flycheck)
