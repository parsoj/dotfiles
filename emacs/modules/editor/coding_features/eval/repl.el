
(use-package eval-in-repl
  :init
  (setq
   eir-repl-placement 'below)
  :config

  (general-define-key
   :keymaps 'emacs-lisp-mode-map
   :states 'normal
   :prefix ","

   "ee" 'eir-eval-in-ielm

   )


  ;;TODO eval buffer func
  ;;TODO eval region func
  ;;TODO eval last sexp/block func
  ;;TODO eval enclosing/last func-def(defun) func
  )
