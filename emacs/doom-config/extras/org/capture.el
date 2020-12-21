;;; ../.config/emacs/doom-config/extras/org/capture.el -*- lexical-binding: t; -*-



(setq org-inbox-file (expand-file-name (concat org-directory "/inbox/inbox.org")))

(setq org-capture-templates

      `(("x" "Inbox item" entry
         (file+headline ,org-inbox-file "Inbox")
         "* INBOX %?\n%i\n%a" :prepend t))
 )
