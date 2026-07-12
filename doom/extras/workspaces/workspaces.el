;;; ../.config/emacs/doom-config/extras/workspaces/workspaces.el -*- lexical-binding: t; -*-

(require 'subr-x)

;; ------------------------------------------------------------------------------------------
;; workspace CLI wrappers

(defvar jeff/workspace-cli-shell "fish"
  "Shell used to run workspace management CLI functions.")

(defvar jeff/workspace-cli-buffer "*workspace-cli*"
  "Buffer used for workspace management CLI output.")

(defun jeff/workspace-cli--command (command)
  "Return a shell command that runs fish workspace COMMAND."
  (format "%s -lc %s"
          (shell-quote-argument (or (executable-find jeff/workspace-cli-shell)
                                    jeff/workspace-cli-shell))
          (shell-quote-argument command)))

(defun jeff/workspace-cli-run (command &optional directory on-success)
  "Run workspace CLI COMMAND in DIRECTORY.

ON-SUCCESS, when non-nil, is called after the process exits with status 0."
  (let* ((default-directory (file-name-as-directory
                             (expand-file-name (or directory default-directory))))
         (buffer (get-buffer-create jeff/workspace-cli-buffer)))
    (with-current-buffer buffer
      (read-only-mode -1)
      (erase-buffer)
      (insert (format "$ %s\n\n" command)))
    (let ((process (start-process-shell-command
                    "workspace-cli" buffer (jeff/workspace-cli--command command))))
      (display-buffer buffer)
      (set-process-sentinel
       process
       (lambda (proc _event)
         (when (memq (process-status proc) '(exit signal))
           (let ((status (process-exit-status proc)))
             (with-current-buffer (process-buffer proc)
               (read-only-mode -1)
               (goto-char (point-max))
               (insert (format "\n[workspace-cli exited %s]\n" status))
               (read-only-mode 1))
             (if (zerop status)
                 (progn
                   (when (fboundp 'jeff/projectile-discover-workspaces)
                     (jeff/projectile-discover-workspaces))
                   (when on-success (funcall on-success)))
               (message "Workspace CLI failed: %s" command))))))
      process)))

(defun jeff/workspace-path (name)
  "Return the path for workspace NAME."
  (expand-file-name name "~/code/workspaces/"))

(defun jeff/workspace-completing-roots ()
  "Return workspace roots for completion."
  (if (fboundp 'jeff/workspace-roots)
      (jeff/workspace-roots)
    (directory-files (expand-file-name "~/code/workspaces") t "^[^.]")))

(defun jeff/workspace-create (name)
  "Create a new workspace via the `workspace_create' CLI and open it as a project."
  (interactive "sWorkspace name: ")
  (let* ((workspace-name (string-trim name))
         (workspace-path (jeff/workspace-path workspace-name)))
    (when (string-empty-p workspace-name)
      (user-error "Workspace name is required"))
    (jeff/workspace-cli-run
     (format "workspace_create --no-clipboard %s" (shell-quote-argument workspace-name))
     nil
     (lambda ()
       (when (fboundp 'projectile-add-known-project)
         (projectile-add-known-project workspace-path))
       (find-file workspace-path)
       (when (fboundp 'projectile-switch-project-by-name)
         (projectile-switch-project-by-name workspace-path))))))

;; Backward-compatible binding used by existing keymaps.
(defun +create-new-workspace ()
  (interactive)
  (call-interactively #'jeff/workspace-create))

(defun jeff/workspace-add-repo (repo-or-url &optional workspace)
  "Add REPO-OR-URL to WORKSPACE via the `repo_add' CLI.

When WORKSPACE is nil, use the current Projectile root."
  (interactive
   (list (read-string "Repo name or GitHub URL: ")
         (when current-prefix-arg
           (completing-read "Workspace: "
                            (jeff/workspace-completing-roots)
                            nil t))))
  (let ((workspace-root (or workspace
                            (and (fboundp 'projectile-project-root)
                                 (projectile-project-root)))))
    (unless workspace-root
      (user-error "Not in a Projectile workspace; call with prefix to choose one"))
    (jeff/workspace-cli-run
     (format "repo_add %s" (shell-quote-argument repo-or-url))
     workspace-root
     (lambda ()
       (when (fboundp 'projectile-invalidate-cache)
         (projectile-invalidate-cache nil))
       (when (fboundp 'jeff/treemacs-display-project-root-exclusively)
         (jeff/treemacs-display-project-root-exclusively workspace-root))))))

(defun jeff/workspace-add-tennr (&optional workspace)
  "Add Tennr to WORKSPACE via the `wat' CLI wrapper."
  (interactive
   (list (when current-prefix-arg
           (completing-read "Workspace: " (jeff/workspace-completing-roots) nil t))))
  (let ((workspace-root (or workspace
                            (and (fboundp 'projectile-project-root)
                                 (projectile-project-root)))))
    (unless workspace-root
      (user-error "Not in a Projectile workspace; call with prefix to choose one"))
    (jeff/workspace-cli-run "wat" workspace-root)))

(defun jeff/workspace-add-odd-bits (&optional workspace)
  "Add odd-bits to WORKSPACE via the `repo_add' CLI."
  (interactive
   (list (when current-prefix-arg
           (completing-read "Workspace: " (jeff/workspace-completing-roots) nil t))))
  (jeff/workspace-add-repo "odd-bits" workspace))

(defun jeff/workspace-spinout (name)
  "Spin current repo changes into a new workspace via `workspace_spinout'."
  (interactive "sNew workspace name: ")
  (let ((workspace-name (string-trim name)))
    (when (string-empty-p workspace-name)
      (user-error "Workspace name is required"))
    (jeff/workspace-cli-run
     (format "workspace_spinout %s" (shell-quote-argument workspace-name))
     default-directory
     (lambda ()
       (let ((workspace-path (jeff/workspace-path workspace-name)))
         (when (fboundp 'projectile-add-known-project)
           (projectile-add-known-project workspace-path))
         (when (fboundp 'projectile-switch-project-by-name)
           (projectile-switch-project-by-name workspace-path)))))))



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



;; Project switching/layout restoration is handled in projectile_config.el.
;; Do not unconditionally pop Treemacs after every project switch, because that
;; would overwrite restored project layouts.

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
