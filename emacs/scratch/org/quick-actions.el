

(setq org-root "~/org")
(setq projects-root (concat org-root "/projects"))
(setq active-projects-root (concat org-root "/projects/active"))

(defun jump-to-org-project ()
  (interactive)
  (let ((module-path (completing-read
                      "Jump To Org Project: "
                      (directory-files-recursively projects-root ".*" t)
                      nil t)))
    (find-file module-path)
    )

  )

(pretty-hydra-define hydra-org-actions
    (:color teal :title hydra-org-actions--title)
    (
     "Jump To..."
     (("p" jump-to-org-project "Jump to project file")
      )))


