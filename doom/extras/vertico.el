;;; extras/vertico.el -*- lexical-binding: t; -*-

;; (setq vertico-posframe-min-height 30)
;; (setq vertico-posframe-height nil)


(after! vertico
  (setq vertico-resize t)
  (setq vertico-count 35)
  (vertico-indexed-mode 1)

(after! consult
  (progn
    (setq consult--read-config nil)
    (consult-customize
     :preview-key '(:debounce 0.2 any)
     )
    )
)
  )
