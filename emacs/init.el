;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

(setq gc-cons-threshold 100000000)

(defconst spacemacs-version         "0.105.21" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.3" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (message (concat "Your version of Emacs (%s) is too old. "
                     "Spacemacs requires Emacs version %d or above.")
             emacs-version spacemacs-emacs-min-version)
  (load-file (concat user-emacs-directory "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (spacemacs/maybe-install-dotfile)
  (configuration-layer/sync)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))


;;smooth scrolling
(use-package smooth-scroll
  :config
  (smooth-scroll-mode 1)
  (setq smooth-scroll/vscroll-step-size 5)
  )

;;prompt disabling/reducing (ripped from mastering emacs)
(fset 'yes-or-no-p 'y-or-n-p)

;;use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;;helm settings
(setq helm-ag-fuzzy-match t)
(global-set-key (kbd "M-m bf") 'helm-ag-project-root)

;;eshell colored prompt
(defmacro with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

(defun shk-eshell-prompt ()
  (let ((header-bg "#000"))
    (concat
     (with-face user-login-name :foreground "blue")
     "@"
     (with-face "localhost" :foreground "green")
     (with-face (format-time-string " (%Y-%m-%d %H:%M) " (current-time)) :foreground "#888")
     (with-face "\n" )
     (with-face (concat (eshell/pwd) " ") )
     (with-face
      (or (ignore-errors (format "(%s)" (vc-responsible-backend default-directory))) ""))
     (if (= (user-uid) 0)
         (with-face " #" :foreground "red")
       (with-face " $" :foreground "green"))
     " ")))
(setq eshell-prompt-function 'shk-eshell-prompt)
(setq eshell-highlight-prompt nil)
