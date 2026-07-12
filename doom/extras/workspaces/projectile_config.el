;;; projectile_config.el --- configurations for projectile  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Jeff Parsons

;; Author: Jeff Parsons <parsoj@gmail.com>


;; (defun jeff/set-project-variable (key value)
;;   (let ((default-directory (projectile-project-root)))
;;     (if (not(file-exists-p "./.dir-locals.el")) (f-touch "./.dir-locals.el"))
;;     (add-dir-local-variable nil key value)
;;     )
;;   )

(defun jeff/create-project-run-script ()
  (interactive)
  (let* ((run-scripts-dir (concat (projectile-project-root) "run-scripts") )
        (script-name (read-string "What do you want to name your run script?" ))
        (script-path (concat run-scripts-dir "/" script-name))
        )


    (progn
      (if
          (not(file-exists-p run-scripts-dir))
          (mkdir run-scripts-dir)
        )
      (f-touch script-path)
      (find-file script-path)

      )
    )
  )

(defvar active-run-script nil)
(add-hook 'projectile-before-switch-project-hook (lambda () (setq active-run-script nil)))

(defun jeff/set-project-run-script ()
  (interactive)
       (setq
        active-run-script
         (completing-read
          "select run script:"
          (directory-files (concat (projectile-project-root) "/run-scripts" ) nil "^.*\\.\\(sh\\|el\\)$"))
         )

  )


(defun is-shellscript-file-p (filename)
  (string= "sh" (file-name-extension filename))
  )

(defun is-elisp-file-p (filename)
  (string= "el" (file-name-extension filename))
  )


(defun jeff/projectile-run-project ()
  (interactive)

  (progn

    (unless active-run-script (jeff/set-project-run-script))

    (cond

     ((is-elisp-file-p active-run-script)
      (let ((default-directory (projectile-project-root))
            (e-text (f-read-text active-run-script))
            (exec-buffer-name "Project Run Script")
            )

        (progn
          (kill-buffer exec-buffer-name)
          (with-temp-buffer-window "Project Run Script" nil nil
                                        ;(load (concat (projectile-project-root) active-run-script))
            ;;(print e-text)

            (eval (read e-text))
            )
          )
        )
      )

     ((is-shellscript-file-p active-run-script)
      (projectile-run-async-shell-command-in-root active-run-script)
      )
     )
    )
  )




;;(defun jeff/run-in-vterm (dir cmd)
;;  (let ((default-directory dir))
;;    (progn
;;      (+vterm/toggle t)
;;      (vterm-send-string cmd)
;;      (vterm-send-return)
;;
;;      ))
;;
;;  )


;;(defun jeff/set-project-run-command ()
;;  (interactive)
;;  (let ((default-directory (projectile-project-root))
;;        (run-cmd (completing-read "Set project run command: " nil nil nil)))
;;
;;    (add-dir-local-variable nil 'projectile-project-run-cmd run-cmd)
;;    )
;;
;;  )


;; (defcustom projectile-auto-discover-search-depth nil
;;   "How deeply to recurse directories searching for projects.
;; Must be a positive integer.
;; When nil or <= 1, recursion is effectively disabled and only immediate subdirs
;; are searched"
;;   :group 'projectile
;;   :type '(restricted-sexp
;;           :match-alternatives ((lambda (x) (and (natnump x)  (not (zerop x))))))
;;   :package-version '(projectile . "2.3.0"))


(require 'cl-lib)

(defvar jeff/workspace-search-path '("~/code/workspaces" "~/.config")
  "Directories that contain, or are themselves, workspace roots marked by .workspace.json.")

(defvar jeff/workspace-search-depth 4
  "Maximum depth to search below `jeff/workspace-search-path'.")

(defun jeff/workspace-roots ()
  "Return all workspace roots found under `jeff/workspace-search-path'."
  (let ((roots nil))
    (dolist (base jeff/workspace-search-path)
      (let ((base (file-truename (expand-file-name base))))
        (when (file-directory-p base)
          (if (executable-find "fd")
              (dolist (marker (process-lines
                               "fd" ".workspace.json" base
                               "--hidden" "--glob" "--type" "f"
                               "--max-depth" (number-to-string jeff/workspace-search-depth)
                               "--exclude" ".git"))
                (push (file-name-directory marker) roots))
            (dolist (marker (directory-files-recursively base "^\\.workspace\\.json$" nil))
              (when (<= (length (file-name-split (file-relative-name marker base)))
                        (1+ jeff/workspace-search-depth))
                (push (file-name-directory marker) roots)))))))
    (sort (delete-dups (mapcar #'file-truename roots)) #'string<)))

(defun jeff/projectile-discover-workspaces ()
  "Add all `.workspace.json' roots under `jeff/workspace-search-path' to Projectile."
  (interactive)
  (require 'projectile)
  (let ((count 0))
    (dolist (root (jeff/workspace-roots))
      (projectile-add-known-project root)
      (cl-incf count))
    (message "Projectile discovered %d workspaces" count)))

(defun jeff/projectile-discover-projects-in-directory (directory &optional recursion-depth)
  "Backward-compatible wrapper around `projectile-discover-projects-in-directory'."
  (interactive (list (read-directory-name "Starting directory: ")))
  (projectile-discover-projects-in-directory directory recursion-depth))




;;------------------------------------------------------------------------------------------
;; project workspace/layout restoration
;;

(defvar jeff/project-workspace-prefix "project:"
  "Prefix for Doom workspace names that mirror Projectile projects.")

(defvar jeff/current-project-root nil
  "Last Projectile project root opened through `jeff/projectile-switch-project-restore-layout'.")

(defun jeff/project-workspace-name (&optional project-root)
  "Return the Doom workspace name for PROJECT-ROOT."
  (let* ((root (file-truename (or project-root (projectile-project-root))))
         (name (file-name-nondirectory (directory-file-name root))))
    (concat jeff/project-workspace-prefix name)))

(defun jeff/project-workspace-name-p (&optional name)
  "Return non-nil if NAME is one of our project workspaces."
  (string-prefix-p jeff/project-workspace-prefix (or name (+workspace-current-name))))

(defun jeff/saved-project-workspace-p (name)
  "Return non-nil if workspace NAME has been persisted by Doom workspaces."
  (let ((file (expand-file-name +workspaces-data-file persp-save-dir)))
    (and (file-exists-p file)
         (member name (persp-list-persp-names-in-file file)))))

(defun jeff/save-current-project-workspace ()
  "Persist the current project workspace, if it is one of ours."
  (when (and (featurep 'persp-mode)
             (+workspace-current-name)
             (jeff/project-workspace-name-p))
    (ignore-errors (+workspace-save (+workspace-current-name)))))

(defun jeff/treemacs-display-project-root-exclusively (&optional project-root)
  "Force Treemacs to show PROJECT-ROOT as its sole root.

When PROJECT-ROOT is nil, use `jeff/current-project-root' or the current
Projectile root. This avoids Treemacs guessing a different root from its current
buffer/default-directory (notably for ~/.config)."
  (interactive)
  (require 'treemacs)
  (require 'projectile)
  (let* ((root (file-truename
                (file-name-as-directory
                 (or project-root
                     jeff/current-project-root
                     (projectile-project-root)))))
         (path (treemacs-canonical-path root))
         (name (file-name-nondirectory (directory-file-name path))))
    (unless (treemacs-current-workspace)
      (treemacs--find-workspace))
    (treemacs--show-single-project path name)))

(defun jeff/project-open-treemacs-root (project-root)
  "Open Treemacs rooted at PROJECT-ROOT as a fallback project layout."
  (require 'treemacs)
  (let ((default-directory (file-name-as-directory project-root)))
    (delete-other-windows)
    (dired default-directory)
    (jeff/treemacs-display-project-root-exclusively project-root)))

(defun jeff/projectile-switch-project-restore-layout ()
  "Projectile switch action: restore project layout, else open Treemacs at root.

Layouts are persisted as Doom workspaces named `project:<workspace-name>'. They
are saved when switching away from a project workspace and on Emacs exit."
  (interactive)
  (require 'projectile)
  (require 'persp-mode)
  (let* ((root (file-truename (file-name-as-directory (projectile-project-root))))
         (workspace-name (jeff/project-workspace-name root))
         (had-saved-layout (jeff/saved-project-workspace-p workspace-name)))
    (setq jeff/current-project-root root)
    (cond
     ((+workspace-exists-p workspace-name)
      (+workspace-switch workspace-name))
     (had-saved-layout
      (+workspace-load workspace-name)
      (+workspace-switch workspace-name))
     (t
      (+workspace-switch workspace-name t)
      (jeff/project-open-treemacs-root root)))
    ;; Restored workspaces may contain a stale Treemacs root. Always force it to
    ;; the Projectile root for the selected project.
    (jeff/treemacs-display-project-root-exclusively root)
    (message "Opened project workspace: %s" workspace-name)))

(add-hook 'projectile-before-switch-project-hook #'jeff/save-current-project-workspace)
(add-hook 'kill-emacs-hook #'jeff/save-current-project-workspace)

;;------------------------------------------------------------------------------------------
;; projectile jump-to-project action
;;
(defun +projectile-jump-to-notes (&optional counsel-projectile-candidate)
  ;; TODO deprecate me
  (interactive)
  (find-file (concat (projectile-project-root) project-notes-file))

  )

(defun +projectile-jump-to-makefile (&optional counsel-projectile-candidate)
  ;; TODO deprecate me
  (interactive)
  (find-file (concat (projectile-project-root) "Makefile"))

  )

;; (setq counsel-projectile-switch-project-action #'+projectile-jump-to-notes)

(defun +projectile-pop-notes ()
  (interactive)
  (let* ((file-path (concat (projectile-project-root) project-notes-file))
         (buffer-name "*Project Notes*")
         (buffer (find-file-noselect file-path))

         )
    (progn
      (with-current-buffer buffer
        (rename-buffer buffer-name))
      (pop-to-buffer buffer-name))
    )
  )

(set-popup-rule! "*Project Notes*" :side 'right :size 70 :quit 'current)

;; ------------------------------------------------------------------------------------------

(after! projectile
  ;;(setq projectile-project-root-functions '(projectile-root-bottom-up))
  ;; (setq projectile-project-root-files-bottom-up '(".projectile"))

  (setq projectile-switch-project-action #'jeff/projectile-switch-project-restore-layout)
  (set-popup-rule! "^\\*compilation\\*"  :side 'right :quit nil :select t)

  (map! :leader
       (:desc "Run project"                  "p r" #'jeff/projectile-run-project)
       (:desc "Set Project Run Script"       "p R" #'jeff/set-project-run-script)
        (:desc "Switch project"                  "p p" (cmd! (projectile-switch-project)))
        (:desc "Jump to project notes"  "p n" #'+projectile-pop-notes)
        (:desc "Jump to project Makefile"  "p m" #'+projectile-jump-to-makefile)
        )


  ;; Don't let Projectile recursively auto-discover nested git repos under each
  ;; workspace. Your unit of work is a workspace root marked by .workspace.json.
  ;; `jeff/projectile-discover-workspaces' handles discovery from
  ;; `jeff/workspace-search-path' instead, including ~/.config.
  (setq projectile-project-search-path nil)

  ;; Treat your workspace marker as a first-class Projectile root marker.
  ;; Keep .projectile as a fallback for older projects.
  (setq projectile-project-root-files-bottom-up '(".workspace.json" ".projectile"))
  (setq projectile-project-root-files '(".workspace.json" ".projectile"))
  (setq projectile-auto-discover nil)

  (jeff/projectile-discover-workspaces)


  ;; (setq projectile-project-root-files-top-down-recurring '(".projectile"))

  ;; (setq projectile-project-root-functions '(projectile-root-top-down-recurring ))


  )






(provide 'projectile_config)
;;; projectile_config.el ends here
