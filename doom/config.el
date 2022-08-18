;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jeff Parsons"
      user-mail-address "jeff@gjeffparsons.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq
 ;; doom-font (font-spec :family "Fira Code" :size 15 :weight 'thin)
 doom-font (font-spec :family "Fira Code" :size 15)
 ;; doom-font (font-spec :family "Fira Code Light" :size 15)
 doom-variable-pitch-font (font-spec :family "EB Garamond" :size 20)
 )

(setq doom-big-font-increment 6)


(setq doom-themes-treemacs-enable-variable-pitch nil)
(after! treemacs (treemacs-follow-mode 1))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-palenight)
(setq doom-themes-treemacs-theme 'doom-colors)
(after! (:and projectile treemacs
         )
  (add-hook! 'treemacs-pre-refresh-hook #'treemacs-display-current-project-exclusively))

;; use the emacs-plus hook to change the doom theme to match OSX dark mode
(defun sync-osx-dark-mode (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-one-light t))
    ('dark (load-theme 'doom-one t))))

(add-hook 'ns-system-appearance-change-functions #'sync-osx-dark-mode)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type 'absolute)
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



;; you know how to delete windows vs buffers - don't let doom override the ability
;; to delete a buffer if you need to
(advice-remove #'kill-current-buffer #'doom--switch-to-fallback-buffer-maybe-a)




(setq ivy-re-builders-alist
      '((t . ivy--regex-ignore-order)))

(setq ivy-posframe-height-alist '(
                                  (+ivy-read-string     . 1)
                                  ))

(setq ivy-posframe-parameters
      '((left-fringe . 5)
        (right-fringe . 5)))


;; don't obnoxiously expand the minibuffer all the time
;; (setq resize-mini-windows nil)


;; graphql mode
(use-package! graphql-mode)

(use-package! osascripts)
(use-package! protobuf-mode)
(use-package! plz)
(use-package! aggressive-indent)

(setq third-party-dir (expand-file-name (concat doom-private-dir "third-party")))
(setq extras-dir (expand-file-name (concat doom-private-dir "extras")))
(setq libs-dir (expand-file-name (concat doom-private-dir "libraries")))



;; word-wrap mode by default for shell mode
;; (add-hook! 'shell-mode-hook #'+word-wrap-mode)

;; python settings
(after! python
  (set-repl-handler! 'python-mode #'+python/open-ipython-repl)
 )

