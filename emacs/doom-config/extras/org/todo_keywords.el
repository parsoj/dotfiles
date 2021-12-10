

(defun +localize-todo-keyword-vars ()
  (interactive)

  (progn
    (add-file-local-variable 'org-todo-keywords org-todo-keywords)
    (add-file-local-variable 'org-todo-keyword-faces org-todo-keyword-faces)
    )
  )

  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)")
                           (sequence "WAIT(w)" "LOWPRIO(l)")))
  (setq org-todo-keyword-faces `(("TODO" . "#FD9446" )
                                 ("NEXT" . "#F4605C")
                                 ("LOWPRIO" . "#68B1FF")
                                 ))

;; (let* (
;;        (comment      "#6272a4")
;;        (warning      "#ffb86c")
;;        (rainbow-1    "#f8f8f2")
;;        (rainbow-2    "#8be9fd")
;;        (rainbow-3    "#bd93f9")
;;        (rainbow-4    "#ff79c6")
;;        (rainbow-5    "#ffb86c")
;;        (rainbow-6    "#50fa7b")
;;        (rainbow-7    "#f1fa8c")
;;        (rainbow-8    "#0189cc")
;;        (rainbow-9    "#ff5555")
;;        (rainbow-10   "#a0522d")

;;        ;; (variable-pitch-font `(:family "iA Writer Quattro S" ))
;;        ;; (fixed-pitch-font    `(:family "Fira Mono" ))
;;        ;; (fixed-pitch-font-alt `(:family "iA Writer Mono S" ))
;;        )


;;   ;; (setq org-todo-keyword-faces (list
;;   ;;                               `("TODO"
;;   ;;                                 ,@fixed-pitch-font
;;   ;;                                 :foreground ,comment
;;   ;;                                 :weight bold
;;   ;;                                 )
;;   ;;                               `("NEXT"
;;   ;;                                 ,@fixed-pitch-font
;;   ;;                                 :foreground ,warning
;;   ;;                                 :weight bold)
;;   ;;                               `("WAIT"
;;   ;;                                 ,@fixed-pitch-font
;;   ;;                                 :foreground ,rainbow-2
;;   ;;                                 :weight bold)
;;   ;;                               `("VERIFY"
;;   ;;                                 ,@fixed-pitch-font
;;   ;;                                 :foreground ,rainbow-7
;;   ;;                                 :weight bold)
;;   ;;                               `("LOWPRIO"
;;   ;;                                 ,@fixed-pitch-font
;;   ;;                                 :foreground ,comment
;;   ;;                                 :weight bold)
;;   ;;                               `("DONE"
;;   ;;                                 ,@fixed-pitch-font
;;   ;;                                 :foreground ,rainbow-6
;;   ;;                                 :weight bold)
;;   ;;                               `("CANCELLED"
;;   ;;                                 ,@fixed-pitch-font
;;   ;;                                 :foreground ,rainbow-9
;;   ;;                                 :weight bold)
;;   ;;                               ))
;;   )
