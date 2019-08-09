;;; init.el --- description -*- lexical-binding: t; -*-
;;--------------------------------------------------------------------------------
;; straight.el Boostrap block
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t) 

(defmacro with-eval-after-packages (features &rest body)
  (if (null features)
    `(progn ,@body)
    `(eval-after-load (quote ,(car features))
       (quote (with-eval-after-packages ,(cdr features) ,@body)))))


(setq config-root "~/dotfiles/emacs/straight/")
(setq modules-root (concat config-root "modules/") )

(defun get-modules-list ()
  (directory-files-recursively "~/dotfiles/emacs/straight/modules" "\\.el$"))

(defun get-modules-directories ()
  (-filter (lambda (x) (not (string-match "\\.el$" x)))
          (directory-files-recursively "~/dotfiles/emacs/straight/modules" ".*" t)
          )
  )

(defun get-doom-modules-list ()
  (append
   (directory-files-recursively "~/dotfiles/emacs/doom/modules" "\\.el$")
   (directory-files-recursively "~/doom-emacs/modules" "[^#]\\.el$")
   )
)

(defun load-all-config-files () 
  (interactive)
  (mapc (lambda (f) (load-file f)) (get-modules-list))
)

;; disable the system bell
(setq ring-bell-function 'ignore)


(use-package posframe)

(load-all-config-files)
(server-start)
