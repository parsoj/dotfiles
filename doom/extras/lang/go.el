;;; ../.config/emacs/doom-config/extras/lang/go.el -*- lexical-binding: t; -*-

(set-lookup-handlers! 'go-mode
  :definition #'lsp-ui-peek-find-definitions
  :references #'lsp-ui-peek-find-references
  )


(add-hook! go-mode #'aggressive-indent-mode)


;; (setq dap-go-debug-path "/Users/jeff/workspaces/tools/vscode-go")
;; (setq dap-go-debug-program `("node" ,(f-join dap-go-debug-path "extension/dist/debugAdapter.js")))
;; (setq dap-go-debug-program '("node" "/Users/jeff/.emacs.d/.local/etc/dap-extension/vscode/golang.go/extension/dist/debugAdapter.js"))


(after! dap-mode
  (dap-register-debug-provider
   "dlv"
   (lambda (conf)

     (plist-put conf :host "127.0.0.1")

     ;; (plist-put conf :debugPort 40001)
     (plist-put conf :debugServer 40001)

     ;; (plist-put conf :type "dlv")
     ;; (plist-put conf :name "go delve")
     conf))



  (dap-register-debug-template "Go dlv direct"
                               (list :type "dlv"
                                     :request "attach"
                                     :mode "remote"
                                     ;; :args ""
                                     ;; :name "dlv-direct remote attach"
                                     ;; :program nil
                                     ;; :envFile nil
                                     ;; :port 40001
                                     ;; :env nil
                                     ))

  )
