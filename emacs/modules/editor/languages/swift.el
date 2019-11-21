

(use-package swift-mode
  :hook (swift-mode . (lambda () (lsp))))

(use-package lsp-sourcekit
  :after lsp-mode
  :init
  (setq
   sourcekit-toolchain-path "/Library/Developer/Toolchains/swift-5.1-DEVELOPMENT-SNAPSHOT-2019-08-31-a.xctoolchain"
   sourcekit-exec-files (concat sourcekit-toolchain-path "/usr/bin")
   lsp-sourcekit-executable (concat sourcekit-exec-files "sourcekit-lsp")
   )

  (setenv "SOURCEKIT_TOOLCHAIN_PATH" sourcekit-toolchain-path) 
  (add-to-exec-path sourcekit-exec-files)
  (setenv "TOOLCHAINS" "swift")
  )
