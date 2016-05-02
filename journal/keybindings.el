(spacemacs/declare-prefix "o" "user prefix")
(spacemacs/set-leader-keys "oj" 'my/journal)
(spacemacs/set-leader-keys "oM" 'my/move-to-journal)


(spacemacs/set-leader-keys-for-major-mode 'org-mode "r" 'org-refile-and-link)
