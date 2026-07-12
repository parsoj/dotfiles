;;; pi-agent-shell-ui.el --- Pi-like UX for agent-shell buffers -*- lexical-binding: t; -*-

(require 'subr-x)
(require 'map)

(defface jeff/agent-shell-user-message
  '((t (:inherit default :weight normal :extend t)))
  "Face for user-authored messages in `agent-shell'.")

(defface jeff/agent-shell-agent-message
  '((t (:inherit default :background "#1f2430" :extend t)))
  "Face for agent-authored messages in `agent-shell'.")

(defface jeff/agent-shell-thinking-message
  '((t (:inherit font-lock-comment-face :background "#222433" :extend t)))
  "Face for agent thinking/reasoning blocks in `agent-shell'.")

(defface jeff/agent-shell-tool-message
  '((t (:inherit default :background "#202a2a" :extend t)))
  "Face for tool/status blocks in `agent-shell'.")

(defface jeff/agent-shell-input-area
  '((t (:inherit default :weight normal :extend t)))
  "Face for the active input area in `agent-shell'.")

(defface jeff/agent-shell-input-prompt
  '((t (:inherit comint-highlight-prompt :weight bold :extend t)))
  "Face for the active input prompt in `agent-shell'.")

(defun jeff/agent-shell--add-face (start end face)
  "Add FACE to START..END, preserving existing text properties."
  (when (and start end (< start end))
    (let ((inhibit-read-only t))
      (add-face-text-property start end face t))))

(defun jeff/agent-shell--qualified-id-at (pos)
  "Return the agent-shell qualified id at POS, if any."
  (map-elt (get-text-property pos 'agent-shell-ui-state) :qualified-id))

(defun jeff/agent-shell--style-section (range)
  "Apply Pi-like block styling to an agent-shell section RANGE."
  (let* ((block (map-elt range :block))
         (start (map-elt block :start))
         (end (map-elt block :end))
         (qid (and start (jeff/agent-shell--qualified-id-at start))))
    (cond
     ((and qid (string-match-p "agent_message_chunk" qid))
      (jeff/agent-shell--add-face start end 'jeff/agent-shell-agent-message))
     ((and qid (string-match-p "agent_thought_chunk" qid))
      (jeff/agent-shell--add-face start end 'jeff/agent-shell-thinking-message))
     ;; Most tool calls have arbitrary tool ids, so classify labelled fragments
     ;; that are not normal agent prose/thinking as tool/status blocks.
     ((or (map-elt range :label-left) (map-elt range :label-right))
      (jeff/agent-shell--add-face start end 'jeff/agent-shell-tool-message)))))

(defun jeff/agent-shell--contrast-ui-colors ()
  "Return colors for Pi-like `agent-shell' blocks in the current theme."
  (if (eq (frame-parameter nil 'background-mode) 'dark)
      '(:user-bg "#e6edf7" :user-fg "#111827" :user-accent "#1d4ed8"
        :agent-bg "#1f2430" :thinking-bg "#222433"
        :tool-bg "#202a2a" :tool-code-bg "#182222" :tool-fg "#d8dee9")
    '(:user-bg "#1f2937" :user-fg "#f9fafb" :user-accent "#93c5fd"
      :agent-bg "#f2f2f2" :thinking-bg "#eeeeee"
      :tool-bg "#dbe3db" :tool-code-bg "#d1ddd1" :tool-fg "#3f4f3f")))

(defun jeff/agent-shell--set-face-if-present (face &rest specs)
  "Apply SPECS to FACE when FACE is already defined."
  (when (facep face)
    (apply #'set-face-attribute face nil specs)))

(defun jeff/agent-shell-apply-contrast-faces ()
  "Apply contrast-aware faces for Pi-like `agent-shell' UI."
  (let ((colors (jeff/agent-shell--contrast-ui-colors)))
    (set-face-attribute 'jeff/agent-shell-user-message nil
                        :background (plist-get colors :user-bg)
                        :foreground (plist-get colors :user-fg)
                        :extend t)
    (set-face-attribute 'jeff/agent-shell-agent-message nil
                        :background (plist-get colors :agent-bg)
                        :extend t)
    (set-face-attribute 'jeff/agent-shell-thinking-message nil
                        :background (plist-get colors :thinking-bg)
                        :extend t)
    (set-face-attribute 'jeff/agent-shell-tool-message nil
                        :background (plist-get colors :tool-bg)
                        :foreground (plist-get colors :tool-fg)
                        :extend t)
    (set-face-attribute 'jeff/agent-shell-input-area nil
                        :background (plist-get colors :user-bg)
                        :foreground (plist-get colors :user-fg)
                        :extend t)
    (set-face-attribute 'jeff/agent-shell-input-prompt nil
                        :background (plist-get colors :user-bg)
                        :foreground (plist-get colors :user-accent)
                        :weight 'bold
                        :extend t)
    ;; Tool outputs often contain markdown/code blocks.  agent-shell's markdown
    ;; renderer inherits `org-block', which can be very light in dark themes;
    ;; force those panels to sit inside our tool block palette instead.
    (jeff/agent-shell--set-face-if-present
     'agent-shell-markdown-source-block
     :background (plist-get colors :tool-code-bg)
     :foreground 'unspecified
     :extend t)
    (jeff/agent-shell--set-face-if-present
     'agent-shell-markdown-source-block-language
     :background (plist-get colors :tool-code-bg)
     :extend t)))

(defun jeff/agent-shell--window-width ()
  "Return the current buffer window width, with a reasonable fallback."
  (max 40 (if-let* ((win (get-buffer-window (current-buffer))))
              (window-body-width win)
            (window-width))))

(defun jeff/agent-shell--fill-line (&optional text face)
  "Return a window-width line with TEXT padded to the right using FACE."
  (let* ((text (or text ""))
         (width (jeff/agent-shell--window-width))
         (line (concat text (make-string (max 0 (- width (string-width text))) ?\s))))
    (if face (propertize line 'face face) line)))

(defun jeff/agent-shell--rule (&optional label)
  "Return a window-width horizontal rule, optionally annotated with LABEL."
  (let* ((width (jeff/agent-shell--window-width))
         (prefix (if label (format "─ %s " label) "")))
    (concat prefix (make-string (max 0 (- width (string-width prefix))) ?─))))

(defun jeff/agent-shell--add-user-boundary-overlays (start end)
  "Add padded, buffer-spanning background around user message START..END."
  (remove-overlays start end 'jeff/agent-shell-user-boundary t)
  (let ((top (make-overlay start start nil t nil))
        (bottom (make-overlay end end nil nil t)))
    (dolist (ov (list top bottom))
      (overlay-put ov 'jeff/agent-shell-user-boundary t)
      (overlay-put ov 'evaporate t))
    (overlay-put top 'before-string
                 (concat (jeff/agent-shell--fill-line "" 'jeff/agent-shell-user-message) "\n"
                         (jeff/agent-shell--fill-line "  you" 'jeff/agent-shell-user-message) "\n"
                         (jeff/agent-shell--fill-line "" 'jeff/agent-shell-user-message) "\n"))
    (overlay-put bottom 'after-string
                 (concat "\n" (jeff/agent-shell--fill-line "" 'jeff/agent-shell-user-message) "\n"))))

(defun jeff/agent-shell--style-user-text (range)
  "Apply user-message styling to an `agent-shell-ui-update-text' RANGE."
  (let* ((block (map-elt range :block))
         (start (map-elt block :start))
         (end (map-elt block :end)))
    (jeff/agent-shell--add-face start end 'jeff/agent-shell-user-message)
    (when (and start end (< start end))
      (jeff/agent-shell--add-user-boundary-overlays start end))))

(defun jeff/agent-shell-ui-update-text-a (orig &rest args)
  "Style user prompt replay/history text inserted by `agent-shell-ui-update-text'."
  (let ((range (apply orig args)))
    (when-let* ((block-id (plist-get args :block-id))
                ((string-match-p "user_message_chunk" block-id)))
      (jeff/agent-shell--style-user-text range))
    range))

(defun jeff/agent-shell--live-input-region ()
  "Return the editable live input region, if it exists and is non-empty."
  (when (and (derived-mode-p 'agent-shell-mode)
             (boundp 'comint-last-prompt)
             comint-last-prompt
             (cdr comint-last-prompt)
             (marker-position (cdr comint-last-prompt))
             (< (marker-position (cdr comint-last-prompt)) (point-max)))
    (cons (marker-position (cdr comint-last-prompt)) (point-max))))

(defmacro jeff/agent-shell--with-live-input-detached (&rest body)
  "Run BODY with live prompt input temporarily removed.

This gives the agent/shell writer a true `point-max' before the prompt input, so
agent output cannot be appended after text the user is currently typing."
  (declare (indent 0) (debug t))
  `(if-let* ((input-region (jeff/agent-shell--live-input-region)))
       (let* ((input-start (car input-region))
              (input-end (cdr input-region))
              (input (buffer-substring input-start input-end))
              (point-offset (and (>= (point) input-start)
                                 (- (point) input-start)))
              (inhibit-read-only t))
         (delete-region input-start input-end)
         (prog1 (progn ,@body)
           (goto-char (point-max))
           (insert input)
           (when point-offset
             (goto-char (min (point-max)
                             (+ (or (and (boundp 'comint-last-prompt)
                                         comint-last-prompt
                                         (cdr comint-last-prompt)
                                         (marker-position (cdr comint-last-prompt)))
                                    (point-max))
                                point-offset))))))
     ,@body))

(defun jeff/agent-shell-update-fragment-a (orig &rest args)
  "Keep agent fragments out of the editable input area."
  (let* ((state (plist-get args :state))
         (buffer (and state (map-elt state :buffer))))
    (if (not (and buffer (buffer-live-p buffer)))
        (apply orig args)
      (with-current-buffer buffer
        (jeff/agent-shell--with-live-input-detached
          (apply orig args))))))

(defun jeff/shell-maker-write-output-a (orig &rest args)
  "Keep shell-maker output out of the editable `agent-shell' input area."
  (let* ((config (plist-get args :config))
         (buffer (and config (fboundp 'shell-maker-buffer) (shell-maker-buffer config))))
    (if (not (and buffer (buffer-live-p buffer)))
        (apply orig args)
      (with-current-buffer buffer
        (if (derived-mode-p 'agent-shell-mode)
            (jeff/agent-shell--with-live-input-detached
              (apply orig args))
          (apply orig args))))))

(defun jeff/agent-shell-mode-ui-setup ()
  "Install buffer-local UI tweaks for `agent-shell-mode'."
  (jeff/agent-shell-apply-contrast-faces)
  (setq-local line-spacing 0.12)
  ;; Keep the live prompt simple. Do not remap `comint-highlight-input':
  ;; late/out-of-turn agent output can briefly land near the prompt, and a broad
  ;; input-face remap makes those agent diagnostics look like user input.
  (face-remap-add-relative 'comint-highlight-prompt 'jeff/agent-shell-input-prompt))

(after! agent-shell
  (setq agent-shell-header-style 'text
        agent-shell-show-welcome-message nil
        agent-shell-busy-indicator-frames 'dots-round)
  (add-hook 'agent-shell-mode-hook #'jeff/agent-shell-mode-ui-setup)
  (add-hook 'agent-shell-section-functions #'jeff/agent-shell--style-section)
  (advice-add #'agent-shell-ui-update-text :around #'jeff/agent-shell-ui-update-text-a)
  (advice-add #'agent-shell--update-fragment :around #'jeff/agent-shell-update-fragment-a)
  (advice-add #'shell-maker-write-output :around #'jeff/shell-maker-write-output-a)
  (advice-add #'shell-maker-finish-output :around #'jeff/shell-maker-write-output-a))

(after! agent-shell-markdown
  (jeff/agent-shell-apply-contrast-faces))

(after! agent-shell-pi
  ;; Make the active input area read like the Pi/Codex prompt, but keep it as a
  ;; normal comint/agent-shell prompt so all Emacs editing commands still work.
  (advice-add
   #'agent-shell-pi-make-agent-config
   :filter-return
   (lambda (config)
     ;; Keep the active prompt single-line so agent-shell can reliably insert
     ;; late/out-of-turn notifications *above* it. Submitted user messages get
     ;; the full-width padded treatment via `jeff/agent-shell--style-user-text'.
     (setf (map-elt config :shell-prompt) "> "
           (map-elt config :shell-prompt-regexp) "> ")
     config)))

(provide 'pi-agent-shell-ui)
;;; pi-agent-shell-ui.el ends here
