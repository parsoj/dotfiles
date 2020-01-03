(setq python-bin "/usr/local/bin/python3")
(use-package python
  :init
  (setq python-shell-interpreter python-bin)
  )


(use-package lsp-python-ms
  :init
  (setq  lsp-python-ms-python-executable-cmd python-bin)
  )

(use-package virtualenvwrapper)

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
  (setq dap-python-executable python-bin)

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


;;(use-package pip-requirements
;;  :hook (pip-requirements-mode . pip-requirements-auto-complete-setup)
;;  )


;;(use-package py-isort)

;;(use-package yapfify
;;  :after python
;;  :hook (python-mode . yapf-mode)
;;  )

;;(use-package pylookup)
