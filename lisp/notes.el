;;; notes.el --- Helpers for taking notes with Org Mode

;;; Code:

(setq-default notes-dir "~/school/")

(defun notes-create(subject number)
  "Create a .org file in SUBJECT for lesson NUMBER today."
  (interactive "sSubject? \nsLesson? ")
  (if (file-exists-p (concat notes-dir subject))
      (find-file
       (format-time-string (concat notes-dir subject "/%b%d" number ".org")))
    (message "Unknown subject '%s'" subject)))

(defun notes-last(subject)
  "Find the most recently changed .org file in folder SUBJECT."
  (interactive "sSubject? ")
  (let (org-file (most-recent '(0 0 0 0)) most-recent-name)
    (dolist (org-file (directory-files (concat notes-dir subject "/") t ".*\.org$"))
      (if
          (time-less-p most-recent (file-attribute-modification-time (file-attributes org-file)))
          (funcall (lambda()
                     (setq most-recent (file-attribute-modification-time (file-attributes org-file)))
                     (setq most-recent-name org-file)
                     )))
      )
    (find-file most-recent-name)))

(provide 'notes)

;;; notes.el ends here
