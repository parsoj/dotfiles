;;; emacs/projects/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +pop-to-project-todo-file ()
  (interactive)
  (pop-to-buffer
   (let ((existing-buffer (get-buffer "*NOTES*")))
     (if existing-buffer
         existing-buffer
         (make-indirect-buffer
          (find-file-noselect (concat (projectile-project-root) "/NOTES.org" ))
          "*NOTES*"
          t
          )))
   )
  )


(defun +run-project ()

                                (+eshell/open-popup
                                 (concat
                                  (projectile-project-root)
                                  "/mothra"
                                  )

                                 (string-join
                                  '(
                                    "cd mothra"
                                    "docker kill mothra;"
                                    "docker rm mothra;"
                                    "docker build -t mothra ."
                                    "docker run -dit --name mothra mothra"
                                    "cd /docker:mothra:/mothra"
                                    )
                                  " && "
                                  )

                                 )

  )
