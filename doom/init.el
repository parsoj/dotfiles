;;; init.el -*- lexical-binding: t; -*-
;; Copy me to ~/.doom.d/init.el or ~/.config/doom/init.el, then edit me!
;;

(setq doom-localleader-key ",")

(setq evil-collection-key-blacklist
      (list "C-j" "C-k" "gd" "gf" "K" "[" "]" "gz"
            doom-leader-key doom-localleader-key
            doom-leader-alt-key doom-localleader-alt-key))

(def-package-hook! evil-snipe
  :pre-init
  (setq evil-snipe-override-evil-repeat-keys nil)
  )

(after! evil
  (define-key! evil-motion-state-map "," nil)
  )

(doom!

;;*************************************************************************
;; Personal Modules


 :theme

 ;;*************************************************************************
 ;;*************************************************************************
 ;;*************************************************************************
 ;;Doom-provided modules

 :editor
 (evil +everywhere); come to the dark side, we have cookies
 workspaces        ; tab emulation, persistence & separate workspaces
 snippets
 (lookup
  +docsets
  )

 :completion
 (company
  +auto
  +childframe
  )
 (ivy
  +fuzzy
  +childframe
  )

 :ui
 doom-one
 doom-dashboard    ; a nifty splash screen for Emacs
 fill-column       ; a `fill-column' indicator
 hl-todo           ; highlight TODO/FIXME/NOTE tags
 modeline          ; snazzy, Atom-inspired modeline, plus API
 nav-flash         ; blink the current line after jumping
 treemacs          ; a project drawer, like neotree but cooler
 (popup            ; tame sudden yet inevitable temporary windows
  +all             ; catch all popups that start with an asterix
  +defaults)       ; default popup rules
 pretty-code       ; replace bits of code with pretty symbols
 unicode           ; extended unicode support for various languages
 vc-gutter         ; vcs diff in the fringe
 window-select     ; visually switch windows
 indent-guides

 :editor
 fold              ; (nigh) universal code folding
 multiple-cursors  ; editing in many places at once

 :emacs
 (dired            ; making dired pretty [functional]
  +ranger         ; bringing the goodness of ranger to dired
  +icons          ; colorful icons for dired-mode
  )
 electric          ; smarter, keyword-based electric-indent
 imenu             ; an imenu sidebar and searchable code index
 jeffp-eshell

 :tools
 puppet
 vagrant
 docker
 terraform
 flycheck          ; tasing you for every semicolon you forget
 flyspell          ; tasing you for misspelling mispelling
 gist              ; interacting with github gists
 (lsp
  +lsp-mode
  +lsp-ui
  +company-lsp
  )
 macos             ; MacOS-specific commands
 magit             ; a git porcelain for Emacs
 make              ; run make tasks from Emacs

 :lang
 emacs-lisp        ; drown in parentheses
 go                ; the hipster dialect
 kotlin            ; a better, slicker Java(Script)
 markdown          ; writing docs for people to ignore
 (org              ; organize your plain life in plain text
  +attach          ; custom attachment system
  +babel           ; running code in org
  +capture         ; org-capture in and outside of Emacs
  +export          ; Exporting org to whatever you want
  +present         ; Emacs for presentations
  +protocol)       ; Support for org-protocol:// links
 perl              ; write code no one else can comprehend
 (php
  +lsp)               ; perl's insecure younger brother
 plantuml          ; diagrams for confusing people more
 rest              ; Emacs as a REST client
 ruby              ; 1.step do {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}

)
