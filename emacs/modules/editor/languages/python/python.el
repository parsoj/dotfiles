(use-package python
  :init
  (setq python-shell-interpreter "python3")
  )

;;(use-package pip-requirements
;;  :hook (pip-requirements-mode . pip-requirements-auto-complete-setup)
;;  )


;;(use-package py-isort)

;;(use-package yapfify
;;  :after python
;;  :hook (python-mode . yapf-mode)
;;  )

;;(use-package pylookup)

;;(with-eval-after-load 'general
;;  (general-add-hook 
;;   'python-mode-hook
;;   (list
;;    #'lsp-deferred
;;    #'flycheck-mode
;;    ))
;;  )

(use-package lsp-python-ms
  )

(with-eval-after-load 'general
  (general-add-hook 
   'python-mode-hook
   (list
    #'lsp-deferred
    #'fringe-mode
    ))

  (general-define-key
   :states '(normal visual emacs movement)
   :prefix "SPC"
   "dd" 'hydra-debug-actions/body
   )

  )

(with-eval-after-load 'dap-mode
  (setq dap-python-executable "python3")
  (require 'dap-python)



  )

;; EXAMPLE TEMPLATE
;; (dap-register-debug-template "Store Service Local"
;;			     (list
;;			      :name "Store Service Local"
;;			      :type "python"
;;			      :args "-i"
;;			      )
;;			     )


(add-to-list 'display-buffer-alist
	     `("*Python: .*"
	       (display-buffer-at-bottom)
	       (window-height . 20)
	       ))
