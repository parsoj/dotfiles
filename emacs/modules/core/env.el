

(defun add-to-exec-path (&rest items)
  (progn
    (setq exec-path (append items exec-path ) ) 
    (setenv "PATH" (string-join exec-path ":") )))

(add-to-exec-path "/usr/local/opt/bin") 
(add-to-exec-path "/usr/local/bin") 

(provide '+env)
