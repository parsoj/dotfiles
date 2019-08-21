

(defun add-to-exec-path (&rest items)
  (progn
    (setq exec-path (append exec-path items ) ) 
    (setenv "PATH" (string-join exec-path ":") )))

(add-to-exec-path "/usr/local/opt/bin") 

(provide '+env)
