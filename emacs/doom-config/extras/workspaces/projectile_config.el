;;; projectile_config.el --- configurations for projectile  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Jeff Parsons

;; Author: Jeff Parsons <parsoj@gmail.com>


(after! projectile
  ;;(setq projectile-project-root-functions '(projectile-root-bottom-up))
  (setq projectile-project-root-files-bottom-up '(".projectile"))

  )



(defun +create-new-workspace-at (parent-dir workspace-name)
  (let ((workspace-path (concat parent-dir "/" workspace-name)))
    (if (file-directory-p workspace-path)
        t
      (progn
        (make-directory workspace-path t)
        (write-region "" nil (concat workspace-path "/.projectile"))
        (write-region "" nil (concat workspace-path "/" workspace-name ".org"))
        )
      ))
  )





(provide 'projectile_config)
;;; projectile_config.el ends here
