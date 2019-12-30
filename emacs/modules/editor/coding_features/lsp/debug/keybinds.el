

( with-eval-after-load '+hydra

  
  (defvar hydra-debug-actions--title (s-concat (all-the-icons-faicon "bug" :v-adjust .05) " Debug Actions" ))

  (pretty-hydra-define hydra-debug-actions
    (
     :title hydra-debug-actions--title
     :color amaranth
     :pre (funcall +project-debug-function)
     )
    (
     "Debug Actions"
     (
      ("n" dap-next "Next")
      ("i" dap-step-in "Step In")
      ("o" dap-step-out "Step Out")
      ("c" dap-continue "Continue")
      ("q" dap-disconnect "Quit/Disconnect" :color blue)
      )

     )

    )

  

  )
