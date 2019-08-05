;;; +hydra.el --- hydra configuration -*- lexical-binding: t; -*-

(use-package hydra
  :straight t)


(use-package major-mode-hydra
  :straight t
  :after (hydra pretty-hydra)
  :bind
  ("," . major-mode-hydra)

  )

(use-package pretty-hydra
  :straight t
  :after (hydra)
  )
(provide '+hydra)
;;; +hydra.el ends here
