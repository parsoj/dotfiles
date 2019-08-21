

(setenv "HOME" "/Users/jeff/")
(setenv "DOTFILES" (concat
		    (getenv "HOME")
		    "dotfiles/"))


(setenv "EDITOR" (concat
		  (getenv "DOTFILES")
		  "osx/scripts/emacs/client"))

(setenv "VISUAL" (concat (getenv "EDITOR")
			 " -c"))


(defun add-to-exec-path (&rest items)
  (progn
    (setq exec-path (append exec-path items ) ) 
    (setenv "PATH" (string-join exec-path ":") )))

(add-to-exec-path "/usr/local/opt/bin") 

(provide '+env)
