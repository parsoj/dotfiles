;;; ../.config/emacs/doom-config/extras/org/style.el -*- lexical-binding: t; -*-


(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'visual-line-mode)


(setq org-tags-column 0)                ;; Show tags directly after headings (not on the right), which plays nicer with line-wrapping.

(setq org-ellipsis "  ")               ;; what is shown when a heading is folded

(setq org-src-fontify-natively t)       ;; Syntax highlightning in code blocks

(setq org-hide-emphasis-markers t)

(setq org-fontify-done-headline t)      ;; change

(setq org-fontify-whole-heading-line t)

(setq org-fontify-quote-and-verse-blocks t)


(custom-theme-set-faces
 'user
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
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))
