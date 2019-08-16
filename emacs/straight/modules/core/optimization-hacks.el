(use-package gcmh
  :config
  (gcmh-mode 1)
 )

(use-package fast-scroll
  :straight (fast-scroll :host github :repo "ahungry/fast-scroll")
  :config
  (fast-scroll-config)
  (fast-scroll-advice-scroll-functions)
  )
