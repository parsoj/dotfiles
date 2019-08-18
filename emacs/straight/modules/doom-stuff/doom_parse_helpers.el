
(defun get-doom-modules-list ()
  (append
   (directory-files-recursively "~/dotfiles/emacs/doom/modules" "\\.el$")
   (directory-files-recursively "~/code/reference-code/doom-emacs/modules" "[^#]\\.el$")
   )
)
