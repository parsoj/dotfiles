;;; init.el -*- lexical-binding: t; -*-
;; Copy me to ~/.doom.d/init.el or ~/.config/doom/init.el, then edit me!
;;
;;

(setq doom-localleader-key ",")

(def-package-hook! evil-snipe
  :pre-init
  (setq evil-snipe-override-evil-repeat-keys nil)
  )

(after! evil
  (define-key! evil-motion-state-map "," nil)
  )

(setq +ivy-buffer-preview t)

(setq +vc-gutter-default-style nil)


(doom!

 :completion
 (company
  +auto
  +childframe
  )
 (ivy
  +fuzzy
  +childframe
  +icons
  )

 :ui
 doom-one
 doom-dashboard                         ; a nifty splash screen for Emacs

 ;;fill-column       ; a `fill-column' indicator
 hl-todo                          ; highlight TODO/FIXME/NOTE tags
 modeline                         ; snazzy, Atom-inspired modeline, plus API
 nav-flash                        ; blink the current line after jumping
 treemacs                         ; a project drawer, like neotree but cooler
 (popup                           ; tame sudden yet inevitable temporary windows
  +all                            ; catch all popups that start with an asterix
  +defaults)                      ; default popup rules
 (pretty-code
  +fira
  )                             ; replace bits of code with pretty symbols
 unicode                        ; extended unicode support for various languages
 vc-gutter
 (window-select
  +numbers
  )                                     ; visually switch windows
 indent-guides
 ophints
 workspaces                   ; tab emulation, persistence & separate workspaces

 :editor
 (evil +everywhere)                     ; come to the dark side, we have cookies
 snippets
 fold                                   ; (nigh) universal code folding
 multiple-cursors                       ; editing in many places at once
 file-templates
 lispy
 rotate-text

 :emacs
 projects
 (dired                               ; making dired pretty [functional]
  +ranger                             ; bringing the goodness of ranger to dired
  +icons                              ; colorful icons for dired-mode
  )
 electric                               ; smarter, keyword-based electric-indent
 vc
 jeffp-eshell

 :term
 term

 :tools
 puppet
 vagrant
 docker
 terraform
 (flycheck
  +childframe
  )                                  ; tasing you for every semicolon you forget
 flyspell                            ; tasing you for misspelling mispelling
 gist                                ; interacting with github gists
 lsp
 macos                                  ; MacOS-specific commands
 magit                                  ; a git porcelain for Emacs
 make                                   ; run make tasks from Emacs
 (lookup
  +docsets
  )
 prodigy

 :lang
 emacs-lisp                             ; drown in parentheses
 go                                     ; the hipster dialect
 kotlin                                 ; a better, slicker Java(Script)
 jeffp-java
 markdown                               ; writing docs for people to ignore
 xml
 (org                                   ; organize your plain life in plain text
  +attach                               ; custom attachment system
  +babel                                ; running code in org
  +capture                              ; org-capture in and outside of Emacs
  +export                               ; Exporting org to whatever you want
  +present                              ; Emacs for presentations
  +protocol)                            ; Support for org-protocol:// links
 perl                                   ; write code no one else can comprehend
 (php
  +lsp)               ; perl's insecure younger brother
 plantuml             ; diagrams for confusing people more
 rest                 ; Emacs as a REST client
 ruby                 ; 1.step do {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}

 :app
 slack
 regex
 (write
  +langtool
  )
 :config)
