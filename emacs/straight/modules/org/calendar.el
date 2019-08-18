
;;********************************************************************************
;; Calendar
;; NOTE - we expect "org-caldav-oauth2-client-id" and "org-caldav-oauth2-client-secret" to be set in a secrets file

(def-package! org-gcal)
(setq org-gcal-file-alist '(
                            ;; ("jeff@messydesk.solutions" . "/Users/jeffp/org/calendar/messydesk-calendar.org")
                            ("jeffp@remitly.com" . "/Users/jeffp/org/calendar/remitly-calendar.org")
                            ))
