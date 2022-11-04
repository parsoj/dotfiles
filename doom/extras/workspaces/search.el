;;; extras/workspaces/search.el -*- lexical-binding: t; -*-

(defun ++search-dir (&optional arg)
  "Conduct a text search in files under the current folder.
If prefix ARG is set, prompt for a directory to search from."
  (interactive "P")
  (let ((default-directory
          (if arg
              (read-directory-name "Search directory: ")
            default-directory)))
    (call-interactively
            #'+vertico/project-search-from-cwd)))
