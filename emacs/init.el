;;; init.el --- description -*- lexical-binding: t; -*-

;; this just avoids that startup warning. some other package is trying to load evil before evil.el is 
(setq evil-want-keybinding nil)

(setq inhibit-startup-screen t)

(setq make-backup-files nil
      create-lockfiles nil)


(setq scroll-bar-mode -1)
(menu-bar-showhide-tool-bar-menu-customize-disable) 

;; make the titlebar "transparent" in osx
(add-to-list 'default-frame-alist
             '(ns-transparent-titlebar . t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; straight.el Boostrap 
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

(setq vc-follow-symlinks t)

;;allow use package to talk to OS package managers, to specify deps on OS bins
(use-package use-package-ensure-system-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Additional core elisp libraries

(use-package dash)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module/file loading

;; main directories
(setq home-dir "/Users/jeff")   
(setq system-config-root "~/code/dotfiles/")
(setq emacs-config-root "~/.config/emacs/")
(setq modules-root (concat emacs-config-root "modules/") )
(setq package-repos-dir "~/.config/emacs/straight/repos/")

(defun get-all-package-files ()
  (directory-files-recursively package-repos-dir "\\.el$" t)
  )

(setq package-files-list nil)

(defun get-all-package-files-cached ()
  (if package-files-list package-files-list
    (refresh-package-files-list)
    )
  )

(defun refresh-package-files-list ()
  (interactive)
  (setq package-files-list (get-all-package-files))
  )

;; search Regexes
(setq all-elisp-files-regex "\\.el$")

(setq dev-files-regex 
      ".*\.\\(dev\\)\.el$")

(setq test-files-regex
      ".*\.\\(test\\)\.el$")

(defun get-all-config-files ()
  (directory-files-recursively modules-root all-elisp-files-regex)
  )

;; essentially, any files ending in ".dev.el" or ".test.el" will *not* be loaded
;; this way, we can mix some scratch/dev files with actual config files
(defun get-load-files ()
  (--filter (not (or  (string-match-p dev-files-regex it)
		      (string-match-p test-files-regex it)))
	    (get-all-config-files))
  )

;;(defun get-modules-list ()
;;  (directory-files-recursively modules-root all-elisp-files-regex))

(defun get-modules-directories ()
  (-filter (lambda (x) (not (string-match all-elisp-files-regex x)))
           (directory-files-recursively modules-root ".*" t)
           )
  )

(defun load-all-config-files () 
  (interactive)
  (mapc (lambda (f) (load-file f)) (get-load-files))
)

(load-all-config-files)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; run server

(server-start) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; custom-set-variables block 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("2d1fe7c9007a5b76cea4395b0fc664d0c1cfd34bb4f1860300347cdad67fb2f9" "c8f959fb1ea32ddfc0f50db85fea2e7d86b72bb4d106803018be1c3566fd6c72" "728eda145ad16686d4bbb8e50d540563573592013b10c3e2defc493f390f7d83" default))
 '(org-stuck-projects '("/+PROJECT" ("TODO") nil ""))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
