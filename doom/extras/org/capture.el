;;; ../.config/emacs/doom-config/extras/org/capture.el -*- lexical-binding: t; -*-



(setq org-inbox-file (expand-file-name (concat org-directory "/inbox/inbox.org")))

(setq org-capture-templates

      `(
        ("i" "General inbox item" entry
         (file+headline ,org-inbox-file "Inbox")
         "* %?\n%i\n%a" :prepend t)
        ("n" "Inbox note" entry
         (file+headline ,org-inbox-file "Inbox")
         "* NOTE %?\n%i\n%a" :prepend t)
        ("t" "Inbox task" entry
         (file+headline ,org-inbox-file "Inbox")
         "* TODO %?\n%i\n%a" :prepend t)
        )
      )
