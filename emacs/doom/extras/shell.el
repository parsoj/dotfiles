;;; ../.config/emacs/doom-config/extras/shell.el -*- lexical-binding: t; -*-


(defun +shell--send-input (buffer input &optional no-newline)
  (when input
    (with-current-buffer buffer
      (unless (number-or-marker-p (cdr comint-last-prompt))
        (message "Waiting for shell to start up...")
        (while (not (number-or-marker-p (cdr comint-last-prompt)))
          (sleep-for 0.1)))
      (goto-char (cdr comint-last-prompt))
      (delete-region (cdr comint-last-prompt) (point-max))
      (insert input)
      (comint-send-input no-newline))))

(defun +get-create-shell (directory &optional command)
  "Toggle a persistent terminal popup window.

If popup is visible but unselected, selected it.
If popup is focused, kill it."
  (interactive)
  (let ((buffer
         (get-buffer-create
          (format "doom:shell:%s"
                  (if (bound-and-true-p persp-mode)
                      (safe-persp-name (get-current-persp))
                    "main"))))
        (dir (expand-file-name directory)))
    (with-current-buffer (switch-to-buffer buffer)
      (if (eq major-mode 'shell-mode)
          (+shell--send-input buffer (format "cd %S" dir))
        (shell buffer))
      (let ((process (get-buffer-process buffer)))
        (set-process-sentinel process #'+shell--sentinel)
        (+shell--send-input buffer command)))
    buffer
    ))



(map! :leader
      :mode 'shell-mode
      :desc "Search History" "m h" #'counsel-shell-history

      )
