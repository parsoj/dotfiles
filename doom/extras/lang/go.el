;;-*- lexical-binding: t; -*-

(set-lookup-handlers! 'go-mode
  :definition #'lsp-ui-peek-find-definitions
  :references #'lsp-ui-peek-find-references
  )

(map! :map go-mode-map
      (:leader :desc "eval line" "e l" #'gorepl-eval-line)
      (:leader :desc "eval region" "e r" #'gorepl-eval-region)

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



  ;; (dap-register-debug-template "Go dlv direct"
  ;;                              (list :type "dlv"
  ;;                                    :request "attach"
  ;;                                    :mode "remote"
  ;;                                    ;; :args ""
  ;;                                    ;; :name "dlv-direct remote attach"
  ;;                                    ;; :program nil
  ;;                                    ;; :envFile nil
  ;;                                    ;; :port 40001
  ;;                                    ;; :env nil
  ;;                                    ))
  ;;





;; (dap-register-debug-template
;;   "SCIPCTL DEBUG"
;;   (list :type "go"
;;         :request "launch"
;;         :name "Launch File"
;;         :mode "debug"
;;         :program "/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/scipctl/main.go"
;;         :args "apply infra"

;;         ;; this is the wd to run the code in
;;         :cwd "/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/dbl-galactus/"

;;         ;;this is the directory of the project being compiled/debugged
;;         :dlvCwd "/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/scipctl/"

;;         :env nil))




;;(setq dap-dlv-go-extra-args "--wd=\"/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/dbl-galactus/\"")


;(dap-register-debug-template
;  "SCIPCTL DEBUG BIN"
;  (list :type "go"
;        :request "launch"
;        :name "Launch bin"
;        :mode "exec"
;        ;:program "/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/scipctl/main.go"
;        :program "/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/scipctl/scipctl"
;        :args "apply infra"
;        :cwd "/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/dbl-galactus/"
;
;        ;; :buildFlags nil
;        ;; :buildFlags "---wd=/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/dbl-galactus/"
;        ;;:--wd "/Users/Jeff.Parsons/workspaces/dreambox/SRE-22234/dbl-galactus/"
;        :env nil))




  )

;; go install github.com/x-motemen/gore/cmd/gore@latest
;; go install github.com/stamblerre/gocode@latest
;; go install golang.org/x/tools/cmd/godoc@latest
;; go install golang.org/x/tools/cmd/goimports@latest
;; go install golang.org/x/tools/cmd/gorename@latest
;; go install golang.org/x/tools/cmd/guru@latest
;; go install github.com/cweill/gotests/gotests@latest
;; go install github.com/fatih/gomodifytags@latest
;; go install github.com/go-delve/delve/cmd/dlv@latest
;; go install honnef.co/go/tools/cmd/staticcheck@2022.1
