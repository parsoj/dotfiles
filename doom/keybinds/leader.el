;;; keybinds/leader.el -*- lexical-binding: t; -*-
;;;

(map! :g "s-w" (cmd! (delete-frame nil t)))


(map! :leader

      :desc "Command Pallaete" "SPC" #'execute-extended-command

      :desc "Eval expression"       ";"    #'pp-eval-expression
      :desc "M-x"                   ":"    #'execute-extended-command
      :desc "Pop up scratch buffer" "x"    #'doom/open-scratch-buffer
      :desc "Org Capture"           "X"    #'org-capture
      ;; C-u is used by evil
      :desc "Universal argument"    "u"    #'universal-argument
      :desc "window"                "w"    evil-window-map
      :desc "help"                  "h"    help-map

      (:when (featurep! :ui popup)
       :desc "Toggle last popup"     "~"    #'+popup/toggle)

      :desc "Find file"             "."    #'find-file
      :desc "Switch buffer"         ","    #'switch-to-buffer

      (:when (featurep! :ui workspaces)
       :desc "Switch workspace buffer" "," #'persp-switch-to-buffer
       :desc "Switch buffer"           "<" #'switch-to-buffer)
      :desc "Switch to last buffer" "`"    #'evil-switch-to-windows-last-buffer
      :desc "Resume last search"    "'" #'vertico-repeat

      :desc "Search for symbol in project" "*" #'(cmd! (+vertico/project-search nil symbol dir))
      :desc "Search project"               "/" #'+vertico/project-search

      :desc "Jump to bookmark"      "RET"  #'bookmark-jump

      ;;; <leader> TAB --- workspace
      ;;(:when (featurep! :ui workspaces)
      ;; (:prefix-map ("TAB" . "workspace")
      ;;  :desc "Display tab bar"           "TAB" #'+workspace/display
      ;;  :desc "Switch workspace"          "."   #'+workspace/switch-to
      ;;  :desc "Switch to last workspace"  "`"   #'+workspace/other
      ;;  :desc "New workspace"             "n"   #'+workspace/new
      ;;  :desc "New named workspace"       "N"   #'+workspace/new-named
      ;;  :desc "Load workspace from file"  "l"   #'+workspace/load
      ;;  :desc "Save workspace to file"    "s"   #'+workspace/save
      ;;  :desc "Delete session"            "x"   #'+workspace/kill-session
      ;;  :desc "Delete this workspace"     "d"   #'+workspace/delete
      ;;  :desc "Rename workspace"          "r"   #'+workspace/rename
      ;;  :desc "Restore last session"      "R"   #'+workspace/restore-last-session
      ;;  :desc "Next workspace"            "]"   #'+workspace/switch-right
      ;;  :desc "Previous workspace"        "["   #'+workspace/switch-left
      ;;  :desc "Switch to 1st workspace"   "1"   #'+workspace/switch-to-0
      ;;  :desc "Switch to 2nd workspace"   "2"   #'+workspace/switch-to-1
      ;;  :desc "Switch to 3rd workspace"   "3"   #'+workspace/switch-to-2
      ;;  :desc "Switch to 4th workspace"   "4"   #'+workspace/switch-to-3
      ;;  :desc "Switch to 5th workspace"   "5"   #'+workspace/switch-to-4
      ;;  :desc "Switch to 6th workspace"   "6"   #'+workspace/switch-to-5
      ;;  :desc "Switch to 7th workspace"   "7"   #'+workspace/switch-to-6
      ;;  :desc "Switch to 8th workspace"   "8"   #'+workspace/switch-to-7
      ;;  :desc "Switch to 9th workspace"   "9"   #'+workspace/switch-to-8
      ;;  :desc "Switch to final workspace" "0"   #'+workspace/switch-to-final))

      ;;; <leader> b --- buffer
      (:prefix-map ("b" . "buffer")
       :desc "Toggle narrowing"            "-"   #'doom/toggle-narrow-buffer
       :desc "Previous buffer"             "["   #'previous-buffer
       :desc "Next buffer"                 "]"   #'next-buffer
       (:when (featurep! :ui workspaces)
        :desc "Switch workspace buffer" "b" #'persp-switch-to-buffer
        :desc "Switch buffer"           "B" #'switch-to-buffer)
       (:unless (featurep! :ui workspaces)
        :desc "Switch buffer"           "b" #'switch-to-buffer)
       :desc "Clone buffer"                "c"   #'clone-indirect-buffer
       :desc "Clone buffer other window"   "C"   #'clone-indirect-buffer-other-window
       :desc "Kill buffer"                 "d"   #'kill-current-buffer
       :desc "ibuffer"                     "i"   #'ibuffer
       :desc "Kill buffer"                 "k"   #'kill-current-buffer
       :desc "Kill all buffers"            "K"   #'doom/kill-all-buffers
       :desc "Switch to last buffer"       "l"   #'evil-switch-to-windows-last-buffer
       :desc "Set bookmark"                "m"   #'bookmark-set
       :desc "Delete bookmark"             "M"   #'bookmark-delete
       :desc "Next buffer"                 "n"   #'next-buffer
       :desc "New empty buffer"            "N"   #'evil-buffer-new
       :desc "Kill other buffers"          "O"   #'doom/kill-other-buffers
       :desc "Previous buffer"             "p"   #'previous-buffer
       :desc "Revert buffer"               "r"   #'revert-buffer
       :desc "rename buffer"               "R"   #'rename-buffer
       :desc "Save buffer"                 "s"   #'basic-save-buffer
       :desc "Save all buffers"            "S"   #'evil-write-all
       :desc "Save buffer as root"         "u"   #'doom/sudo-save-buffer
       :desc "Pop up scratch buffer"       "x"   #'doom/open-scratch-buffer
       :desc "Switch to scratch buffer"    "X"   #'doom/switch-to-scratch-buffer
       :desc "Bury buffer"                 "z"   #'bury-buffer
       :desc "Kill buried buffers"         "Z"   #'doom/kill-buried-buffers)

      ;;; <leader> c --- code
      (:prefix-map ("c" . "code")
       (:when (and (featurep! :tools lsp) (not (featurep! :tools lsp +eglot)))
        :desc "LSP Execute code action" "a" #'lsp-execute-code-action
        :desc "LSP Organize imports" "o" #'lsp-organize-imports
         :desc "Jump to symbol in current workspace" "j"   #'consult-lsp-symbols
         :desc "Jump to symbol in any workspace"     "J"   (cmd!! #'consult-lsp-symbols 'all-workspaces)
        (:when (featurep! :ui treemacs +lsp)
         :desc "Errors list"                         "X"   #'lsp-treemacs-errors-list
         :desc "Incoming call hierarchy"             "y"   #'lsp-treemacs-call-hierarchy
         :desc "Outgoing call hierarchy"             "Y"   (cmd!! #'lsp-treemacs-call-hierarchy t)
         :desc "References tree"                     "R"   (cmd!! #'lsp-treemacs-references t)
         :desc "Symbols"                             "S"   #'lsp-treemacs-symbols)
         :desc "LSP Rename"                          "r"   #'lsp-rename)
       (:when (featurep! :tools lsp +eglot)
        :desc "LSP Execute code action" "a" #'eglot-code-actions
        :desc "LSP Rename" "r" #'eglot-rename
        :desc "LSP Find declaration"                 "j"   #'eglot-find-declaration
        :desc "Jump to symbol in current workspace" "j"   #'consult-eglot-symbols)
       :desc "Compile"                               "c"   #'compile
       :desc "Recompile"                             "C"   #'recompile

       ;:desc "Jump to definition"                    "d"   #'+lookup/definition
       :desc "Jump to definition"                    "d"   #'+lsp-lookup-definition-handler
       ;:desc "Jump to references"                    "r"   #'+lookup/references
       :desc "Jump to references"                    "r"   #'+lsp-lookup-references-handler
       ;:desc "Find implementations"                  "i"   #'+lookup/implementations
       :desc "Find implementations"                  "i"   #'lsp-find-implementation


       :desc "Evaluate buffer/region"                "e"   #'+eval/buffer-or-region
       :desc "Evaluate & replace region"             "E"   #'+eval:replace-region
       :desc "Format buffer/region"                  "f"   #'+format/region-or-buffer
       :desc "Jump to documentation"                 "k"   #'+lookup/documentation
       :desc "Send to repl"                          "s"   #'+eval/send-region-to-repl
       :desc "Find type definition"                  "t"   #'+lookup/type-definition
       :desc "Delete trailing whitespace"            "w"   #'delete-trailing-whitespace
       :desc "Delete trailing newlines"              "W"   #'doom/delete-trailing-newlines
       :desc "next error"                            "x"   #'flycheck-next-error
       :desc "List errors"                           "X"   #'flycheck-list-errors
       )

      ;;; <leader> f --- file
      (:prefix-map ("f" . "file")
       :desc "Open project editorconfig"   "c"   #'editorconfig-find-current-editorconfig
       :desc "Copy this file"              "C"   #'doom/copy-this-file
       ;:desc "Find directory"              "d"   #'+default/dired
       :desc "Delete this file"            "D"   #'doom/delete-this-file
       :desc "Find file in emacs.d"        "e"   #'doom/find-file-in-emacsd
       :desc "Browse emacs.d"              "E"   #'doom/browse-in-emacsd
       :desc "Find file"                   "f"   #'find-file
       :desc "Find file from here"         "F"   #'++find-file-under-here
       :desc "Locate file"                 "l"   #'locate
       :desc "Find file in private config" "p"   #'doom/find-file-in-private-config
       :desc "Browse private config"       "P"   #'doom/open-private-config
       :desc "Recent files"                "r"   #'recentf-open-files
       :desc "Rename/move file"            "R"   #'doom/move-this-file
       :desc "Save file"                   "s"   #'save-buffer
       :desc "Save file as..."             "S"   #'write-file
       :desc "Sudo find file"              "u"   #'doom/sudo-find-file
       :desc "Sudo this file"              "U"   #'doom/sudo-this-file
       :desc "Yank file path"              "y"   #'++yank-buffer-path
       :desc "Yank file path from project" "Y"   #'++yank-buffer-path-relative-to-project)

      ;;; <leader> g --- git/version control
      (:prefix-map ("g" . "git")
       :desc "Revert file"                 "R"   #'vc-revert
       :desc "Copy link to remote"         "y"   #'+vc/browse-at-remote-kill
       :desc "Copy link to homepage"       "Y"   #'+vc/browse-at-remote-kill-homepage
       (:when (featurep! :ui hydra)
        :desc "SMerge"                    "m"   #'+vc/smerge-hydra/body)
       (:when (featurep! :ui vc-gutter)
        (:when (featurep! :ui hydra)
         :desc "VCGutter"                "."   #'+vc/gutter-hydra/body)
        :desc "Revert hunk"               "r"   #'git-gutter:revert-hunk
        :desc "Git stage hunk"            "s"   #'git-gutter:stage-hunk
        :desc "Git time machine"          "t"   #'git-timemachine-toggle
        :desc "Jump to next hunk"         "]"   #'git-gutter:next-hunk
        :desc "Jump to previous hunk"     "["   #'git-gutter:previous-hunk)
       (:when (featurep! :tools magit)
        :desc "Magit dispatch"            "/"   #'magit-dispatch
        :desc "Magit file dispatch"       "."   #'magit-file-dispatch
        :desc "Forge dispatch"            "'"   #'forge-dispatch
        :desc "Magit switch branch"       "b"   #'magit-branch-checkout
        :desc "Magit status"              "g"   #'magit-status
        :desc "Magit status here"         "G"   #'magit-status-here
        :desc "Magit file delete"         "D"   #'magit-file-delete
        :desc "Magit blame"               "B"   #'magit-blame-addition
        :desc "Magit clone"               "C"   #'magit-clone
        :desc "Magit fetch"               "F"   #'magit-fetch
        :desc "Magit buffer log"          "L"   #'magit-log-buffer-file
        :desc "Git stage file"            "S"   #'magit-stage-file
        :desc "Git unstage file"          "U"   #'magit-unstage-file
        (:prefix ("f" . "find")
         :desc "Find file"                 "f"   #'magit-find-file
         :desc "Find gitconfig file"       "g"   #'magit-find-git-config-file
         :desc "Find commit"               "c"   #'magit-show-commit
         :desc "Find issue"                "i"   #'forge-visit-issue
         :desc "Find pull request"         "p"   #'forge-visit-pullreq)
        (:prefix ("o" . "open in browser")
         :desc "Browse file or region"     "o"   #'+vc/browse-at-remote
         :desc "Browse homepage"           "h"   #'+vc/browse-at-remote-homepage
         :desc "Browse remote"             "r"   #'forge-browse-remote
         :desc "Browse commit"             "c"   #'forge-browse-commit
         :desc "Browse an issue"           "i"   #'forge-browse-issue
         :desc "Browse a pull request"     "p"   #'forge-browse-pullreq
         :desc "Browse issues"             "I"   #'forge-browse-issues
         :desc "Browse pull requests"      "P"   #'forge-browse-pullreqs)
        (:prefix ("l" . "list")
         (:when (featurep! :tools gist)
          :desc "List gists"              "g"   #'+gist:list)
         :desc "List repositories"         "r"   #'magit-list-repositories
         :desc "List submodules"           "s"   #'magit-list-submodules
         :desc "List issues"               "i"   #'forge-list-issues
         :desc "List pull requests"        "p"   #'forge-list-pullreqs
         :desc "List notifications"        "n"   #'forge-list-notifications)
        (:prefix ("c" . "create")
         :desc "Initialize repo"           "r"   #'magit-init
         :desc "Clone repo"                "R"   #'magit-clone
         :desc "Commit"                    "c"   #'magit-commit-create
         :desc "Fixup"                     "f"   #'magit-commit-fixup
         :desc "Branch"                    "b"   #'magit-branch-and-checkout
         :desc "Issue"                     "i"   #'forge-create-issue
        ; :desc "Pull request"              "p"   #'forge-create-pullreq
        :desc "Pull request"              "p"   #'+create-pullreq
         )))

      ;;; <leader> i --- insert
      (:prefix-map ("i" . "insert")
       :desc "Emoji"                         "e"   #'emojify-insert-emoji
       :desc "Current file name"             "f"   #'++insert-file-path
       :desc "Current file path"             "F"   (cmd!! #'++insert-file-path t)
       :desc "Evil ex path"                  "p"   (cmd! (evil-ex "R!echo "))
       :desc "From evil register"            "r"   #'evil-show-registers
       :desc "Snippet"                       "s"   #'yas-insert-snippet
       :desc "Unicode"                       "u"   #'insert-char
       :desc "From clipboard"                "y"   #'consult-yank-pop

       :desc "aya expand" "i i" #'aya-expand
       )




       (:prefix-map ("r" . "register")
        :desc "yank to register" "r y" #'copy-to-register
        :desc "yank to register" "r i" #'insert-register
                    )

      ;;; <leader> n --- notes
      (:prefix-map ("n" . "notes")
       :desc "Org agenda"                   "a" #'org-agenda
       (:when (featurep! :tools biblio)
        :desc "Bibliographic entries"        "b" #'citar-open-entry)

       :desc "Toggle last org-clock"        "c" #'+org/toggle-last-clock
       :desc "Cancel current org-clock"     "C" #'org-clock-cancel
       :desc "Open deft"                    "d" #'deft
       (:when (featurep! :lang org +noter)
        :desc "Org noter"                  "e" #'org-noter)

       :desc "Org store link"               "l" #'org-store-link
       :desc "Tags search"                  "m" #'org-tags-view
       :desc "Org capture"                  "n" #'org-capture
       :desc "Goto capture"                 "N" #'org-capture-goto-target
       :desc "Active org-clock"             "o" #'org-clock-goto
       :desc "Todo list"                    "t" #'org-todo-list
       :desc "View search"                  "v" #'org-search-view
       :desc "Org export to clipboard"        "y" #'+org/export-to-clipboard
       :desc "Org export to clipboard as RTF" "Y" #'+org/export-to-clipboard-as-rich-text


;       (:when (featurep! :lang org +roam2)
;        (:prefix ("r" . "roam")
;         :desc "Open random node"           "a" #'org-roam-node-random
;         :desc "Find node"                  "f" #'org-roam-node-find
;         :desc "Find ref"                   "F" #'org-roam-ref-find
;         :desc "Show graph"                 "g" #'org-roam-graph
;         :desc "Insert node"                "i" #'org-roam-node-insert
;         :desc "Capture to node"            "n" #'org-roam-capture
;         :desc "Toggle roam buffer"         "r" #'org-roam-buffer-toggle
;         :desc "Launch roam buffer"         "R" #'org-roam-buffer-display-dedicated
;         :desc "Sync database"              "s" #'org-roam-db-sync
;         (:prefix ("d" . "by date")
;          :desc "Goto previous note"        "b" #'org-roam-dailies-goto-previous-note
;          :desc "Goto date"                 "d" #'org-roam-dailies-goto-date
;          :desc "Capture date"              "D" #'org-roam-dailies-capture-date
;          :desc "Goto next note"            "f" #'org-roam-dailies-goto-next-note
;          :desc "Goto tomorrow"             "m" #'org-roam-dailies-goto-tomorrow
;          :desc "Capture tomorrow"          "M" #'org-roam-dailies-capture-tomorrow
;          :desc "Capture today"             "n" #'org-roam-dailies-capture-today
;          :desc "Goto today"                "t" #'org-roam-dailies-goto-today
;          :desc "Capture today"             "T" #'org-roam-dailies-capture-today
;          :desc "Goto yesterday"            "y" #'org-roam-dailies-goto-yesterday
;          :desc "Capture yesterday"         "Y" #'org-roam-dailies-capture-yesterday
;          :desc "Find directory"            "-" #'org-roam-dailies-find-directory)))

       (:when (featurep! :lang org +journal)
        (:prefix ("j" . "journal")
         :desc "New Entry"           "j" #'org-journal-new-entry
         :desc "New Scheduled Entry" "J" #'org-journal-new-scheduled-entry
         :desc "Search Forever"      "s" #'org-journal-search-forever)))

      ;;; <leader> o --- open
      (:prefix-map ("o" . "open")
       :desc "Org agenda"       "A"  #'org-agenda
       (:prefix ("a" . "org agenda")
        :desc "Agenda"         "a"  #'org-agenda
        :desc "Todo list"      "t"  #'org-todo-list
        :desc "Tags search"    "m"  #'org-tags-view
        :desc "View search"    "v"  #'org-search-view)
       :desc "Default browser"    "b"  #'browse-url-of-file
       :desc "Start debugger"     "d"  #'+debugger/start
       :desc "New frame"          "f"  #'make-frame
       :desc "Select frame"       "F"  #'select-frame-by-name
       :desc "REPL"               "r"  #'+eval/open-repl-other-window
       :desc "REPL (same window)" "R"  #'+eval/open-repl-same-window
       :desc "Dired"              "-"  #'dired-jump
       (:when (featurep! :ui neotree)
        :desc "Project sidebar"              "p" #'+neotree/open
        :desc "Find file in project sidebar" "P" #'+neotree/find-this-file)
       (:when (featurep! :ui treemacs)
        :desc "Project sidebar" "p" #'+treemacs/toggle
        :desc "Find file in project sidebar" "P" #'treemacs-find-file)
       (:when (featurep! :term shell)
        :desc "Toggle shell popup"    "t" #'+shell/toggle
        :desc "Open shell here"       "T" #'+shell/here)
       (:when (featurep! :term term)
        :desc "Toggle terminal popup" "t" #'+term/toggle
        :desc "Open terminal here"    "T" #'+term/here)
       (:when (featurep! :term vterm)
        :desc "Toggle vterm popup"    "t" #'+vterm/toggle
        :desc "Open vterm here"       "T" #'+vterm/here)
       (:when (featurep! :term eshell)
        :desc "Toggle eshell popup"   "e" #'+eshell/toggle
        :desc "Open eshell here"      "E" #'+eshell/here)
       (:when (featurep! :os macos)
        :desc "Reveal in Finder"           "o" #'+macos/reveal-in-finder
        :desc "Reveal project in Finder"   "O" #'+macos/reveal-project-in-finder
        :desc "Send to Transmit"           "u" #'+macos/send-to-transmit
        :desc "Send project to Transmit"   "U" #'+macos/send-project-to-transmit
        :desc "Send to Launchbar"          "l" #'+macos/send-to-launchbar
        :desc "Send project to Launchbar"  "L" #'+macos/send-project-to-launchbar
        :desc "Open in iTerm"              "i" #'+macos/open-in-iterm)
       (:when (featurep! :tools docker)
        :desc "Docker" "D" #'docker)
       (:when (featurep! :email mu4e)
        :desc "mu4e" "m" #'=mu4e)
       (:when (featurep! :email notmuch)
        :desc "notmuch" "m" #'=notmuch)
       (:when (featurep! :email wanderlust)
        :desc "wanderlust" "m" #'=wanderlust))

      ;;; <leader> p --- project
      (:prefix-map ("p" . "project")
       :desc "Browse other project"         ">" #'doom/browse-in-other-project
       :desc "Run cmd in project root"      "!" #'projectile-run-shell-command-in-root
       :desc "Async cmd in project root"    "&" #'projectile-run-async-shell-command-in-root
       :desc "Add new project"              "a" #'projectile-add-known-project
       :desc "Switch to project buffer"     "b" #'projectile-switch-to-buffer

       ;:desc "Compile in project"           "c" #'projectile-compile-project
       ;:desc "Repeat last command"          "C" #'projectile-repeat-last-command
       :desc "create new project"           "C" #'+create-new-workspace
       :desc "clone repo into project"      "c" #'clone-project-repo-for-organization

       :desc "Remove known project"         "d" #'projectile-remove-known-project
       :desc "Edit project .dir-locals"     "e" #'projectile-edit-dir-locals
       :desc "Find file in project"         "f" #'projectile-find-file
       :desc "Find file in other project"   "F" #'doom/find-file-in-other-project
       :desc "Configure project"            "g" #'projectile-configure-project
       :desc "Invalidate project cache"     "i" #'projectile-invalidate-cache
       :desc "Kill project buffers"         "k" #'projectile-kill-buffers
       :desc "Find other file"              "o" #'projectile-find-other-file
       :desc "Switch project"               "p" #'projectile-switch-project
       :desc "Find recent project files"    "r" #'projectile-recentf
       :desc "Run project"                  "R" #'projectile-run-project
       :desc "Save project files"           "s" #'projectile-save-project-buffers
       :desc "List project todos"           "t" #'magit-todos-list
       :desc "Test project"                 "T" #'projectile-test-project
       :desc "Pop up scratch buffer"        "x" #'doom/open-project-scratch-buffer
       :desc "Switch to scratch buffer"     "X" #'doom/switch-to-project-scratch-buffer
       )

      ;;; <leader> q --- quit/session
      (:prefix-map ("q" . "quit/session")
       :desc "Delete frame"                 "f" #'delete-frame
       :desc "Clear current frame"          "F" #'doom/kill-all-buffers
       :desc "Kill Emacs (and daemon)"      "K" #'save-buffers-kill-emacs
       :desc "Quit Emacs"                   "q" #'save-buffers-kill-terminal
       :desc "Quit Emacs without saving"    "Q" #'evil-quit-all-with-error-code
       :desc "Quick save current session"   "s" #'doom/quicksave-session
       :desc "Restore last session"         "l" #'doom/quickload-session
       :desc "Save session to file"         "S" #'doom/save-session
       :desc "Restore session from file"    "L" #'doom/load-session
       :desc "Restart & restore Emacs"      "r" #'doom/restart-and-restore
       :desc "Restart Emacs"                "R" #'doom/restart)

      ;;; <leader> r --- remote
      (:when (featurep! :tools upload)
       (:prefix-map ("r" . "remote")
        :desc "Browse remote"              "b" #'ssh-deploy-browse-remote-base-handler
        :desc "Browse relative"            "B" #'ssh-deploy-browse-remote-handler
        :desc "Download remote"            "d" #'ssh-deploy-download-handler
        :desc "Delete local & remote"      "D" #'ssh-deploy-delete-handler
        :desc "Eshell base terminal"       "e" #'ssh-deploy-remote-terminal-eshell-base-handler
        :desc "Eshell relative terminal"   "E" #'ssh-deploy-remote-terminal-eshell-handler
        :desc "Move/rename local & remote" "m" #'ssh-deploy-rename-handler
        :desc "Open this file on remote"   "o" #'ssh-deploy-open-remote-file-handler
        :desc "Run deploy script"          "s" #'ssh-deploy-run-deploy-script-handler
        :desc "Upload local"               "u" #'ssh-deploy-upload-handler
        :desc "Upload local (force)"       "U" #'ssh-deploy-upload-handler-forced
        :desc "Diff local & remote"        "x" #'ssh-deploy-diff-handler
        :desc "Browse remote files"        "." #'ssh-deploy-browse-remote-handler
        :desc "Detect remote changes"      ">" #'ssh-deploy-remote-changes-handler))

      ;;; <leader> s --- search
      (:prefix-map ("s" . "search")
       :desc "Search buffer"                "b"  #'consult-
       :desc "Search all open buffers"      "B" (cmd!! #'consult-line-multi 'all-buffers)
       :desc "Search current directory"     "d" (cmd! (consult-ripgrep default-directory ""))
       :desc "Search other directory"       "D" (cmd! (consult-ripgrep (read-directory-name "Search within directory: ") ""))
       :desc "Locate file"                  "f" #'locate
       :desc "Jump to symbol"               "i" #'imenu
       :desc "Jump to visible link"         "l" #'link-hint-open-link
       :desc "Jump to link"                 "L" #'ffap-menu
       :desc "Jump list"                    "j" #'evil-show-jumps
       :desc "Jump to bookmark"             "m" #'bookmark-jump
       :desc "Look up online"               "o" #'+lookup/online
       :desc "Look up online (w/ prompt)"   "O" #'+lookup/online-select
       :desc "Look up in local docsets"     "k" #'+lookup/in-docsets
       :desc "Look up in all docsets"       "K" #'+lookup/in-all-docsets
       :desc "Search project"               "p" (cmd! (consult-ripgrep (projectile-project-root) ))
       :desc "Jump to mark"                 "r" #'evil-show-marks
       :desc "Search buffer"                "b" (cmd! (consult-line))
       :desc "Search buffer for thing at point" "S" (cmd! (consult-line (thing-at-point 'symbol)))
       ;:desc "Dictionary"                   "t" #'+lookup/dictionary-definition
       ;:desc "Thesaurus"                    "T" #'+lookup/synonyms
       )

      ;;; <leader> t --- toggle
      (:prefix-map ("t" . "toggle")
       :desc "Big mode"                     "b" #'doom-big-font-mode
       :desc "Fill Column Indicator"        "c" #'global-display-fill-column-indicator-mode
       :desc "Flymake"                      "f" #'flymake-mode
       (:when (featurep! :checkers syntax)
        :desc "Flycheck"                   "f" #'flycheck-mode)

       :desc "Frame fullscreen"             "F" #'toggle-frame-fullscreen
       :desc "Evil goggles"                 "g" #'evil-goggles-mode

       (:when (featurep! :ui indent-guides)
        :desc "Indent guides"              "i" #'highlight-indent-guides-mode)

       :desc "Indent style"                 "I" #'doom/toggle-indent-style
       :desc "Line numbers"                 "l" (cmd! (setq display-line-numbers (not display-line-numbers)))

       (:when (featurep! :ui minimap)
        :desc "Minimap"                     "M" #'minimap-mode)

        :desc "Modeline"                    "m" #'hide-mode-line-mode

       (:when (featurep! :lang org +present)
        :desc "org-tree-slide mode"        "p" #'org-tree-slide-mode)

       :desc "Read-only mode"               "r" #'read-only-mode

       (:when (and (featurep! :checkers spell) (not (featurep! :checkers spell +flyspell)))
        :desc "Spell checker"              "s" #'spell-fu-mode)

       (:when (featurep! :checkers spell +flyspell)
        :desc "Spell checker"              "s" #'flyspell-mode)

       (:when (featurep! :lang org +pomodoro)
        :desc "Pomodoro timer"             "t" #'org-pomodoro)

       :desc "Soft line wrapping"           "w" #'visual-line-mode

       (:when (featurep! :editor word-wrap)
        :desc "Soft line wrapping"         "w" #'+word-wrap-mode)

       (:when (featurep! :ui zen)
        :desc "Zen mode"                   "z" #'+zen/toggle
        :desc "Zen mode (fullscreen)"      "Z" #'+zen/toggle-fullscreen)

       ))
