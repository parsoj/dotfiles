;;; ../.config/emacs/doom-config/extras/workspaces/repos.el -*- lexical-binding: t; -*-


(defvar organization-repos)

(defvar active-organization)


(setq magit-clone-set-remote.pushDefault t)


(defun clone-repo-from-organization (organization clone-dir)
  (let (
        (repo (pick-repo-for-organization organization)))

    (magit-clone-regular repo clone-dir nil)
    )
  )


(defun get-repos-for-organization (organization)
  (alist-get organization organization-repos)
  )


(defun pick-repo-for-organization (organization)
  (interactive)
  (let ((org-repos (alist-get organization organization-repos) ))
    (alist-get
     (intern(completing-read "pick repo:" (get-repos-for-organization active-organization)))
     org-repos
     )
    )
  )


(defun clone-project-repo-for-organization ()
  (interactive)
  (clone-repo-from-organization active-organization (projectile-project-root))
  )


(defun +create-pullreq   ( )
  (interactive)

  (forge-create-pullreq (magit-get-current-branch) (magit-main-branch))
  )
