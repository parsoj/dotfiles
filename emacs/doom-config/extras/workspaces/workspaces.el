;;; ../.config/emacs/doom-config/extras/workspaces/workspaces.el -*- lexical-binding: t; -*-


(setq workspaces-root "~/workspaces")


(defun +create-new-workspace ()
  (interactive)
  (let (
        (workspace-parent-dir (completing-read "Select Workspace Dir: " (+list-workspace-directories workspaces-root)))
        (workspace-name (completing-read "Name for Workspace: " nil nil nil))
        )
    (progn
      (+workspace-create-at workspace-parent-dir workspace-name)
      (find-file
       (concat workspaces-root "/" workspace-name "/" workspace-name ".org"))
      )
    )
  )

(defun +f-entries-names (dir)
  (--map (f-filename it) (f-entries dir))
  )

(defun +list-workspace-directories (root-dir)

  (f-directories root-dir (lambda (dir) (not (-contains-p (+f-entries-names dir) ".projectile")) ))

  )


(defun +workspace-create-at (parent-dir workspace-name)
  (let ((workspace-path (concat parent-dir "/" workspace-name)))
    (if (file-directory-p workspace-path)
        t
      (progn
        (make-directory workspace-path t)
        (write-region "" nil (concat workspace-path "/.projectile"))
        )
      ))
  )


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
