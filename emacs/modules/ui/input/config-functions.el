

(with-eval-after-load '+hydra
  (defvar hydra-config-actions--title (s-concat (all-the-icons-faicon "sliders" :v-adjust .05) " Configuration Actions" ))

  (pretty-hydra-define hydra-config-actions
                        ;(:color teal :quit-key "ESC" :title "boop")
                        (:color teal :title hydra-config-actions--title)
                        (
			 "Emacs Config"
                         (("M" create-new-module "new module")
                          ("m" jump-to-module "module")
                          ("s" jump-to-scratch-file "scratch file")
                          ("S" create-new-scratch-file "new scratch file")
                          ("i" (lambda() (interactive) (find-file (concat config-root "init.el") )) "init.el" )
                          ;;("j" (lambda() (interactive) (find-file (concat config-root "init.el") )) "init.el" ) ;;just adding a duplicate head since hydra-posframe is comming out too small
			  )
			 "Package Dependencies"
			 (("l" (lambda() (interactive) (find-file "~/.emacs.d/straight/versions/default.el") ) "packages lockfile")
			  ("p" jump-to-package "package code")
			  )

			  "Window Mangement"
			 (("y" (lambda() (interactive) (find-file "~/.yabairc")) "yabairc")
			  ("Y" (lambda() (interactive) (find-file "~/Dropbox/Code/docs/yabai.asciidoc" )) "yabai docs"))

			"OSX Keybinds"
			 (("k" (lambda() (interactive) (find-file "~/.skhdrc")) "skhdrc")
			  ("K" (lambda() (interactive) (find-file "~/Dropbox/Code/docs/yabai.asciidoc")) "skhd docs"))
			 )
			)


  (general-define-key
   :states '(normal visual emacs movement treemacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "c" 'hydra-config-actions/body
   )
)


