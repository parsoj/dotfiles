(use-package eldoc
  :straight (eldoc :type built-in)
  :init
  (setq eldoc-documentation-function (lambda () (documentation (symbol-at-point))))
  (global-eldoc-mode -1)
)

(defun init-eldoc-box ()
  (progn
    (eldoc-box-hover-mode)
    (eldoc-box-hover-at-point-mode  )))

(use-package eldoc-box 
  :after eldoc
)
