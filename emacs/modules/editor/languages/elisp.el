

(use-package 
  elisp-slime-nav 
  :hook ((emacs-lisp-mode . elisp-slime-nav-mode) ) 
  :config (setq +nav-goto-def-func (lambda () 
				     (elisp-slime-nav-find-elisp-thing-at-point (symbol-name
										 (symbol-at-point))))) 
  (setq +doc-at-point-func (lambda () 
			     (elisp-slime-nav-describe-elisp-thing-at-point (symbol-name
									     (symbol-at-point))))))

(use-package 
  elisp-format)

(use-package 
  highlight-quoted 
  :hook ((emacs-lisp-mode . highlight-quoted-mode)))


(with-eval-after-load 'general
  (general-add-hook emacs-lisp-mode-hook
		    (list #'company-mode
			  #'rainbow-delimiters-mode
			  #'highlight-symbol-mode
			  #'flycheck-mode
			  #'hasklig-mode
			  #'lisp-butt-mode
			  (lambda () (lispy-mode 1))))


  )

(setq +doc-at-point-func 'describe-function-in-popup) 

(provide '+elisp)
