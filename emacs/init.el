(defvar elpaca-installer-version 0.8)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Install a package via the elpaca macro
;; See the "recipes" section of the manual for more details.

;; (elpaca example-package)

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode))

;;When installing a package used in the init file itself,
;;e.g. a package which adds a use-package key word,
;;use the :wait recipe keyword to block until that package is installed/configured.
;;For example:
(use-package general :ensure (:wait t) :demand t)

;; Expands to: (elpaca evil (use-package evil :demand t))
(use-package evil :ensure (:wait t) :demand t)
(use-package evil-collection :ensure (:wait t) )
(evil-mode 1)
(evil-collection-init)

;;Turns off elpaca-use-package-mode current declaration
;;Note this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
;;(use-package emacs :ensure nil :config (setq ring-bell-function #'ignore))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq kill-buffer-query-functions nil)
(setq vterm-kill-buffer-on-exit t)

(setq inhibit-startup-screen t)

;; Hide toolbar, menubar and scrollbars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Hide titlebar on macOS
;;(add-to-list 'default-frame-alist '(undecorated . t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package doom-themes :ensure (:wait t))
(load-theme 'doom-one t)

(use-package doom-modeline :ensure (:wait t) :config (doom-modeline-mode 1))
(setq doom-modeline-icon t)

(set-face-attribute 'default nil
                    :font "InconsolataGo Nerd Font"
                    :height 140)
(set-face-attribute 'variable-pitch nil
                    :font "InconsolataGo Nerd Font"
                    :height 140)
(set-face-attribute 'fixed-pitch nil
                    :font "InconsolataGo Nerd Font"
                    :height 140)

(use-package all-the-icons 
  :ensure (:wait t)
  :if (display-graphic-p))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package vertico :ensure (:wait t))
(vertico-mode)

(use-package orderless :ensure (:wait t))

(setq completion-styles '(orderless basic)
      orderless-matching-styles '(orderless-regexp))

(use-package consult :ensure (:wait t))

(use-package marginalia :ensure (:wait t))
(marginalia-mode)

;;(use-package embark :ensure (:wait t))

;;(use-package embark-consult :ensure t)


(setq consult-fd-args "fd --hidden --max-depth 12 --type f --full-path")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(general-create-definer my-leader-def
  :keymaps '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC") ;; Optional: global leader keybinding


(defun cmd (body)
  "Wrap BODY with `interactive` to create a command."
  (lambda () (interactive) (eval body)))

(my-leader-def
  "SPC" 'execute-extended-command ;; Use Consult for command selection

  "f"  '(:ignore t :which-key "files")
  "ff" 'consult-fd
  "fs" 'save-buffer

  "wd" 'delete-window
  "wv" 'split-window-right
  "ws" 'split-window-below

  "b"  '(:ignore t :which-key "buffers")
  "bb" 'consult-buffer
  "bd" 'kill-buffer
  "bp" 'previous-buffer
  "bn" 'next-buffer
  "br" 'revert-buffer

  "p"  '(:ignore t :which-key "projectile")
  "pp" 'projectile-switch-project
  "pf" 'projectile-find-file

  "t"  '(:ignore t :which-key "toggles")
  "tt" 'treemacs
  "tn" 'display-line-numbers-mode
  "tw" 'whitespace-mode
  "tl" 'visual-line-mode

  "j"  '(:ignore t :which-key "avy")
  "jj" 'avy-goto-char
  "jw" 'avy-goto-word-1
  "jl" 'avy-goto-line
  "jc" 'avy-goto-char-2

  "rr" (lambda () (interactive) (load-file (expand-file-name "~/.config/emacs/init.el")))
  "ci" (lambda () (interactive) (find-file (expand-file-name "~/.config/emacs/init.el")))


) 

(with-eval-after-load 'vertico
  (general-define-key
   :keymaps 'vertico-map
   "<escape>" 'keyboard-escape-quit))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vterm :ensure (:wait t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package go-mode
  :ensure (:wait t)
  :mode "\\.go\\'"
  :hook ((go-mode . lsp-deferred)
         (before-save . gofmt-before-save)))

(use-package gotest
  :ensure (:wait t)
  :after go-mode)

(use-package go-eldoc
  :ensure (:wait t)
  :hook (go-mode . go-eldoc-setup))

(use-package go-fill-struct
  :ensure (:wait t))

(use-package go-impl
  :ensure (:wait t))

(setq gofmt-command "goimports")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package terraform-mode
  :ensure (:wait t)
  :mode "\\.tf\\'")

(use-package company-terraform
  :ensure (:wait t)
  :after terraform-mode
  :config
  (company-terraform-init))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package projectile
  :ensure (:wait t)
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-enable-caching t)
  (setq projectile-auto-discover nil)
  (setq projectile-project-root-files-bottom-up '(".workspace"))
  (setq projectile-project-search-path '(("~/code/workspaces/" . 4)))
  (setq projectile-completion-system 'default)
  (setq projectile-switch-project-action
  (setq projectile-switch-project-action
      (lambda ()
        (find-file (expand-file-name "notes.md" (projectile-project-root)))))
	))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package treemacs
  :ensure (:wait t)
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)
        ("C-x t i"   . treemacs-icons-dired-mode)
        ("C-x t a"   . treemacs-add-and-display-current-project))
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'deferred))

(use-package treemacs-all-the-icons
  :ensure (:wait t)
  :after (treemacs all-the-icons)
  :config
  (treemacs-load-theme "all-the-icons"))

(use-package treemacs-projectile
  :ensure (:wait t)
  :after (treemacs projectile)
  :config
  (setq treemacs-project-follow-cleanup t)
  (setq treemacs-project-follow-mode t))

(use-package treemacs-icons-dired
  :ensure (:wait t)
  :hook (dired-mode . treemacs-icons-dired-enable-once))

;;(use-package treemacs-magit
  ;;:ensure (:wait t)
  ;;:after (treemacs magit))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package yaml-mode
  :ensure (:wait t)
  :mode ("\\.ya?ml\\'" . yaml-mode))

(add-hook 'yaml-mode-hook
          (lambda ()
            (highlight-indent-guides-mode)
            (setq highlight-indent-guides-method 'character))) ; Or 'fill or 'column


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package origami
  :ensure (:wait t)
  :hook (prog-mode . origami-mode)
  :bind (:map origami-mode-map
              ("C-c o o" . origami-open-node)
              ("C-c o c" . origami-close-node)
              ("C-c o t" . origami-toggle-node)
              ("C-c o a" . origami-toggle-all-nodes)
              ("C-c o r" . origami-reset)
              ("C-c o n" . origami-next-fold)
              ("C-c o p" . origami-previous-fold)))



  (setq avy-background t)
  (setq avy-style 'at-full)

(use-package highlight-indent-guides :ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package exec-path-from-shell
  :ensure (:wait t)
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :after transient
  )

(use-package git-link
  :ensure t)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
    (python-mode . lsp)
    (go-mode . lsp)
         )
  :commands lsp
  :custom
  (lsp-file-watch-threshold 2000))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-enable t))

;;(use-package company
  ;;:ensure t
  ;;:hook (after-init . global-company-mode)
  ;;:custom
  ;;(company-minimum-prefix-length 1)
  ;;(company-idle-delay 0.0))

;;(use-package which-key
  ;;:ensure t
  ;;:config
  ;;(which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;(with-eval-after-load 'lsp-mode
;;(load "/Users/jeff/.config/emacs/ai.el")
;;)


