(spacemacs/set-leader-keys "oc" 'new-frame-with-scratch)

(when (spacemacs/system-is-mac)
  ;; this is only applicable to GUI mode
  (when (display-graphic-p)
    (global-set-key (kbd "s-w") 'delete-frame)
    (global-set-key (kbd "s-n") 'new-frame-with-scratch)))
