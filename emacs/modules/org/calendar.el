
;;********************************************************************************
;; Calendar
;; NOTE - we expect "org-caldav-oauth2-client-id" and "org-caldav-oauth2-client-secret" to be set in a secrets file

(use-package org-gcal
:init
(setq org-gcal-fetch-file-alist '(
                            ;; ("jeff@messydesk.solutions" . "/Users/jeffp/org/calendar/messydesk-calendar.org")
                            ("jeffp@remitly.com" . "/Users/jeffp/org/calendar/remitly-calendar.org")
                            ))
)
