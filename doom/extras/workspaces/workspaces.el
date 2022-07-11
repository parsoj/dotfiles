;;; ../.config/emacs/doom-config/extras/workspaces/workspaces.el -*- lexical-binding: t; -*-



;; ------------------------------------------------------------------------------------------
;; workspace creation

(defun +create-new-workspace ()
  (interactive)
  (let* (
        (workspace-parent-dir (completing-read "Select Workspace Dir: " (+list-workspace-directories workspaces-root)))
        (workspace-name (completing-read "Name for Workspace: " nil nil nil))
        (workspace-path (concat workspace-parent-dir "/" workspace-name))
        )
    (progn
      (+workspace-create-at workspace-name workspace-path)
      (find-file
       (concat workspace-path "/" project-notes-file))
      )
    )
  )


(defun +f-entries-names (dir)
  (--map (f-filename it) (f-entries dir))
  )


(defun +list-workspace-directories (root-dir)

  (f-directories root-dir (lambda (dir) (not (-contains-p (+f-entries-names dir) ".projectile")) ))

  )


(defun +workspace-create-at (workspace-name workspace-path)
  (if (f-exists? workspace-path)
      (throw 'directory-exists "There is already a file/directory at the workspace path given")
    (progn
      (make-directory workspace-path t)
      (let ((default-directory workspace-path))
        (write-region "" nil ".projectile")
        (write-region (concat "#+TITLE: " workspace-name) nil "notes.org")
        (magit-init default-directory)
        )
      )
      )
  )



;; run "treemacs-display-current-project-exclusively" after every project switch to ensure we always show the current project
(after! treemacs
  (add-hook 'projectile-after-switch-project-hook #'treemacs-display-current-project-exclusively))

;; ------------------------------------------------------------------------------------------
;; workspace switching

;; (defun +treemacs-workspace-switch-create (ws-name)
;;   (unless (eq 'success (car (treemacs-do-switch-workspace ws-name)))
;;     (progn
;;       (let ((treemacs-ws (treemacs-workspace->create! :name ws-name)))
;;         (add-to-list 'treemacs--workspaces treemacs-ws)
;;         (treemacs-do-switch-workspace ws-name)
;;         )
;;       )
;;     )
;;   )

;; (+treemacs-workspace-switch-create "doink")
