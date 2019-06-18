;;; editor/parsoj-file-templates/init.el -*- lexical-binding: t; -*-

(setq
 +file-templates-dir "~/.config/doom/templates/"
 )

(setq +file-templates-alist
  `(;; General
    (gitignore-mode)
    (dockerfile-mode)
    ("/docker-compose\\.yml$" :mode yaml-mode)
    ("/Makefile$"             :mode makefile-gmake-mode)
    ;; elisp
    ("/.dir-locals.el$")
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
    (solidity-mode :trigger "__sol")))
