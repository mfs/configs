;;;; [cmgr] .emacs

;(setq debug-on-error t)

(setq backup-inhibited t)
(setq auto-save-default nil)

(defun execute-current-buffer ()
  "Execute current buffer asynchronously and capture output in *scratch*."
  (interactive)
  (let ((filename buffer-file-name))
    (switch-to-buffer "*scratch*")
    (start-process filename "*scratch*" filename)))

(defun insert-shebang (lang)
  "Insert shebang line and make file executable. Error checking could be better."
  (interactive "sInterpreter:")
  (let ((m (point-marker)))
    (goto-char (point-min))
    (insert (format "#!/usr/env %s\n\n" lang))
    (goto-char m)
    (set-marker m nil))
  (set-file-modes buffer-file-name ?\755))

(global-set-key [f2] 'execute-current-buffer)

