;;; tools/parsoj-magit/config.el -*- lexical-binding: t; -*-


(map!
 (:after magit
   :map magit-mode-map
   [escape] #'+magit/quit
   )
 )
