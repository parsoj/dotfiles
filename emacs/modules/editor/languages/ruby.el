(use-package ruby-mode
 ;; :ensure-system-package
 ;; (("/usr/local/opt/ruby/bin/ruby" . "brew install ruby"))

  :config
  (add-to-exec-path "/usr/local/opt/ruby/bin") 
  (add-to-exec-path "/usr/local/lib/ruby/gems/2.6.0/bin") 
)

(use-package inf-ruby
  ;;:ensure-system-package (("/usr/local/lib/ruby/gems/2.6.0/bin/irb" . "gem install irb"))
  ) 


(use-package robe
  :after (company ruby-mode inf-ruby)
 ;; :ensure-system-package
 ;; (
 ;;  (pry . "gem install pry")
 ;;  (pry-doc . "gem install pry-doc")
 ;;  (method_source . "gem install method_source"))


  :hook (ruby-mode . robe-mode)

  :config
  (push 'company-robe company-backends) 

  ) 

 
