(use-package doom-themes
:config

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-one t)

;; Enable flashing mode-line on errors
;(doom-themes-visual-bell-config)

;; or for treemacs users
(doom-themes-treemacs-config) 

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

)

;; TODO check out nord theme: https://github.com/arcticicestudio/nord-emacs

;;(use-package wilmersdorf-theme
;;  :straight (wilmersdorf-theme :host github :repo "ianpan870102/wilmersdorf-emacs-theme")
;;  )

(use-package solaire-mode
  :hook
  ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
  (minibuffer-setup . solaire-mode-in-minibuffer)
  :config
  (solaire-global-mode +1)
  (solaire-mode-swap-bg) 

  )
