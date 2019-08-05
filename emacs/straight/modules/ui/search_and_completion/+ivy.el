;;; +ivy.el --- description -*- lexical-binding: t; -*-

(use-package ivy
  :config
  (ivy-mode 1)

  )

(use-package counsel
  :after (ivy)
  )

(use-package swiper
  :after (ivy)
  )

(use-package ivy-posframe
  :after (ivy)
  :hook (ivy-mode . ivy-posframe-mode)
  :config
  (setq ivy-fixed-height-minibuffer nil
        ivy-posframe-border-width 2
        ivy-posframe-parameters
        `((min-width . 90)
          (min-height . ,ivy-height)))

  ;(set-face-attribute 'ivy-posframe-border :background 'black)

  ;; default to posframe display function
  (setf (alist-get t ivy-posframe-display-functions-alist) #'ivy-posframe-display-at-frame-center)

  ;; posframe doesn't work well with async sources
  (dolist (fn '(swiper counsel-ag counsel-grep counsel-git-grep))
    (setf (alist-get fn ivy-posframe-display-functions-alist) #'ivy-display-function-fallback))
  )




(provide '+ivy)
;;; +ivy.el ends here
