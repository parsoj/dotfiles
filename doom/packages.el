;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

(package! straight :pin "3eca39d")

;; Used by config.el/keybinds/leader.el
(package! hide-mode-line)

;; Git stuff
;; Keep transient interpreted. In this setup straight byte-compiles transient
;; without compat's `static-when' macro expanded, producing a broken .elc on
;; Emacs 30. Source loading works and is the Doom/Magit-compatible version.
(package! transient
  :recipe (:host github :repo "magit/transient"
           :files ("lisp/*.el")
           :build (:not compile native-compile))
  :pin "1856230dc181f23dd15026b0ad21d8b299b034d1")

;; Newer Magit requires these, but this config's pinned dependency graph did not
;; add them to the build load-path reliably.
(package! llama)
(package! magit-section)
(package! with-editor)
(package! emacsql)
(package! treepy)
(package! blamer)

;; Native ACP-based agent-shell experiment for Pi.
(package! agent-shell
  :recipe (:host github :repo "xenodium/agent-shell"))

;; ANSI terminal emulator experiment for running Pi's native TUI while keeping
;; Emacs buffer navigation modes available.
(package! eat
  :recipe (:type git :repo "https://codeberg.org/akib/emacs-eat"))

;; a better elisp HTTP lib
(package! plz
  :recipe (:host github :repo "alphapapa/plz.el")
  )

(package! bookmark+
  :recipe (:host github :repo "emacsmirror/bookmark-plus")
  )

(package! aggressive-indent)

(package! graphql-mode)

(package! org-super-agenda)
;; (package! org-ql)
(package! org-edna)
(package! ob-restclient)

(package! groovy-mode)

(package! slack)

(package! protobuf-mode)

(package! applescript-mode)
(package! osascripts
  :recipe (:host github :repo "leoliu/osascripts" ))
