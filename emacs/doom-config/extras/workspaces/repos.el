;;; ../.config/emacs/doom-config/extras/workspaces/repos.el -*- lexical-binding: t; -*-


(defvar organization-repos)

(defvar active-organization)


(setq magit-clone-set-remote.pushDefault t)


(defun clone-repo-from-organization (organization clone-dir)
  (let (
        (repo (pick-repo-for-active-organization)))

    (magit-clone-regular repo clone-dir nil)
    )
  )


(defun get-repos-for-organization (organization)
  (alist-get 'repos (alist-get organization organization-repos))
  )



(defun set-active-organization ()
  (interactive)
  (setq active-organization (intern (completing-read "Select active Organization:" (-map #'car organization-repos))))
  )


(defun pick-repo-for-active-organization ()
  (interactive)
  (completing-read "pick repo:" (get-repos-for-organization active-organization))
  )


(defun clone-project-repo-for-organization ()
  (interactive)
  (clone-repo-from-organization active-organization (projectile-project-root))
  )


(defun +create-pullreq   ( )
  (interactive)

  (forge-create-pullreq (magit-get-current-branch) (magit-main-branch))
  )
