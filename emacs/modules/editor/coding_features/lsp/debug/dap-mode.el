
(use-package dap-mode
  :init
  (setq dap-auto-show-output nil)
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  )

(add-to-list 'display-buffer-alist
	     `(".*server log.*"
	       (display-buffer-at-bottom)
	       (window-height . 20)
	       ))


