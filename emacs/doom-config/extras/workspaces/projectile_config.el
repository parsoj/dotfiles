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

(after! projectile
  ;;(setq projectile-project-root-functions '(projectile-root-bottom-up))
  (setq projectile-project-root-files-bottom-up '(".projectile"))

  (set-popup-rule! "^\\*compilation\\*"  :side 'right :quit nil :select t)

  (map! :leader
        (:desc "Run project"                  "p R" #'jeff/projectile-run-project)
        )

  )






(provide 'projectile_config)
;;; projectile_config.el ends here
