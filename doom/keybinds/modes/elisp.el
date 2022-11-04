;;; keybinds/modes/elisp.el -*- lexical-binding: t; -*-

(map! :map emacs-lisp-mode-map
      (:localleader
       :desc "eval-print" "e p" #'eval-print-last-sexp)
      )
