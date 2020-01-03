;;;###autoload
(defun +eval-display-results-in-popup (output &optional _source-buffer)
  "Display OUTPUT in a popup buffer."
  (if (with-temp-buffer
        (insert output)
        (>= (count-lines (point-min) (point-max))
            +eval-popup-min-lines))
      (let ((output-buffer (get-buffer-create "*doom eval*"))
            (origin (selected-window)))
        (with-current-buffer output-buffer
          (setq-local scroll-margin 0)
          (erase-buffer)
          (insert output)
          (goto-char (point-min))
          (if (fboundp '+word-wrap-mode)
              (+word-wrap-mode +1)
            (visual-line-mode +1)))
        (when-let (win (display-buffer output-buffer))
          (fit-window-to-buffer
           win (/ (frame-height) 2)
           nil (/ (frame-width) 2)))
        (select-window origin)
        output-buffer)
    (message "%s" output)))

;;;###autoload
(defun +eval-display-results-in-overlay (output &optional source-buffer)
  "Display OUTPUT in a floating overlay next to the cursor."
  (require 'eros)
  (let ((this-command #'+eval/buffer-or-region)
        eros-overlays-use-font-lock)
    (with-current-buffer (or source-buffer (current-buffer))
      (eros--make-result-overlay output
				 :where (line-end-position)
				 :duration eros-eval-result-duration))))

;;;###autoload
(defun +eval-display-results (output &optional source-buffer)
  "Display OUTPUT in an overlay or a popup buffer."
  (funcall (if (or current-prefix-arg
                   (with-temp-buffer
                     (insert output)
                     (>= (count-lines (point-min) (point-max))
                         +eval-popup-min-lines))
                   (not (require 'eros nil t)))
               #'+eval-display-results-in-popup
             #'+eval-display-results-in-overlay)
           output source-buffer)
  output)


