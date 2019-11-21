;;; code-blocks.el --- allow for editing code blocks in markdown or org  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Jeff Parsons

;; Author: Jeff Parsons <jeffp@MacBook-Pro-9.local>
;; Keywords: abbrev,c, abbrev,


(use-package mmm-mode
  :config
  (setq mmm-global-mode 'maybe)
  (mmm-add-classes
   '((markdown-go
      :submode go-mode
      :front "^```go[\n\r]+"
      :back "^```$")))
  
  (mmm-add-mode-ext-class 'markdown-mode nil 'markdown-go)

)
