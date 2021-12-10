;;; ../.config/emacs/doom-config/scratch/agenda-time-grid.el -*- lexical-binding: t; -*-


(org-super-agenda-mode 1)

(let (
      (org-agenda-files '("~/.config/emacs/doom-config/scratch/test.org" "~/.config/emacs/doom-config/scratch/foobar.org"))

      (org-agenda-span 'day)
      (org-agenda-start-day nil)
      (org-super-agenda-groups
       '((
          :log t
          )
         (:name "today"
          :scheduled today
          :time-grid t
          )
         (:name "tmw"
          :time-grid t
          ))))
  (org-agenda nil "a"))
