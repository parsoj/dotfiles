;;; projectile_config.el --- configurations for projectile  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Jeff Parsons

;; Author: Jeff Parsons <parsoj@gmail.com>


(defun jeff/projectile-run-project ()
  (interactive)

  (let ((func-or-cmd projectile-project-run-cmd))
    (cond ((stringp func-or-cmd)
           (jeff/run-in-vterm (projectile-project-root) func-or-cmd ))
          ((functionp func-or-cmd)
           (funcall func-or-cmd))
          (t
           (eval func-or-cmd)
           )
      ))

  )

(defun jeff/run-in-vterm (dir cmd)
  (let ((default-directory dir))
    (progn
      (+vterm/toggle t)
      (vterm-send-string cmd)
      (vterm-send-return)

      ))

  )


(defun jeff/set-project-run-command ()
  (interactive)
  (let ((default-directory (projectile-project-root))
        (run-cmd (completing-read "Set project run command: " nil nil nil)))

    (add-dir-local-variable nil 'projectile-project-run-cmd run-cmd)
    )

  )


;; (defcustom projectile-auto-discover-search-depth nil
;;   "How deeply to recurse directories searching for projects.
;; Must be a positive integer.
;; When nil or <= 1, recursion is effectively disabled and only immediate subdirs
;; are searched"
;;   :group 'projectile
;;   :type '(restricted-sexp
;;           :match-alternatives ((lambda (x) (and (natnump x)  (not (zerop x))))))
;;   :package-version '(projectile . "2.3.0"))


(defun jeff/projectile-discover-projects-in-directory (directory &optional recursion-depth)
  "Discover any projects in DIRECTORY and add them to the projectile cache.
This function is not recursive and only adds projects with roots
at the top level of DIRECTORY."
  (interactive
   (list (read-directory-name "Starting directory: ")))
  (if (file-exists-p directory)
      (let ((subdirs (directory-files directory t)))
        (mapcar
         (lambda (dir)
           (when (and (file-directory-p dir)
                      (not (member (file-name-nondirectory dir) '(".." "."))))
             (if (projectile-project-p dir)
                 (projectile-add-known-project dir)
               (when (> recursion-depth 1)
                 (jeff/projectile-discover-projects-in-directory dir (- recursion-depth 1))
                 )
               )))
         subdirs))
    (message "Project search path directory %s doesn't exist" directory)))




;;------------------------------------------------------------------------------------------
;; projectile jump-to-project action
;;
(defun +projectile-jump-to-notes (&optional counsel-projectile-candidate)
  (interactive)
  (find-file (concat (projectile-project-root) project-notes-file))

  )

(defun +projectile-jump-to-makefile (&optional counsel-projectile-candidate)
  (interactive)
  (find-file (concat (projectile-project-root) "Makefile"))

  )

(setq projectile-switch-project-action #'+projectile-jump-to-notes)
;; (setq counsel-projectile-switch-project-action #'+projectile-jump-to-notes)


;; ------------------------------------------------------------------------------------------

(after! projectile
  ;;(setq projectile-project-root-functions '(projectile-root-bottom-up))
  ;; (setq projectile-project-root-files-bottom-up '(".projectile"))

  (set-popup-rule! "^\\*compilation\\*"  :side 'right :quit nil :select t)

  (map! :leader
        (:desc "Run project"                  "p r" #'jeff/projectile-run-project)
        (:desc "Switch project"                  "p p" (cmd! (projectile-switch-project)))
        (:desc "Jump to project notes"  "p n" #'+projectile-jump-to-notes)
        (:desc "Jump to project Makefile"  "p m" #'+projectile-jump-to-makefile)
        )


  (setq projectile-project-search-path '("~/workspaces/"))


  ;; (setq projectile-project-root-files-bottom-up '(".projectile"))
  (setq projectile-project-root-files '(".projectile"))
  (setq projectile-auto-discover t)


  (jeff/projectile-discover-projects-in-directory "~/workspaces" 15)


  ;; (setq projectile-project-root-files-top-down-recurring '(".projectile"))

  ;; (setq projectile-project-root-functions '(projectile-root-top-down-recurring ))


  )






(provide 'projectile_config)
;;; projectile_config.el ends here
