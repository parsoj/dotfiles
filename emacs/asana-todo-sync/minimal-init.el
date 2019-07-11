;;; make Org mode available to Emacs
(push "/Applications/Emacs.app/Contents/Resources/lisp/org/org.elc" load-path)

;;; make the downloaded ts-org-interaction library available
(push "/Users/jeffp/Dropbox/Dotfiles/emacs/asana-todo-sync//site-lisp" load-path)

;;; set Org agenda file variables
(defvar org-directory "~/org")

(setq org-agenda-files  '("/Users/jeffp/org/projects/org-migration/org-migration.org"
                         "/Users/jeffp/org/projects/emacs-rebuild.org"
                         "/Users/jeffp/org/projects/keybinding_system.org"
                         "/Users/jeffp/org/projects/laptop.org"
                         "/Users/jeffp/org/life_ops/life_ops.org"
                         "/Users/jeffp/org/spare_time/read_later.org"
                         "/Users/jeffp/org/spare_time/side_reading.org"
                         "/Users/jeffp/org/someday_maybe/aspirations/aspirations.org"
                         "/Users/jeffp/org/someday_maybe/bucket_lists/bucket_list.org"
                         "/Users/jeffp/org/someday_maybe/bucket_lists/travel_list.org"
                         "/Users/jeffp/org/someday_maybe/dev_setup/emacs.org"
                         "/Users/jeffp/org/someday_maybe/product_ideas/product_ideas.org"
                         "/Users/jeffp/org/someday_maybe/projects/projects.org"
                         "/Users/jeffp/org/someday_maybe/wants/buy_want_list.org"
                         ))
