;;; keybinds/evil.el -*- lexical-binding: t; -*-



(defvar +default-minibuffer-maps
  (append '(minibuffer-local-map
            minibuffer-local-ns-map
            minibuffer-local-completion-map
            minibuffer-local-must-match-map
            minibuffer-local-isearch-map
            read-expression-map)
          (cond ((featurep! :completion ivy)
                 '(ivy-minibuffer-map
                   ivy-switch-buffer-map))
                ((featurep! :completion helm)
                 '(helm-map
                   helm-rg-map
                   helm-read-file-map))))
  "A list of all the keymaps used for the minibuffer.")


  ;; NOTE SPC u replaces C-u as the universal argument.

  ;; Minibuffer
  (map! :map (evil-ex-completion-map evil-ex-search-keymap)
        "C-a" #'evil-beginning-of-line
        "C-b" #'evil-backward-char
        "C-f" #'evil-forward-char
        :gi "C-j" #'next-complete-history-element
        :gi "C-k" #'previous-complete-history-element)

  (define-key! :keymaps +default-minibuffer-maps
    [escape] #'abort-recursive-edit
    "C-a"    #'move-beginning-of-line
    "C-r"    #'evil-paste-from-register
    "C-u"    #'evil-delete-back-to-indentation
    "C-v"    #'yank
    "C-w"    #'doom/delete-backward-word
    "C-z"    (cmd! (ignore-errors (call-interactively #'undo))))

  (define-key! :keymaps +default-minibuffer-maps
    "C-j"    #'next-line
    "C-k"    #'previous-line
    "C-S-j"  #'scroll-up-command
    "C-S-k"  #'scroll-down-command)
  ;; For folks with `evil-collection-setup-minibuffer' enabled
  (define-key! :states 'insert :keymaps +default-minibuffer-maps
    "C-j"    #'next-line
    "C-k"    #'previous-line)

  (define-key! read-expression-map
    "C-j" #'next-line-or-history-element
    "C-k" #'previous-line-or-history-element)

;;********************************************************************************

;;(progn
;;  (define-key evil-normal-state-map "h" nil)
;;  (define-key evil-normal-state-map "j" nil)
;;  (define-key evil-normal-state-map "k" nil)
;;  (define-key evil-normal-state-map "l" nil)
;;  (define-key evil-normal-state-map ";" nil)
;;
;;  (define-key evil-motion-state-map "j" 'evil-backward-char)
;;  (define-key evil-motion-state-map "k" 'evil-next-line)
;;  (define-key evil-motion-state-map "l" 'evil-previous-line)
;;  (define-key evil-motion-state-map ";" 'evil-forward-char)
;;
;;  )


;;(map!
;; :nvmo "j" #'evil-backward-char
;; :nvmo ";" #'evil-forward-char
;;
;; :nvmo "l" #'evil-previous-line
;; :nvmo "k" #'evil-next-line
;; )
;;
;;(map! :map magit-mode-map :after magit
;; :nvm "j" #'evil-backward-char
;; :nvm ";" #'evil-forward-char
;;
;; :nvm "l" #'evil-previous-line
;; :nvm "k" #'evil-next-line
;;      )
;;
;;
;;(map! :map ivy-occur-mode-map
;; :nvme "j" #'evil-backward-char
;; :nvme ";" #'evil-forward-char
;;
;; :nvme "l" #'evil-previous-line
;; :nvme "k" #'evil-next-line
;;      )
;;
;;(map! :map ivy-occur-grep-mode-map
;; :nvme "j" #'evil-backward-char
;; :nvme ";" #'evil-forward-char
;;
;; :nvme "l" #'evil-previous-line
;; :nvme "k" #'evil-next-line
;;      )
;;
;;(after! treemacs-evil
;;  (evil-define-key 'treemacs treemacs-mode-map "k" #'evil-next-line)
;;  (evil-define-key 'treemacs treemacs-mode-map "l" #'evil-previous-line)
;;
;;  (evil-define-key 'treemacs treemacs-mode-map ";" #'evil-forward-char)
;;  (evil-define-key 'treemacs treemacs-mode-map "j" #'evil-backward-char)
;;  )
