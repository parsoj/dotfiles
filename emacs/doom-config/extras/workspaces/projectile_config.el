;;; projectile_config.el --- configurations for projectile  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Jeff Parsons

;; Author: Jeff Parsons <parsoj@gmail.com>


(defun jeff/projectile-run-project ()
  (interactive)

  (let ((func-or-cmd projectile-project-run-cmd))
    (cond ((stringp func-or-cmd)
           (projectile-run-project func-or-cmd))
          ((functionp func-or-cmd)
           (funcall func-or-cmd))
          (t
           (eval func-or-cmd)
           )
      ))

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
                 (projectile-discover-projects-in-directory dir (- recursion-depth 1))
                 )
               )))
         subdirs))
    (message "Project search path directory %s doesn't exist" directory)))


(after! projectile
  ;;(setq projectile-project-root-functions '(projectile-root-bottom-up))
  ;; (setq projectile-project-root-files-bottom-up '(".projectile"))

  (set-popup-rule! "^\\*compilation\\*"  :side 'right :quit nil :select t)

  (map! :leader
        (:desc "Run project"                  "p R" #'jeff/projectile-run-project)
        )

  (map! :leader "p n"  (cmd! (find-file (concat (projectile-project-root) "notes.org"))))

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
