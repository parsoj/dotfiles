;;; ../.config/emacs/doom-config/scratch/agenda-test.el -*- lexical-binding: t; -*-


;; (org-super-agenda-mode 1)

(let

    (

     (org-agenda-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org"))
     (org-agenda-custom-commands '(
                                   ("z" "custom agenda"
                                    (
                                     ;; (agenda)
                                     (org-ql-block `(and

                                                     ,(append '(todo) org-active-states)
                                                     (scheduled :to ,(ts-now))
                                                     )
                                                   (
                                                    ;; (org-ql-block-header "fack")
                                                    ;; (org-ql-block-header "Due xToday")
                                                    ;; (org-super-agenda-groups
                                                    ;;  '(
                                                    ;;    (:name "test todo"
                                                    ;;     :todo "TEST")
                                                    ;;    (:name "foink"
                                                    ;;     ;; :todo "TEST"
                                                    ;;     :auto-ts t
                                                    ;;     )
                                                    ;;    ))
                                                    )))))))


  (org-agenda t "z")
  )
(org-time-stamp)


