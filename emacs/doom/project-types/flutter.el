;;; ../.config/emacs/doom/project-types/flutter.el -*- lexical-binding: t; -*-



;;; trigger the hot-reloading in the flutter vterm
;; (with-current-buffer "*vterm*"
;;   (let ((inhibit-read-only t))
;;     (vterm-send-string "r")))


(defun jp/flutter-run-or-hot-reload ()
  (interactive)
  (progn
    (pop-to-buffer "*Flutter*")
    (flutter-run-or-hot-reload)
    )
  )


(map! :leader
      :mode 'flutter
      :desc "run-or-hot-reload" "m r" #'jp/flutter-run-or-hot-reload

      )
