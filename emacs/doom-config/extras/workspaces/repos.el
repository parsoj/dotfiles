;;; ../.config/emacs/doom-config/extras/workspaces/repos.el -*- lexical-binding: t; -*-


(defvar organization-repos)

(defvar active-organization)



(defun clone-repo-from-organization (organization clone-dir)
  (let (
        (repo (completing-read "Pick Repo to clone:" (alist-get organization organization-repos))))

    (magit-clone-shallow repo clone-dir nil 1)
    )
  )


(defun clone-project-repo-for-organization ()
  (interactive)
  (clone-repo-from-organization active-organization (projectile-project-root))
  )


(defun set-active-organization ()
  (interactive)
  (setq active-organization (intern (completing-read "Select active Organization:" (-map #'car organization-repos))))
  )


(defun get-repos-for-organization (organization)
  (alist-get 'repos (alist-get organization organization-repos))
  )


(defun pick-repo-for-active-organization ()
  (interactive)
  (completing-read "pick repo:" (get-repos-for-organization active-organization))
  )

