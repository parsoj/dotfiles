(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7e068da4ba88162324d9773ec066d93c447c76e9f4ae711ddd0c5d3863489c52" "7ea883b13485f175d3075c72fceab701b5bf76b2076f024da50dff4107d0db25" default))
 '(package-selected-packages
   '(fish-mode mermaid-mode auto-dark visual-regexp-steroids visual-regexp))
 '(safe-local-variable-values
   '((project-run-script . "./run-scripts/scipctl_plan.sh")
     (project-run-script . "./scipctl_plan.sh")
     (project-run-script . "./run-scipctl-test.sh")
     (project-run-script . "./run-local-test.sh")
     (project-run-script . "./run-jira-metrics.sh")
     (project-run-script . "./run-scipctl-fail.sh")
     (project-run-script . "./run-lsf.sh")
     (project-run-script . "./run-scipctl.sh"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-ui-peek-header ((t (:background "grey50" :foreground "white"))))
 '(lsp-ui-peek-highlight ((t (:background "goldenrod" :foreground "#282c34"))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(ts-fold-replacement-face ((t (:foreground nil :box nil :inherit font-lock-comment-face :weight light)))))
