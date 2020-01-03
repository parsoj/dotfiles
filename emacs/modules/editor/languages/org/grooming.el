

(defun +org-set-purchase-price ()
  (interactive)
  (org-set-property "PRICE" (read-string "Price for purchase: "))
  (org-set-tags '("purchase"))
  )



(defun +org-add-tag ()
  (interactive)
  (counsel-org-tag)
  )


