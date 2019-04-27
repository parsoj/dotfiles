;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;;

(setq projectile-project-search-path '("~/code/remitly/" "~/code/personal/"))
(setq restclient-log-request nil)

(map!                    

 (:after ivy
   :map ivy-minibuffer-map
   [escape] #'keyboard-escape-quit
   )
 (:after counsel
   :map ivy-minibuffer-map
   [escape] #'keyboard-escape-quit
   )

 (:after company
   :map company-search-map
   [escape] #'company-search-abort
   )

 (:after magit
   :map magit-mode-map
   [escape] #'+magit/quit
   )
 )

(map! :leader
      :desc "Counsel M-x"   "SPC" #'counsel-M-x
      :desc "Eval Expression" ":" #'eval-expression
      :desc "Eshell popup"   "'" #'+eshell/open-popup
      :desc "Eshell in window"   "\"" #'+eshell/open

      (:prefix ("t" . "toggle")
        :desc "Treemacs"                     "t"   #'+treemacs/toggle
        :desc "Line Numbers"   "n"  #'doom/toggle-line-numbers
        :desc "Line Truncation/Wrap" "l"  #'toggle-truncate-lines
        )

      (:prefix ("w" . "window")
        :desc "Delete"                     "d"   #'delete-window
        :desc "Undo" "u" #'winner-undo
        :desc "Redo" "r" #'winner-redo
        :desc "Maximize"  "m" #'doom/window-maximize-buffer
        :desc "Split Right" "s" #'split-window-vertically
        :desc "Split Below" "v" #'split-window-horizontally
        :desc "Left"  "h" #'evil-window-left
        :desc "Right"  "l" #'evil-window-right
        :desc "Above"  "k" #'evil-window-up
        :desc "Below"  "j" #'evil-window-down
        )

      (:prefix ("f" . "file")
        :desc "Compile" "c"   #'compile
        :desc "Save" "s" #'save-buffer
        :desc "find" "f" #'find-file
        :desc "rename" "R" #'rename-current-buffer-and-file
        )

      (:prefix ("p" . "project")
        :desc "Switch Project" "p" #'projectile-switch-project
        :desc "Find file in project" "f" #'+ivy/projectile-find-file
        )

      (:prefix ("s" . "search")
        :desc "Search Project" "p" #'counsel-projectile-rg
        :desc "Search Buffer"  "b" #'swiper
        :desc "Search Directory"  "d" #'counsel-rg
        )

      (:prefix ("b" . "buffer")
        :desc "Compile"                     "c"   #'compile
        :desc "Delete" "d" #'evil-delete-buffer
        :desc "Revert" "r" #'revert-buffer
        :desc "Switch Buffer" "b" #'switch-to-buffer
        :desc "Previous Buffer" "p" #'previous-buffer
        :desc "Next Buffer" "n" #'next-buffer

        )

      (:prefix ("h" . "help")
        :desc "Describe Function" "f" #'describe-function
        :desc "Describe Key" "k" #'describe-key
        :desc "Describe Variable" "v" #'describe-variable
        :desc "Describe Char" "c" #'describe-char
        :desc "Describe Mode" "m" #'describe-mode
        :desc "Describe Doom Module" "M" #'doom/describe-module
        )

      (:prefix ("l" . "lookup")
        :desc "definition" "d" #'+lookup/definition
        :desc "references" "r" #'+lookup/references
        :desc "documentation" "h" #'+lookup/documentation
        )

      (:prefix ("d" . "doom")
        :desc "Reload config" "r" #'doom/reload
        :desc "Restart Doom" "R" #'doom/restart
        :desc "Refresh packages" "p" #'doom//refresh
        :desc "Quit Doom" "q" #'evil-quit-all

        (:prefix ("c" . "config")
          :desc "config.el" "c" (lambda! (find-file "~/.config/doom/config.el"))
          :desc "init.el" "i" (lambda! (find-file "~/.config/doom/init.el"))
          :desc "bashrc" "b" (lambda! (find-file "~/.bashrc"))
          )
        )

      (:prefix ("c" . "cursor")
        :desc "Make cursor and move down line" "j" #'evil-mc-make-cursor-move-next-line
        :desc "Undo all cursors" "q" #'evil-mc-undo-all-cursors
        :desc "Make all matching cursors" "a" #'evil-mc-make-all-cursors
        )

      (:prefix ("g" . "git")
        :desc "Status" "s" #'magit-status
        :desc "blame" "b" #'magit-blame-addition
        :desc "quick commit" "c" (lambda! (progn (magit-stage) (magit-commit-create)))
        )

      )


(after! ivy
  (setq
   ivy-re-builders-alist '(
                           (counsel-M-x . ivy--regex-ignore-order)
                           (counsel-ag . ivy--regex-ignore-order)
                           (counsel-rg . ivy--regex-ignore-order)
                           (counsel-grep . ivy--regex-ignore-order)
                           (swiper . ivy--regex-ignore-order)
                           (swiper-isearch . ivy--regex-ignore-order)
                           (t . ivy--regex-ignore-order)
                          )
   ivy-initial-inputs-alist nil
   ivy-use-virtual-buffers t
   )
  )

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-current-buffer-and-file (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
