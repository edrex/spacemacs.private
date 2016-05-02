;; Sources

;; http://pages.sachachua.com/.emacs.d/Sacha.html
(setq journal-directory "~/Documents/Journal/")

(defun my/journal-path (time name)
  (concat (file-name-as-directory journal-directory) (format-time-string "%Y-%m-%d" time) "-" name ".org")
  )
(defun my/journal (title)
  "Open the journal file for today"
  (interactive "sTitle: ")
  (find-file (my/journal-path nil title)))

;; http://emacsredux.com/blog/2013/05/04/rename-file-and-buffer/

(defun my/rename-current-buffer-file (new-name)
  "Renames current buffer and file it is visiting."
  (interactive "New name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (error "A buffer named '%s' already exists!" new-name)
        (rename-file filename new-name 1)
        (rename-buffer new-name)
        (set-visited-file-name new-name)
        (set-buffer-modified-p nil)
        (message "File '%s' successfully renamed to '%s'"
                 name (file-name-nondirectory new-name))))))


(defun my/rename-current-buffer-file-y-n (target)
  (if (y-or-n-p
       (concat "Move current file to " target "?"))
       (my/rename-current-buffer-file target)))

(defun my/move-to-journal ()
  "Move current buffer file into journal dir"
  (interactive)
  (let* ((time (nth 5 (file-attributes (buffer-file-name))))
         (target (my/journal-path time (file-name-base buffer-file-name))))
    (my/rename-current-buffer-file-y-n target)))

;; https://punchagan.wordpress.com/2010/07/30/refile-to-date-tree/

;; https://lists.gnu.org/archive/html/emacs-orgmode/2014-12/msg00088.html
(defun org-refile-and-link ()
  "Refile heading, adding a link to the new location.
  Prefix arguments are interpreted by `org-refile'."
  (interactive)
  (when (member current-prefix-arg '(3 (4) (16)))
    (user-error "Linking is incompatible with that prefix argument"))
  (let ((heading  (org-get-heading t t))
        (orig-file (buffer-file-name)))
    (call-interactively #'org-refile)
    (let* ((refile-file
            (bookmark-get-filename
             (assoc (plist-get org-bookmark-names-plist :last-refile)
                    bookmark-alist)))
           (same-file (string= orig-file refile-file))
           (link (if same-file
                     (concat "*" heading)
                   (concat refile-file "::*" heading)))
           (desc heading))
      (open-line 1)
      (insert (org-make-link-string link desc)))))

(defun my/paste-html-to-org ()
  "Convert clipboard contents from HTML to Org and then paste (yank)."
  (interactive)
  (kill-new (shell-command-to-string "osascript -e 'the clipboard as \"HTML\"' | perl -ne 'print chr foreach unpack(\"C*\",pack(\"H*\",substr($_,11,-3)))' | pandoc -f html -t json | pandoc -f json -t org"))
  (yank))
