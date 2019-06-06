;;; init.el -*- lexical-binding: t; -*-


(setq doom-localleader-key ",")

(def-package-hook! evil-snipe
  :pre-init
  (setq evil-snipe-override-evil-repeat-keys nil)
  )

(after! evil
  (define-key! evil-motion-state-map "," nil)
  )


(setq +vc-gutter-default-style nil)

(doom!

 :parsoj
 emacs-lisp
 projects
 eshell
 java
 puppet
 slack
 sql
 theme
 vagrant
 xml

 :completion
 parsoj-company
 (company
  +auto
  +childframe
  )

 parsoj-ivy
 (ivy
  +fuzzy
  +childframe
  +icons
  )

 :ui
 doom-dashboard


 hl-todo
 modeline
 nav-flash
 treemacs
 (popup
  +all
  +defaults)
 (pretty-code
  +fira
  )
 unicode
 vc-gutter
 (window-select
  +numbers
  )
 indent-guides
 ophints
 workspaces

 :editor
 (evil +everywhere)
 snippets
 fold
 multiple-cursors
 parsoj-file-templates
 file-templates
 lispy
 rotate-text

 :emacs
 (dired
  +ranger
  +icons
  )
 electric
 vc

 :term
 term

 :tools
 docker
 terraform
 (flycheck
  +childframe
  )
 flyspell
 gist
 parsoj-lsp
 lsp
 macos
 parsoj-magit
 magit
 make
 (lookup
  +docsets
  )
 prodigy

 :lang
 swift
 go
 kotlin
 markdown
 (org
  +attach
  +babel
  +capture
  +export
  +present
  +protocol)
 perl
 (php
  +lsp)
 plantuml
 rest
 ruby

 :app
 regex
 (write
  +langtool
  )
 :config)
