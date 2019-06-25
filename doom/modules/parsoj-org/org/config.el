;;; parsoj-org/init.el -*- lexical-binding: t; -*-


(setq org-capture-templates
      '(
        ("i" "Inbox entry" entry
         (file+headline +org-capture-todo-file "Inbox")
         "* %?\n%i\n%a" :prepend t :kill-buffer t)
        )
      )

(setq +org-capture-todo-file "inbox.org"
      +org-capture-notes-file "inbox.org"
      )
