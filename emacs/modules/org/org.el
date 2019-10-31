
(with-eval-after-load 'doom-themes
(setq org-todo-keyword-faces `(
                               ("PROJECT" . ,(doom-color 'violet))
                               ("TODO" . ,(doom-color 'yellow))
                               ("NEXT" . ,(doom-color 'red))
                               ("INBOX" . ,(doom-color 'yellow))
                               ("LATER" . ,(doom-color 'teal))
                               ("DONE" . ,(doom-color 'grey))
                               ("CANCELLED" . ,(doom-color 'grey))
                               ("GOAL" . ,(doom-color 'green))
                               )

      org-todo-keywords '(
                          (sequence "TODO(t)" "INBOX(i)" "NEXT(n)" "IN-PROGRESS(p)" "LATER(l)" "WAITING(w)" "BLOCKED(b)" "|" "CANCELLED(c)" "DONE(d!)" )
                          (sequence "PROJECT(p)" "|" "PROJECT-COMPLETED(P)")
                          ))

)
