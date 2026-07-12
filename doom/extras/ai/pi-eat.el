;;; pi-eat.el --- Run native Pi TUI in Eat alongside agent-shell -*- lexical-binding: t; -*-

(require 'subr-x)

(defvar jeff/pi-command "/Users/jeff/.nvm/versions/node/v24.12.0/bin/pi"
  "Path to the native Pi TUI executable.")

(defun jeff/pi-eat--cwd ()
  "Return the directory where native Pi should start."
  (file-name-as-directory
   (expand-file-name
    (or (and (fboundp 'projectile-project-root)
             (ignore-errors (projectile-project-root)))
        default-directory))))

(defun jeff/pi-eat--program ()
  "Return the shell command used to launch native Pi in Eat."
  jeff/pi-command)

(defun jeff/pi-eat--session-name (&optional directory)
  "Return the Eat session name for DIRECTORY."
  (format "pi-eat: %s"
          (file-name-nondirectory
           (directory-file-name (or directory (jeff/pi-eat--cwd))))))

(defun jeff/pi-eat--buffer-name (&optional directory)
  "Return the Pi Eat buffer name for DIRECTORY."
  (format "*%s*" (jeff/pi-eat--session-name directory)))

(defun jeff/pi-eat--live-buffer (&optional directory)
  "Return the existing live Pi Eat buffer for DIRECTORY, if any."
  (let ((buffer (get-buffer (jeff/pi-eat--buffer-name directory))))
    (when (and buffer (get-buffer-process buffer))
      buffer)))

(defun jeff/pi-eat--start-buffer (&optional new-session)
  "Start or reuse a native Pi Eat buffer without displaying it.

With NEW-SESSION, always start a fresh Eat process. This deliberately uses
`eat-make' instead of `eat', because `eat' displays the buffer itself, which can
trigger Doom popup rules before we place the buffer in a sidebar/current window."
  (require 'eat)
  (let* ((default-directory (jeff/pi-eat--cwd))
         (session-name (if new-session
                           (generate-new-buffer-name (jeff/pi-eat--session-name default-directory))
                         (jeff/pi-eat--session-name default-directory)))
         (buffer (or (and (not new-session)
                          (jeff/pi-eat--live-buffer default-directory))
                     (eat-make session-name (jeff/pi-eat--program)))))
    (with-current-buffer buffer
      (when (fboundp 'eat-semi-char-mode)
        (eat-semi-char-mode)))
    buffer))

;;;###autoload
(defun pi-eat (&optional new-session)
  "Run the native Pi TUI in Eat in the current window.

This is intentionally separate from `pi'/`agent-shell-pi-start-agent'. It gives
us Pi's native terminal UI while preserving Eat's Emacs buffer/navigation modes:

  C-c C-j  semi-char mode  (hybrid; good default)
  C-c C-l  line mode       (more Emacs navigation/search)
  C-c C-e  emacs mode      (Emacs owns keys)
  C-c M-d  char mode       (terminal owns almost everything)

With prefix NEW-SESSION, force a fresh Eat session."
  (interactive "P")
  (switch-to-buffer (jeff/pi-eat--start-buffer new-session)))

;;;###autoload
(defun pi-eat-sidebar (&optional new-session)
  "Run the native Pi TUI in Eat as a right sidebar.

With prefix NEW-SESSION, force a fresh Eat session."
  (interactive "P")
  (let ((buffer (jeff/pi-eat--start-buffer new-session)))
    (select-window
     (display-buffer-in-side-window
      buffer
      '((side . right)
        (slot . 1)
        (window-width . 0.42)
        (window-parameters . ((no-delete-other-windows . t))))))))

;; Backward-compatible alias for the previous command name.
(defalias 'pi-eat-current-window #'pi-eat)

(defun jeff/pi-eat-emacs-mode ()
  "Switch Eat to Emacs mode for normal navigation/keybindings."
  (interactive)
  (require 'eat)
  (eat-emacs-mode)
  (message "Pi Eat: Emacs mode (C-c C-j returns to semi-char)"))

(defun jeff/pi-eat-line-mode ()
  "Switch Eat to line mode for Emacs-like navigation/search."
  (interactive)
  (require 'eat)
  (eat-line-mode)
  (message "Pi Eat: line mode (C-c C-j returns to semi-char)"))

(defun jeff/pi-eat-semi-char-mode ()
  "Switch Eat to semi-char mode for Pi TUI interaction."
  (interactive)
  (require 'eat)
  (eat-semi-char-mode)
  (message "Pi Eat: semi-char mode"))

(after! eat
  ;; Make a few Emacs/navigation commands easy to reach without fighting Pi's
  ;; normal single-key TUI controls. For deeper navigation, use C-c C-e or
  ;; C-c C-l first, then normal Emacs/Evil/Avy bindings.
  (map! :map eat-semi-char-mode-map
        "C-c C-a" #'avy-goto-char-timer
        "C-c C-s" #'consult-line
        "C-c C-f" #'isearch-forward
        "C-c C-b" #'isearch-backward
        "C-c C-e" #'jeff/pi-eat-emacs-mode
        "C-c C-l" #'jeff/pi-eat-line-mode
        "C-c C-j" #'jeff/pi-eat-semi-char-mode)
  (map! :map eat-line-mode-map
        "C-c C-a" #'avy-goto-char-timer
        "C-c C-s" #'consult-line
        "C-c C-j" #'jeff/pi-eat-semi-char-mode)
  (map! :map eat-mode-map
        "C-c C-a" #'avy-goto-char-timer
        "C-c C-s" #'consult-line))

(map! :leader
      (:prefix-map ("a" . "AI / Pi")
       :desc "Pi: native TUI"         "e" #'pi-eat
       :desc "Pi: native TUI sidebar" "E" #'pi-eat-sidebar))

(provide 'pi-eat)
;;; pi-eat.el ends here
