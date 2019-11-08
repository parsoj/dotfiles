
(defun eshell-client-frame ()
  (let ((default-directory home-dir))
    (progn
      (x-focus-frame nil)
      (eshell)
      (evil-append 0) 
      )
    )  
  ) 
