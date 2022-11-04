;;; keybinds/modes/eshell.el -*- lexical-binding: t; -*-

(map! :map eshell-mode-map
      (:localleader
       :desc "history" "h" #'counsel-esh-history)
      )
