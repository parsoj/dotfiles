;;; ../.config/emacs/doom/org/plantuml.el -*- lexical-binding: t; -*-

(after! plantuml-mode
  (if  (not (file-exists-p! plantuml-jar-path))
      (plantuml-download-jar)
      ))
