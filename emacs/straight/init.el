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

(defmacro with-eval-after-packages (features &rest body)
  (if (null features)
      (progn body)
    `(eval-after-load (quote ,(car features))
       (quote (with-eval-after-packages ,(cdr features) ,@body)))))


(defvar config-root "~/dotfiles/emacs/straight/")
(defvar modules-root (concat config-root "modules/"))


(defun get-modules-list ()
  (directory-files-recursively "~/dotfiles/emacs/straight/modules" "\\.el$"))


(mapc (lambda (f) (load-file f)) (get-modules-list))


;; TODO command to jump to this init file
;; TODO command to use ivy to quick search and pull up a module
