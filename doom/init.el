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

;;; My Stuff
 :core
 treemacs
 magit
 theme
 eshell

 :editor
 ivy
 company
 snippets
 file-templates
 lsp
 projects

 :lang
 emacs-lisp
 go
 java
 puppet
 swift
 xml

;;; Doom's stuff
 :ui
 doom-dashboard

 hl-todo
 modeline
 nav-flash
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
 (evil
  +everywhere)
 snippets
 fold
 multiple-cursors
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
 lsp
 docker
 terraform
 (flycheck
  +childframe
  )
 flyspell
 gist
 macos
 make
 (lookup
  +docsets
  )
 prodigy

 :lang
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
