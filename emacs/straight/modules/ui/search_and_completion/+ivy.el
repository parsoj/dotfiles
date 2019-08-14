;;; +ivy.el --- description -*- lexical-binding: t; -*-

(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil)

  (setq completion-ignored-extensions '("~" ".swp" "#")) 

:config
(ivy-mode 1)
  )

(use-package all-the-icons-ivy
  :after (ivy all-the-icons)
  :config
  (all-the-icons-ivy-setup) 
  )

(use-package ivy-rich
  :after (counsel swiper ivy)
  :config
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

  (ivy-rich-mode 1)
)

(use-package counsel
  :after (ivy)
)

(use-package swiper
  :after (ivy)
  )

(use-package ivy-posframe
  :after (ivy posframe)
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

  (ivy-posframe-mode 1)
  )





(provide '+ivy)
;;; +ivy.el ends here
