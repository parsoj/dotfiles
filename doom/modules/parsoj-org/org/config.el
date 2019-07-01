;;; parsoj-org/init.el -*- lexical-binding: t; -*-


(setq org-capture-templates
      '(
        ("i" "Inbox entry" entry
         (file +org-capture-todo-file)
         "* %?\n%i\n%a" :prepend t :kill-buffer t)

        ("p" "protocol quick-capture" entry
         (file +org-capture-todo-file)
         "* %?\n%i\n%a" :prepend t :kill-buffer t :immediate-finish t)
        )
      )

(setq +org-capture-todo-file "inbox/inbox.org"
      +org-capture-notes-file "inbox/inbox.org"
      )

(setq org-root "~/org/")

(setq org-refile-use-outline-path 'file)

(defvar sr-org-refile-targets nil
  "List of refile targets for Org-remember.
   See `org-refile-targets'.")

(defvar sr-org-refile-dir-excludes  "^[#\\.].*$")
(defvar sr-org-refile-file-excludes "^[#\\.].*$")



(defun sr-find-org-refile-targets
    (&optional recurse dirs file-excludes dir-excludes)
  "Fill the variable `sr-org-refile-targets'.
Optional parameters:
  recurse        If `t', scan the directory recusively.
  dirs           A list of directories to scan for *.org files.
  file-excludes  Regular expression. If a filename matches this regular
expression,
                 do not add it to `sr-org-refile-targets'.
  dir-excludes   Regular expression. If a directory name matches this
regular expression,
                 do not add it to `sr-org-refile-targets'."
  (let ((targets (or dirs (list org-directory)))
        (fex (or file-excludes  "^[#\\.].*$"))
        (dex (or dir-excludes  "^[#\\.].*$"))
        path)
    (dolist (dir targets)
      (if (file-directory-p dir)
          (let ((all (directory-files dir nil "^[^#\\.].*$")))
            (dolist (f all)
              (setq path (concat (file-name-as-directory dir) f))
              (cond
               ((file-directory-p path)
                (if (and recurse (not (string-match dex f)))
                    (sr-find-org-refile-targets t (list path) fex
                                                dex)))
               ((and (string-match "^[^#\\.].*\\.org$" f) (not
                                                           (string-match fex f)))
                (setq sr-org-refile-targets (append (list path)
                                                    sr-org-refile-targets))))))
        (message "Not a directory: %s" path))
      )))



(defun sr-add-to-org-refile-targets ( recurse dirs )
  "Add a directory to org-refile targets recursively."
  (interactive "P\nDdirectory: ")
  (sr-find-org-refile-targets
   (if recurse t nil)
   (list dirs)
   sr-org-refile-file-excludes
   sr-org-refile-dir-excludes)
  (message "org-refile-targets: \n%s" sr-org-refile-targets))


(progn
  (setq org-refile-targets nil)
  (setq sr-add-to-org-refile-targets nil)
  (mapc (lambda (d) (sr-add-to-org-refile-targets t (concat org-root d)))
        '("projects" "life_ops" "reference" "spare_time" "someday_maybe"))
  (setq org-refile-targets '((sr-org-refile-targets :maxlevel . 4)))
  )
