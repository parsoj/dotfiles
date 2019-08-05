;;; +ivy.el --- description -*- lexical-binding: t; -*-


(use-package ivy
  :straight t
  :config
  (ivy-mode 1)

  )

(use-package ivy-posframe
  :straight t
  :after (ivy)
  :hook (ivy-mode . ivy-posframe-mode)
  :config
  (setq ivy-fixed-height-minibuffer nil
        ivy-posframe-border-width 10
        ivy-posframe-parameters
        `((min-width . 90)
          (min-height . ,ivy-height)))

  ;; posframe doesn't work well with async sources
  (dolist (fn '(swiper counsel-ag counsel-grep counsel-git-grep))
    (setf (alist-get fn ivy-posframe-display-functions-alist) #'ivy-display-function-fallback))
  )




(provide '+ivy)
;;; +ivy.el ends here
