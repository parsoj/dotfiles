;;; +hydra.el --- hydra configuration -*- lexical-binding: t; -*-

(use-package hydra)


(use-package major-mode-hydra
  :after (hydra pretty-hydra)
  :bind
  ("," . major-mode-hydra)

  )

(use-package pretty-hydra
  :after (hydra)
  )

(provide '+hydra)
;;; +hydra.el ends here
