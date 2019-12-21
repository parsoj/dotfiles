
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

  (defun +open-repl ()
    ;; TODO open repl func
    )


  ;; NOTE
  ;; * eval-in-repl funcs should just grab a specific text object, and pass it to a generic func
  ;; * also need a separate set of funcs for lisps

  ;;NOTE
  ;; read into major & minor modes first

  (defun +eval-buffer-in-repl ()
    ;;TODO eval buffer func
    )

  (defun +eval-region-in-repl ()
    ;;TODO eval region func
    )

  (defun +eval-last-sexp/block ()
    ;;TODO eval last sexp/block func
    )

  ;;TODO eval enclosing/last func-def(defun) func
  )
