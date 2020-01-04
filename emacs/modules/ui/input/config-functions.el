

(with-eval-after-load '+hydra
  (with-eval-after-load '+navigation-helpers

    (defun create-new-module ()
      (interactive)
      (let ((module-dir (completing-read
			 "Pick Directory to create in: "
			 (get-modules-directories)
			 nil t)))

	(counsel-file-jump nil module-dir)
	;; TODO load list of directories, and prompt for parent dir for new module
	;; TODO ask for file/path name from that starting point
	;; TODO create new file there and open it
	)
      )


    (defvar hydra-config-actions--title (s-concat (all-the-icons-faicon "sliders" :v-adjust .05) " Configuration Actions" ))

    (pretty-hydra-define hydra-config-actions
					;(:color teal :quit-key "ESC" :title "boop")
      (:color teal :title hydra-config-actions--title)
      (
       "Emacs Config"
       (("M" create-new-module "new module")
	("m" (lambda() (interactive) (do-find-file-jump "Jump To Module: " (get-all-config-files)) ) "module")
	("s" jump-to-scratch-file "scratch file")
	("S" create-new-scratch-file "new scratch file")
	("i" (lambda() (interactive) (find-file (concat emacs-config-root "init.el") )) "init.el" )
	)
       "Package Dependencies"
       (("l" (lambda() (interactive) (find-file "~/.emacs.d/straight/versions/default.el") ) "packages lockfile")
	("p" (lambda() (interactive) (do-find-file-jump "Jump To Package: " (get-all-package-files-cached)) ) "package code")
	)

       "Window Mangement"
       (("y" (lambda() (interactive) (find-file "~/.yabairc")) "yabairc")
	("Y" (lambda() (interactive) (find-file "~/Dropbox/Code/docs/yabai.asciidoc" )) "yabai docs"))

       "OSX Keybinds"
       (("k" (lambda() (interactive) (find-file "~/.skhdrc")) "skhdrc")
	("K" (lambda() (interactive) (find-file "~/Dropbox/Code/docs/yabai.asciidoc")) "skhd docs"))

       "Brewfile"
       (("b" (lambda() (interactive) (find-file (concat system-config-root "/osx/Brewfile" ))) "skhdrc"))

       )
      )


    (general-define-key
     :states '(normal visual emacs movement treemacs)
     :prefix "SPC"
     :non-normal-prefix "M-SPC"
     "c" 'hydra-config-actions/body
     )
    ))


