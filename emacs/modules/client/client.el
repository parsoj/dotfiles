
(defun eshell-client-frame ()
  (let ((default-directory "/Users/jeff"))
    (progn
      (x-focus-frame nil)
      (eshell)
      (evil-append 0) 
      )
    ) 
  ) 
