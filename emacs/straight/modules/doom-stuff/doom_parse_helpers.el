
(defun get-doom-modules-list ()
  (append
   (directory-files-recursively "~/dotfiles/emacs/doom/modules" "\\.el$")
   (directory-files-recursively "~/doom-emacs/modules" "[^#]\\.el$")
   )
)
