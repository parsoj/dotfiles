;;; ../.config/emacs/doom-config/extras/apps/vault.el -*- lexical-binding: t; -*-



(defvar vault-namespace nil)
(defvar vault-addr nil)
(defvar vault-userpass-username nil)

(setq vault-userpass-login-path "/v1/auth/userpass/login/")

(defun vault-init ()
  (setenv "VAULT_ADDR" vault-addr)
  (setenv "VAULT_NAMESPACE" vault-namespace)
  )


(defun vault-prompt-for-pass ()
  (completing-read "Vault Password: " nil nil nil)
  )


(defun vault-userpass-login ()
  (let* ((vault-resp (plz 'post (concat vault-addr vault-userpass-login-path vault-userpass-username)
                       :headers `(("Content-Type" . "application/json")
                                  ("X-Vault-Namespace" . ,vault-namespace))
                       :body (json-encode `(("password" . ,(vault-prompt-for-pass))))
                       :as #'json-read)
                     )
         (resp-vault-token (let-alist vault-resp .auth.client_token)))
    (setq vault-token resp-vault-token)
    (setenv "VAULT_TOKEN" resp-vault-token)
    )

  )
