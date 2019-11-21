

(with-eval-after-load 'general

(defvar +nav-goto-def-func nil)

(general-define-key
 :states '(normal visual emacs movement treemacs)
 :prefix "SPC"
 :non-normal-prefix "M-SPC"
 "gd" '(lambda () (interactive) (funcall +nav-goto-def-func))

 )
)

