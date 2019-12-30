
(dap-register-debug-template
 "TestA"
 (list
  :name "Python: Flask"
  :type "python"
  :request "launch"
  :module "flask"
  :cwd nil
  ;;  :target-module nil ;;(expand-file-name "~/code/vscode-flask-walkthrough/app.py")
  ;;:target-module (expand-file-name "~/code/vscode-flask-walkthrough/app.py")

  :env '(
	 ("FLASK_APP" . "app.py")
	 ("FLASK_ENV" . "development")
	 ("FLASK_DEBUG": "0")
	 )
  :args (concat
	 "run"
	 " --no-debugger"
	 " --no-reload"
	 )
  :program nil
  :jinja t
  ))
