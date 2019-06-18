;;; init.el -*- lexical-binding: t; -*-

(setq pos-tip-foreground-color "#bbc2cf")
(setq pos-tip-background-color "#282c34")

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
 tooltip
 ivy
 company
 lsp
 projects
 ;;debugger

 :languages
 emacs-lisp
 go
 java
 puppet
 swift
 xml

 :apps
 discord

 :wrappers
 file-templates
 snippets

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
 file-templates
 (evil
  +everywhere)
 fold
 multiple-cursors
 lispy
 rotate-text
 snippets

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
 plantuml
 rest
 ruby

 :app
 regex
 (write
  +langtool
  )
 :config)
