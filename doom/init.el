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

(setq +file-templates-dir "~/.config/doom/templates")
(defvar +file-templates-alist
  `(
    (gitignore-mode)
    (dockerfile-mode)
    ("/docker-compose\\.yml$" :mode yaml-mode)
    ("/Makefile$"             :mode makefile-gmake-mode)
    ;; elisp
    ("/.dir-locals\\.el$")
    ("/packages\\.el$" :when +file-templates-in-emacs-dirs-p
     :trigger "__doom-packages"
     :mode emacs-lisp-mode)
    ("/doctor\\.el$" :when +file-templates-in-emacs-dirs-p
     :trigger "__doom-doctor"
     :mode emacs-lisp-mode)
    ("/test/.+\\.el$" :when +file-templates-in-emacs-dirs-p
     :trigger "__doom-test"
     :mode emacs-lisp-mode)
    ("\\.el$" :when +file-templates-in-emacs-dirs-p
     :trigger "__doom-module"
     :mode emacs-lisp-mode)
    ("-test\\.el$" :mode emacs-ert-mode)
    (emacs-lisp-mode :trigger "__initfile")
    (snippet-mode)
    ;; C/C++
    ("/main\\.c\\(?:c\\|pp\\)$"   :trigger "__main.cpp"    :mode c++-mode)
    ("/win32_\\.c\\(?:c\\|pp\\)$" :trigger "__winmain.cpp" :mode c++-mode)
    ("\\.c\\(?:c\\|pp\\)$"        :trigger "__cpp" :mode c++-mode)
    ("\\.h\\(?:h\\|pp\\|xx\\)$"   :trigger "__hpp" :mode c++-mode)
    ("\\.h$" :trigger "__h" :mode c-mode)
    (c-mode  :trigger "__c")
    ;; go
    ("/main\\.go$" :trigger "__main.go" :mode go-mode :project t)
    (go-mode :trigger "__.go")
    ;; web-mode
    ("/normalize\\.scss$" :trigger "__normalize.scss" :mode scss-mode)
    ("/master\\.scss$" :trigger "__master.scss" :mode scss-mode)
    ("\\.html$" :trigger "__.html" :mode web-mode)
    (scss-mode)
    ;; java
    ("/main\\.java$" :trigger "__main" :mode java-mode)
    ("/build\\.gradle$" :trigger "__build.gradle" :mode android-mode)
    ("/src/.+\\.java$" :mode java-mode)
    ;; javascript
    ("/package\\.json$"        :trigger "__package.json" :mode json-mode)
    ("/bower\\.json$"          :trigger "__bower.json" :mode json-mode)
    ("/gulpfile\\.js$"         :trigger "__gulpfile.js" :mode js-mode)
    ("/webpack\\.config\\.js$" :trigger "__webpack.config.js" :mode js-mode)
    ("\\.js\\(?:on\\|hintrc\\)$" :mode json-mode)
    ;; Lua
    ("/main\\.lua$" :trigger "__main.lua" :mode love-mode)
    ("/conf\\.lua$" :trigger "__conf.lua" :mode love-mode)
    ;; Markdown
    (markdown-mode)
    ;; Org
    ("/README\\.org$"
     :when +file-templates-in-emacs-dirs-p
     :trigger "__doom-readme"
     :mode org-mode)

    ("/PROJECT_NOTES\\.org$"
     :when +file-templates-in-emacs-dirs-p
     :trigger "__project_notes.org"
     :mode org-mode
     )
    ("\\.org$" :trigger "__" :mode org-mode)
    ;; PHP
    ("\\.class\\.php$" :trigger "__.class.php" :mode php-mode)
    (php-mode)
    ;; Python
    ;; TODO ("tests?/test_.+\\.py$" :trigger "__" :mode nose-mode)
    ;; TODO ("/setup\\.py$" :trigger "__setup.py" :mode python-mode)
    (python-mode)
    ;; Ruby
    ("/lib/.+\\.rb$"      :trigger "__module"   :mode ruby-mode :project t)
    ("/spec_helper\\.rb$" :trigger "__helper"   :mode rspec-mode :project t)
    ("_spec\\.rb$"                              :mode rspec-mode :project t)
    ("/\\.rspec$"         :trigger "__.rspec"   :mode rspec-mode :project t)
    ("\\.gemspec$"        :trigger "__.gemspec" :mode ruby-mode :project t)
    ("/Gemfile$"          :trigger "__Gemfile"  :mode ruby-mode :project t)
    ("/Rakefile$"         :trigger "__Rakefile" :mode ruby-mode :project t)
    (ruby-mode)
    ;; Rust
    ("/Cargo.toml$" :trigger "__Cargo.toml" :mode rust-mode)
    ("/main\\.rs$" :trigger "__main.rs" :mode rust-mode)
    ;; Slim
    ("/\\(?:index\\|main\\)\\.slim$" :mode slim-mode)
    ;; Shell scripts
    ("\\.zunit$" :trigger "__zunit" :mode sh-mode)
    (fish-mode)
    (sh-mode)
    ;; Solidity
    (solidity-mode :trigger "__sol"))

  )

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
 (dired                               ; making dired pretty [functional]
  +ranger                             ; bringing the goodness of ranger to dired
  +icons                              ; colorful icons for dired-mode
  )
 electric                               ; smarter, keyword-based electric-indent
 vc

 :term
 term

 :tools
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
 swift
 go                                     ; the hipster dialect
 kotlin                                 ; a better, slicker Java(Script)
 markdown                               ; writing docs for people to ignore
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
 regex
 (write
  +langtool
  )
 :config)
