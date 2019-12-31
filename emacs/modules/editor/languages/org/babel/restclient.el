(use-package ob-restclient
  :config
  
  (with-eval-after-load 'ob-async
    ;; async execution happens in a sub-process that doesn't have the default init.el loaded - this hook makes sure that the ob-restclient code is available in that context
    ;; XXXXX- eventually, this may become problemmatic if there are a ton of things running in this hook every time
    (add-hook 'ob-async-pre-execute-src-block-hook
              '(lambda ()
		 (require 'ob-restclient))))
  )
