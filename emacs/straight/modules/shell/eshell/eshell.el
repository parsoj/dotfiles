(use-package eshell 
  :config (add-hook 'eshell-mode-hook (lambda () 
					(general-define-key :keymaps 'eshell-mode-map 
							    :states '(insert) 
							    "<up>" 'eshell-previous-input 
							    "<down>" 'eshell-next-input) ))
)
