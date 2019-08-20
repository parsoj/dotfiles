(use-package gcmh
  :init
  (setq gcmh-idle-delay 3)
  :config
  (gcmh-mode 1)
 )

;;(use-package fast-scroll
;;  :straight (fast-scroll :host github :repo "ahungry/fast-scroll")
;;  :hook
;;  ((fast-scroll-start . (lambda () (flycheck-mode -1)))
;;   (fast-scroll-end . (lambda () (flycheck-mode 1))))
;;  :init
;;  (setq fast-scroll-throttle 1.0) 
;;  :config
;;  (advice-add #'mac-mwheel-scroll :around #'fast-scroll-run-fn-minimally)
;;
;;  (fast-scroll-config) 
;;  (fast-scroll-minor-mode 1) 
;;  )
