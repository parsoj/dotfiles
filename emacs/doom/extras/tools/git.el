;;; ../.config/emacs/doom-config/extras/tools/git.el -*- lexical-binding: t; -*-


(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))

(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))


(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)


(use-package! blamer
  :config
  (setq blamer-min-offset 30)
  (setq blamer-max-commit-message-length 10)

  (setq blamer-uncommitted-changes-message "-NC-")


  (setq blamer-type 'visual)
  (setq blamer--overlay-popup-position 'top)


  (global-blamer-mode 1)
  )
