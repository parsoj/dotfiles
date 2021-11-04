;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jeff Parsons"
      user-mail-address "parsoj@gmail.com")

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
(setq doom-font (font-spec :family "Iosevka" :size 16)
      ;;doom-variable-pitch-font (font-spec :family "ETBembo" :size 16)
      )
(setq doom-big-font-increment 6)


(setq doom-themes-treemacs-enable-variable-pitch nil)
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-themes-treemacs-theme 'doom-colors)

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

(setq third-party-dir (expand-file-name (concat doom-private-dir "third-party")))
(setq extras-dir (expand-file-name (concat doom-private-dir "extras")))



;; word-wrap mode by default for shell mode
;; (add-hook! 'shell-mode-hook #'+word-wrap-mode)

;; python settings
(after!
  (set-repl-handler! 'python-mode #'+python/open-ipython-repl))

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

;;  org-super-agenda tries to force its own keybinds on you
;;  prevent this from happening
(setq org-super-agenda-header-map (make-sparse-keymap))

(map! :leader "SPC" #'counsel-M-x)
(map! :leader "b R" #'rename-buffer)
(map! :leader "b R" #'rename-buffer)
(map! :leader "g c p" #'+forge-create-pullreq-from-current-branch)


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
 :nvm "j" #'evil-backward-char
 :nvm ";" #'evil-forward-char

 :nvm "l" #'evil-previous-line
 :nvm "k" #'evil-next-line
      )

(map! :map ivy-occur-grep-mode-map
 :nvm "j" #'evil-backward-char
 :nvm ";" #'evil-forward-char

 :nvm "l" #'evil-previous-line
 :nvm "k" #'evil-next-line
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

(after! treemacs-evil
  (evil-define-key 'treemacs treemacs-mode-map "k" #'evil-next-line)
  (evil-define-key 'treemacs treemacs-mode-map "l" #'evil-previous-line)

  (evil-define-key 'treemacs treemacs-mode-map ";" #'evil-forward-char)
  (evil-define-key 'treemacs treemacs-mode-map "j" #'evil-backward-char)
  )


(setq plantuml-default-exec-mode 'jar)
(setq org-plantuml-jar-path (expand-file-name "/usr/local/Cellar/plantuml/1.2021.12/libexec/plantuml.jar"))



(setq doom-modeline-major-mode-icon t)

;; (after! eshell
;;   (add-to-list 'eshell-visual-commands "docker"))

(  add-to-list 'auth-sources "~/.authinfo")

;; @see https://bitbucket.org/lyro/evil/issue/511/let-certain-minor-modes-key-bindings
(with-eval-after-load 'git-timemachine
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

(setq magit-commit-show-diff nil)
;;(eval-after-load 'tramp-remote-path
 ;; (add-to-list 'tramp-remote-path "/root/.asdf/shims"))

(set-eshell-alias!
 "kc" "kubectl $*"
 "dd" "(+eshell-switch-directory-in-project)"
 )

;; Save sessions history
(progn
  (setq savehist-save-minibuffer-history 1)
  (setq savehist-additional-variables
        '(kill-ring search-ring regexp-search-ring compile-history log-edit-comment-ring)
        savehist-file "~/.emacs.d/savehist")
  (savehist-mode t))



(after! popup
  (progn
    (set-popup-rule! "^\\*helpful" :side 'top :size 0.40)
    (set-popup-rule! "^\\*compilation" :side 'right :size 0.40 :quit t)
    (set-popup-rule! "^\\*Man" :side 'right :size 0.40)
    (set-popup-rule! "^\\magit" :side 'right :size 0.40)))

(after! lsp
  ;; override the project root function to auto-guess the
  ;; project root based on the custom workspaces structure
  (defun lsp--suggest-project-root ()
    (let ((top-level-project-dirs (f-directories
                                   (condition-case nil
                                       (projectile-project-root)
                                     (error nil))) )
          (buffer-dir default-directory)
          )

      (-filter (lambda (d) (or (f-same? d buffer-dir) (f-ancestor-of? d buffer-dir))) top-level-project-dirs)


      )
    )

  (setq lsp-auto-guess-root t)
  (setq lsp-file-watch-threshold 2000)

  )

(require 'dash)
(-map (lambda (x) (load! x)) (directory-files-recursively extras-dir ".*\\.el$"))
