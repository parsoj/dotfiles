

(defun +localize-todo-keyword-vars ()
  (interactive)

  (progn
    (add-file-local-variable 'org-todo-keywords org-todo-keywords)
    (add-file-local-variable 'org-todo-keyword-faces org-todo-keyword-faces)
    )
  )

  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "STUBBED(s)" "IMPLEMENTED(i)" "|" "DONE(d)" "CANCELLED(c)")
                           (sequence "WAIT(w)" "LOWPRIO(l)")))
  ;; (setq org-todo-keyword-faces `(("TODO" . "#FD9446" )
  ;;                                 ("NEXT" . "#F4605C")
  ;;                                 ("LOWPRIO" . "#68B1FF")
  ;;                                 ))

(let* (
       (comment      "#6272a4")
       (warning      "#ffb86c")
       (rainbow-1    "#f8f8f2")
       (rainbow-2    "#8be9fd")
       (rainbow-3    "#bd93f9")
       (rainbow-4    "#ff79c6")
       (rainbow-5    "#ffb86c")
       (rainbow-6    "#50fa7b")
       (rainbow-7    "#f1fa8c")
       (rainbow-8    "#0189cc")
       (rainbow-9    "#ff5555")
       (rainbow-10   "#a0522d")

;;     ;; (fixed-pitch-font    `(:family "Fira Mono" ))
       ;; (variable-pitch-font `(:family "iA Writer Quattro S" ))
       ;; (fixed-pitch-font-alt `(:family "iA Writer Mono S" ))

       (todo-keyword-font `(:family "Fira Mono" ))
       )


   (setq org-todo-keyword-faces (list
                                 `("TODO"
                                   ,@todo-keyword-font
                                   :foreground ,rainbow-5
                                   :weight bold
                                   )
                                 `("STUBBED"
                                   ,@todo-keyword-font
                                   :foreground ,rainbow-4
                                   :weight bold
                                   )
                                 `("IMPLEMENTED"
                                   ,@todo-keyword-font
                                   :foreground ,rainbow-3
                                   :weight bold
                                   )
                                 `("NEXT"
                                   ,@todo-keyword-font
                                   :foreground ,rainbow-9
                                   :weight bold)
                                 `("WAIT"
                                   ,@todo-keyword-font
                                   :foreground ,rainbow-1
                                   :weight bold)
                                 ;; `("VERIFY"
                                 ;;   ,@todo-keyword-font
                                 ;;   :foreground ,rainbow-7
                                 ;;   :weight bold)
                                 `("LOWPRIO"
                                   ,@todo-keyword-font
                                   :foreground ,rainbow-2
                                   :weight bold)
                                 `("DONE"
                                   ,@todo-keyword-font
                                   :foreground ,comment
                                   :weight bold)
                                 `("CANCELLED"
                                   ,@todo-keyword-font
                                   :foreground ,comment
                                   :weight bold)
                                 ))
  )
