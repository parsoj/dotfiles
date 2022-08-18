;;; extras/lang/elisp.el -*- lexical-binding: t; -*-

(after! edebug

  ;; edebug has its own custom pop-to-buffer defined - which causes
  ;; its buffers to ignore doom's popup system
  (defun edebug-pop-to-buffer (buffer &optional window)
    (pop-to-buffer buffer)
    )

  )
