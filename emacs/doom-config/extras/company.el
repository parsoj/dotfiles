;;; ../.config/emacs/doom-config/extras/company.el -*- lexical-binding: t; -*-



(after! company
  (setq company-idle-delay 0)
  (setq company-echo-delay 0)
  (setq company-show-numbers t)


  ;; ------------------------------------------------------------------------------------------
  ;; code to quickly pick a completion candidate by its number
  ;; taken from https://oremacs.com/2017/12/27/company-numbers/

  (defun ora-company-number ()
    "Forward to `company-complete-number'.
     Unless the number is potentially part of the candidate.
     In that case, insert the number."

    (interactive)
    (let* ((k (this-command-keys))
           (re (concat "^" company-prefix k)))
      (if (cl-find-if (lambda (s) (string-match re s))
                      company-candidates)
          (self-insert-command 1)
        (company-complete-number (string-to-number k)))))


  ;; insert keymaps for completion by number
  (let ((map company-active-map))
    (mapc
     (lambda (x)
       (define-key map (format "%d" x) 'ora-company-number))
     (number-sequence 0 9))
    ;; (define-key map " " (lambda ()
    ;;                       (interactive)
    ;;                       (company-abort)
    ;;                       (self-insert-command 1)))
    ;; (define-key map (kbd "<return>") nil)
    )


  ;; ------------------------------------------------------------------------------------------

  )
