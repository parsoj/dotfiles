;;; +hydra.el --- hydra configuration -*- lexical-binding: t; -*-

(use-package hydra)


(use-package major-mode-hydra
  :after (hydra pretty-hydra)
  :bind
  ;("," . major-mode-hydra)

  )

(use-package pretty-hydra
  :after (hydra)
  )

(use-package hydra-posframe
  :straight (hydra-posframe :host github :repo "Ladicle/hydra-posframe")
  :after (hydra posframe)
  :load-path "<path-to-the-hydra-posframe>"
  :hook (after-init . hydra-posframe-enable)

  :init
  (setq hydra-posframe-border-width 2)

  )

(provide '+hydra)
;;; +hydra.el ends here