;; org-capture frames need the display frame param to avoid the
;; "unknown terminal type" error when running from an emacsclient executing
;; against a headless server/daemon
(setq +org-capture-frame-parameters
  `((name . "doom-capture")
    (width . 70)
    (height . 25)
    (transient . t)
    ;; (display . ":0")
    (display . ,(getenv "DISPLAY"))
    ,(if IS-MAC '(menu-bar-lines . 1))))

(setq +org-capture-fn #'org-roam-capture)

(setq org-confirm-babel-evaluate nil)   ;; Allow babel code execution without confirming it every time.

;;  org-super-agenda tries to force its own keybinds on you
;;  prevent this from happening
(setq org-super-agenda-header-map (make-sparse-keymap))

(map! :leader "SPC" #'execute-extended-command)
(map! :leader "b R" #'rename-buffer)
(map! :leader "b R" #'rename-buffer)
(map! :leader "g c p" #'+create-pullreq)
(map! :leader "i i" #'aya-expand)
(map! :g "s-w" (cmd! (delete-frame nil t)))

(progn
  (define-key evil-normal-state-map "h" nil)
  (define-key evil-normal-state-map "j" nil)
  (define-key evil-normal-state-map "k" nil)
  (define-key evil-normal-state-map "l" nil)
  (define-key evil-normal-state-map ";" nil)

  (define-key evil-motion-state-map "j" 'evil-backward-char)
  (define-key evil-motion-state-map "k" 'evil-next-line)
  (define-key evil-motion-state-map "l" 'evil-previous-line)
  (define-key evil-motion-state-map ";" 'evil-forward-char)

  )


(map!
 :nvmo "j" #'evil-backward-char
 :nvmo ";" #'evil-forward-char

 :nvmo "l" #'evil-previous-line
 :nvmo "k" #'evil-next-line
 )

(map! :map magit-mode-map :after magit
 :nvm "j" #'evil-backward-char
 :nvm ";" #'evil-forward-char

 :nvm "l" #'evil-previous-line
 :nvm "k" #'evil-next-line
      )


(map! :map ivy-occur-mode-map
 :nvme "j" #'evil-backward-char
 :nvme ";" #'evil-forward-char

 :nvme "l" #'evil-previous-line
 :nvme "k" #'evil-next-line
      )

(map! :map ivy-occur-grep-mode-map
 :nvme "j" #'evil-backward-char
 :nvme ";" #'evil-forward-char

 :nvme "l" #'evil-previous-line
 :nvme "k" #'evil-next-line
      )

(map! :map emacs-lisp-mode-map
      (:localleader
       :desc "eval-print" "e p" #'eval-print-last-sexp)
      )

(map! :leader
      "1" #'winum-select-window-1
      "2" #'winum-select-window-2
      "3" #'winum-select-window-3
      "4" #'winum-select-window-4
      "5" #'winum-select-window-5
      "6" #'winum-select-window-6
      "7" #'winum-select-window-7
      "8" #'winum-select-window-8
      "9" #'winum-select-window-9
      )
(map! :map eshell-mode-map
      (:localleader
       :desc "history" "h" #'counsel-esh-history)
      )

;; have avy-jump select options from all windows (not just current buffer)
(setq avy-all-windows t)

(setq vterm-shell "/opt/homebrew/bin/fish")

(after! treemacs-evil
  (evil-define-key 'treemacs treemacs-mode-map "k" #'evil-next-line)
  (evil-define-key 'treemacs treemacs-mode-map "l" #'evil-previous-line)

  (evil-define-key 'treemacs treemacs-mode-map ";" #'evil-forward-char)
  (evil-define-key 'treemacs treemacs-mode-map "j" #'evil-backward-char)
  )

(setq treemacs-recenter-after-file-follow 'on-distance)
(setq treemacs-recenter-after-tag-follow 'on-distance)
(setq treemacs-recenter-distance 15)
(setq treemacs-collapse-dirs t)


(setq plantuml-default-exec-mode 'jar)
(setq org-plantuml-jar-path (expand-file-name "/usr/local/Cellar/plantuml/1.2021.12/libexec/plantuml.jar"))



(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-buffer-file-name-style 'truncate-with-project)

;; (after! eshell
;;   (add-to-list 'eshell-visual-commands "docker"))


;; @see https://bitbucket.org/lyro/evil/issue/511/let-certain-minor-modes-key-bindings
(with-eval-after-load 'git-timemachine
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

(setq magit-commit-show-diff nil)
(setq magit-main-branch-names
      '("main" "master" "trunk" "develop"))

(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

;;(eval-after-load 'tramp-remote-path
 ;; (add-to-list 'tramp-remote-path "/root/.asdf/shims"))

(set-eshell-alias!
 "kc" "kubectl $*"
 "tf" "terraform $*"
 "dd" "(+eshell-switch-directory-in-project)"
 )

;; Save sessions history
(progn
  (setq savehist-save-minibuffer-history 1)
  (setq savehist-additional-variables
        '(kill-ring search-ring regexp-search-ring compile-history log-edit-comment-ring)
        savehist-file "~/.emacs.d/savehist")
  (savehist-mode t))


(setq max-mini-window-height 2)

;; don't ask "xxx has a running process - you sure you wanna kill it?"
(setq confirm-kill-processes nil)

(defun set-no-process-query-on-exit ()
    (let ((proc (get-buffer-process (current-buffer))))
    (when (processp proc)
    (set-process-query-on-exit-flag proc nil))))

(add-hook 'term-exec-hook 'set-no-process-query-on-exit)
(add-hook 'shell-mode-hook 'set-no-process-query-on-exit)
(add-hook 'vterm-mode-hook 'set-no-process-query-on-exit)

(set-popup-rule! "^\\*eww" :side 'right :size 90)

(set-popup-rule! "^\\*helpful" :side 'right :size 90)
(set-popup-rule! "^\\*Man" :side 'right :size 0.40)

;; (set-popup-rule! "^magit" :side 'right :size 90)
(set-popup-rule! "^\\magit" :side 'right :width 70  )

(set-popup-rule! "^\\*doom:vterm-popup" :side 'bottom :size 20 :select t :ttl nil :quit t)
(set-popup-rule! "^\\*doom:eshell-popup" :side 'bottom :size 20 :select t :ttl nil :quit t)

(set-popup-rule! "^\\*compilation" :side 'right :size 0.40 :select t :quit t)
(set-popup-rule! "\\*Flutter" :side 'bottom :size 0.20 :select t :ttl nil)
(set-popup-rule! "^\\*Python" :side 'bottom :size 0.4 :select t :quit t)
(set-popup-rule! "^\\*Launch File" :side 'right :size 0.4 :select nil :quit t)
(set-popup-rule! "\\*edebug" :side 'right :width 0.4 :height 30 :slot 5)
(add-hook! 'edebug-eval-mode-hook (+word-wrap-mode 1))


(set-repl-handler! 'python-mode #'+python/open-ipython-repl)

(setq lsp-ui-doc-alignment 'window)
(setq lsp-ui-doc-max-height 20)

;; need to set this on a hook to override doom's lazy-loaded
;; lsp-ui use-package settings
(add-hook! lsp-ui-mode (setq lsp-ui-doc-position 'top))



(setq lsp-ui-peek-peek-height 30)
(setq lsp-ui-peek-list-width 70)
(custom-set-faces!
  '(lsp-ui-peek-header :background "grey50" :foreground "white" )
  '(lsp-ui-peek-highlight :background "goldenrod" :foreground "#282c34" )
  )



(after! lsp-mode
  ;; override the project root function to auto-guess the
  ;; project root based on the custom workspaces structure
  (defun lsp--suggest-project-root ()
    (let ((top-level-project-dirs (f-directories
                                   (condition-case nil
                                       (projectile-project-root)
                                     (error nil))) )
          (buffer-dir default-directory)
          )

      (car
       (-filter (lambda (d) (or (f-same? d buffer-dir) (f-ancestor-of? d buffer-dir))) top-level-project-dirs))


      )
    )

  (setq lsp-auto-guess-root t)
  (setq lsp-file-watch-threshold 2000)

  )

;; unset company backends for magit commit msg buffers
(set-company-backend! 'text-mode nil)

(setq workspaces-root "~/workspaces")
(setq project-notes-file "README.org")
(setq emacs-env-dir "~/emacs-confs")

(require 'dash)
(require 'f)


(progn
  (if (not (f-exists? emacs-env-dir))
      (f-mkdir emacs-env-dir)
    )

  (-map (lambda (x) (load! x)) (directory-files-recursively emacs-env-dir ".*\\.el$"))

  (-map (lambda (x) (load! x)) (directory-files-recursively libs-dir ".*\\.el$"))

  (-map (lambda (x) (load! x)) (directory-files-recursively extras-dir ".*\\.el$"))

  (load! "bindings.el")

  )

(server-start)
